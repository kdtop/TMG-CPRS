inherited frmdlgProb: TfrmdlgProb
  Left = 148
  Top = 108
  HelpContext = 2000
  BorderIcons = []
  Caption = 'frmdlgProb'
  ClientHeight = 595
  ClientWidth = 672
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 680
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 6
    Top = 357
    Width = 47
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Recorded'
    Visible = False
  end
  object Label5: TLabel [1]
    Left = 4
    Top = 368
    Width = 45
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Resolved'
    Visible = False
  end
  object Label7: TLabel [2]
    Left = 8
    Top = 382
    Width = 41
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Updated'
    Visible = False
  end
  object Splitter1: TSplitter [3]
    Left = 0
    Top = 418
    Width = 672
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Color = clBtnFace
    MinSize = 100
    ParentColor = False
    ExplicitTop = 306
    ExplicitWidth = 514
  end
  object pnlComments: TPanel [4]
    Left = 0
    Top = 230
    Width = 672
    Height = 188
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      672
      188)
    object Bevel1: TBevel
      Left = 3
      Top = 1
      Width = 660
      Height = 337
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExplicitWidth = 482
      ExplicitHeight = 166
    end
    object lblCmtDate: TOROffsetLabel
      Left = 10
      Top = 20
      Width = 29
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Date'
      HorzOffset = 6
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblComment: TOROffsetLabel
      Left = 75
      Top = 20
      Width = 50
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Comment'
      HorzOffset = 6
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblCom: TStaticText
      Left = 10
      Top = 6
      Width = 53
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Comments'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object bbAdd: TBitBtn
      Left = 354
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Add a new comment'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Caption = 'Add comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bbAddComClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object bbRemove: TBitBtn
      Left = 561
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Remove selected comment'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Caption = 'Remove comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = bbRemoveClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object lstComments: TORListBox
      Left = 10
      Top = 38
      Width = 653
      Height = 291
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExtendedSelect = False
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Caption = 'Comments'
      ItemTipColor = clWindow
      LongList = True
      Pieces = '1,2'
      TabPositions = '1,12'
      OnChange = ControlChange
    end
    object bbEdit: TBitBtn
      Left = 457
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Edit selected comment'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Caption = 'Edit comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bbEditClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 421
    Width = 672
    Height = 28
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      672
      28)
    object bbQuit: TBitBtn
      Left = 553
      Top = 5
      Width = 78
      Height = 21
      Hint = 'Cancel problem update...'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = bbQuitClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object bbFile: TBitBtn
      Left = 467
      Top = 5
      Width = 78
      Height = 21
      Hint = 'Submit problem update...'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = bbFileClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object ckVerify: TCheckBox
      Left = 15
      Top = 7
      Width = 130
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabStop = False
      Caption = 'Problem Verified'
      TabOrder = 2
      Visible = False
    end
    object edRecDate: TCaptionEdit
      Left = 151
      Top = 6
      Width = 94
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabStop = False
      Color = clInactiveCaptionText
      Enabled = False
      TabOrder = 3
      Text = 'Today'
      Visible = False
      OnChange = ControlChange
      Caption = 'Rec Date'
    end
    object btnProbInfo: TBitBtn
      Left = 641
      Top = 5
      Width = 21
      Height = 21
      Hint = 'Show Problem Detail'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnProbInfoClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000130B0000130B00001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDD00000000
        DDDDDD0000CCCC0000DDD0CCCCFF0CCCCC0DD0CCC0FFF0CCCC0D00CCC0F078CC
        CC0000CCCCFF00CCCC000CCCCC7FF0CCCCC00CCCCC0FF7CCCCC00CCCC070FFCC
        CCC00CCCCCFFFFCCCCC000CCCCC00CCCCC0000CCCCCC00CCCC00D0CCCCC0FFCC
        CC0DD0CCCCC0FFCCCC0DDD0000CCCC0000DDDDDD00000000DDDD}
    end
  end
  object edResDate: TCaptionEdit [6]
    Left = 151
    Top = 573
    Width = 94
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabStop = False
    Anchors = [akLeft, akBottom]
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 4
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Res Date'
  end
  object edUpdate: TCaptionEdit [7]
    Left = 151
    Top = 573
    Width = 94
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabStop = False
    Anchors = [akLeft, akBottom]
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 1
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Update'
  end
  object pnlTop: TPanel [8]
    Left = 0
    Top = 0
    Width = 672
    Height = 230
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      672
      230)
    object lblAct: TLabel
      Left = 12
      Top = 4
      Width = 34
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Activity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblLoc: TLabel
      Left = 187
      Top = 179
      Width = 28
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Clinic:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitTop = 149
    end
    object Label3: TLabel
      Left = 187
      Top = 135
      Width = 70
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Resp Provider:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitTop = 105
    end
    object Label6: TLabel
      Left = 187
      Top = 87
      Width = 69
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Date of Onset:'
    end
    object Label2: TLabel
      Left = 291
      Top = 87
      Width = 27
      Height = 13
      Anchors = [akLeft]
      Caption = 'Tags:'
    end
    object Label4: TLabel
      Left = 527
      Top = 87
      Width = 80
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Followup Interval'
      ExplicitLeft = 512
    end
    object lblICD: TLabel
      Left = 5
      Top = 55
      Width = 53
      Height = 13
      Caption = 'Linked ICD'
    end
    object lblSCT: TLabel
      Left = 5
      Top = 29
      Width = 64
      Height = 13
      Caption = 'SNOMED CT'
    end
    object rgStatus: TKeyClickRadioGroup
      Left = 9
      Top = 94
      Width = 81
      Height = 124
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Status'
      ItemIndex = 0
      Items.Strings = (
        'Active'
        'Inactive')
      TabOrder = 0
      TabStop = True
      OnClick = rgStatusClick
      OnEnter = rgStatusEnter
    end
    object rgStage: TKeyClickRadioGroup
      Left = 92
      Top = 94
      Width = 87
      Height = 124
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = 'Immediacy'
      Ctl3D = True
      ItemIndex = 2
      Items.Strings = (
        'Acute'
        'Chronic'
        '<unknown>')
      ParentCtl3D = False
      TabOrder = 2
      TabStop = True
      OnClick = ControlChange
    end
    object bbChangeProb: TBitBtn
      Left = 527
      Top = 25
      Width = 140
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Change Problem Code'
      TabOrder = 1
      OnClick = bbChangeProbClick
      Layout = blGlyphBottom
    end
    object edProb: TCaptionEdit
      Left = 151
      Top = 25
      Width = 368
      Height = 21
      Hint = 'Problem Name'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akRight, akBottom]
      Enabled = False
      TabOrder = 3
      Text = 'Problem Title'
      OnChange = edProbChange
      Caption = 'Activity'
    end
    object gbTreatment: TGroupBox
      Left = 467
      Top = 132
      Width = 196
      Height = 142
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Treatment Factors'
      TabOrder = 8
      Visible = False
      DesignSize = (
        196
        142)
      object lblYN: TLabel
        Left = 3
        Top = 12
        Width = 35
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Yes No'
      end
      object ckNSC: TCheckBox
        Left = 24
        Top = 26
        Width = 160
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Service Connected '
        Enabled = False
        TabOrder = 1
        OnClick = ckNSCClick
      end
      object ckNRad: TCheckBox
        Left = 24
        Top = 58
        Width = 154
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Radiation '
        Enabled = False
        TabOrder = 5
        OnClick = ckNSCClick
      end
      object ckNAO: TCheckBox
        Left = 24
        Top = 42
        Width = 154
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Agent Orange '
        Enabled = False
        TabOrder = 3
        OnClick = ckNSCClick
      end
      object ckNENV: TCheckBox
        Left = 24
        Top = 74
        Width = 149
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Southwest Asia Conditions'
        Enabled = False
        TabOrder = 7
        OnClick = ckNSCClick
      end
      object ckNHNC: TCheckBox
        Left = 24
        Top = 122
        Width = 149
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Head and/or Neck Cancer'
        Enabled = False
        TabOrder = 13
        OnClick = ckNSCClick
      end
      object ckNMST: TCheckBox
        Left = 24
        Top = 106
        Width = 149
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'MST'
        Enabled = False
        TabOrder = 11
        OnClick = ckNSCClick
      end
      object ckNSHAD: TCheckBox
        Left = 24
        Top = 90
        Width = 170
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Shipboard Hazard and Defense'
        TabOrder = 9
        OnClick = ckNSCClick
      end
      object ckYSC: TCheckBox
        Left = 6
        Top = 26
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 0
        OnClick = ckNSCClick
      end
      object ckYAO: TCheckBox
        Left = 6
        Top = 42
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 2
        OnClick = ckNSCClick
      end
      object ckYRad: TCheckBox
        Left = 6
        Top = 58
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 4
        OnClick = ckNSCClick
      end
      object ckYENV: TCheckBox
        Left = 6
        Top = 74
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 6
        OnClick = ckNSCClick
      end
      object ckYSHAD: TCheckBox
        Left = 6
        Top = 90
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 8
        OnClick = ckNSCClick
      end
      object ckYMST: TCheckBox
        Left = 6
        Top = 106
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 10
        OnClick = ckNSCClick
      end
      object ckYHNC: TCheckBox
        Left = 6
        Top = 122
        Width = 17
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Enabled = False
        TabOrder = 12
        OnClick = ckNSCClick
      end
    end
    object cbServ: TORComboBox
      Left = 186
      Top = 196
      Width = 275
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akRight, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service:'
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentFont = False
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 7
      Visible = False
      OnChange = ControlChange
      OnNeedData = cbServNeedData
      CharsNeedMatch = 1
    end
    object cbLoc: TORComboBox
      Left = 185
      Top = 198
      Width = 276
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akRight, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentFont = False
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 6
      OnChange = ControlChange
      OnClick = cbLocClick
      OnKeyPress = cbLocKeyPress
      OnNeedData = cbLocNeedData
      CharsNeedMatch = 1
    end
    object cbProv: TORComboBox
      Left = 186
      Top = 152
      Width = 275
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akRight, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Resp Provider'
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentFont = False
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 5
      OnChange = ControlChange
      OnClick = cbProvClick
      OnKeyPress = cbProvKeyPress
      OnNeedData = cbProvNeedData
      CharsNeedMatch = 1
    end
    object edOnsetdate: TCaptionEdit
      Left = 188
      Top = 106
      Width = 96
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      TabOrder = 9
      Text = 'Today'
      OnChange = ControlChange
      Caption = 'Date of Onset'
    end
    object edICDCode: TCaptionEdit
      Left = 75
      Top = 53
      Width = 69
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 11
      Text = 'Code'
      OnChange = ControlChange
      Caption = 'Activity'
    end
    object edtTMGTags: TCaptionEdit
      Left = 291
      Top = 106
      Width = 230
      Height = 21
      Anchors = [akLeft, akRight]
      TabOrder = 13
      OnChange = edtTMGTagsChange
    end
    object edTMGFollowup: TCaptionEdit
      Left = 527
      Top = 106
      Width = 134
      Height = 21
      Hint = 'Desired Follow up interval.  E.g. '#39'1 Y'#39' or '#39'2 M'#39', '#39'3.5 W'#39', '#39'5 D'#39
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      OnChange = edTMGFollowupChange
      Caption = 'Follow Interval'
    end
    object edICDDescription: TEdit
      Left = 151
      Top = 53
      Width = 369
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clCream
      TabOrder = 16
      Text = '(ICD Description)'
    end
    object bbChangeICD: TBitBtn
      Left = 527
      Top = 53
      Width = 140
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Change Problem ICD Code'
      TabOrder = 17
      OnClick = bbICDCodeChangeClick
      Layout = blGlyphBottom
    end
    object edSCTCode: TCaptionEdit
      Left = 75
      Top = 25
      Width = 69
      Height = 21
      Color = clCream
      ReadOnly = True
      TabOrder = 18
      Text = 'Code'
      OnChange = ControlChange
      Caption = 'Activity'
    end
  end
  object pnlLinkedNotes: TPanel [9]
    Left = 0
    Top = 449
    Width = 672
    Height = 146
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Constraints.MinHeight = 100
    TabOrder = 7
    DesignSize = (
      672
      146)
    object pnlLinkedProbs: TPanel
      Left = 10
      Top = 3
      Width = 687
      Height = 141
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      OnResize = pnlLinkedProbsResize
      DesignSize = (
        687
        141)
      object bbAddToNote: TBitBtn
        Left = 6
        Top = 3
        Width = 144
        Height = 24
        Hint = 'Add document for this problem to note currently being edited.'
        Caption = 'Add to &Current Note'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bbAddToNoteClick
        Glyph.Data = {
          42040000424D4204000000000000420000002800000010000000100000000100
          20000300000000040000130B0000130B00000000000000000000000000FF0000
          FF0000FF0000FFFF00FFFFFF00FFFF9E009EFF121611FF1B1A1AFF1B1A1AFF1B
          1A1AFF1B1A1AFF1B1A1AFF1B1A1AFF1B1A1AFF1B1A1AFF121611FF9E009EFFFF
          00FFFFFF00FFFFFF00FFFF5E005EFF434A40FFE2E0DFFFE7E6E5FFE7E5E5FFE7
          E5E5FFE7E5E5FFE7E5E5FFE7E5E5FFE7E5E5FFE7E5E5FFE2E0DFFF434A40FF5E
          005EFFFF00FFFFFF00FFFF2B002BFFA3A2A0FFFFFFFFFFF4F4F4FFF6F6F6FFF7
          F7F7FFF4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA3A2A0FF2B
          002BFFFF00FFFFFF00FFFF2B002BFFA3A2A0FFFFFFFFFFD0D0D0FFD2D2D2FFD1
          D1D1FFCFCFCFFFDFDFDFFFE2E2E2FFD7D7D7FFF2F2F2FFFFFFFFFFA3A2A0FF2B
          002BFFFF00FFFFFF00FFFF2B002BFFA5A3A1FFFFFFFFFFCBCBCAFFCBCBCBFFD4
          D3D3FFBCBCE1FF2E2EF7FFD6D6D6FFDFDEDEFFFDFCFCFFFFFFFEFFA5A3A1FF2B
          002BFFFF00FFFFFF00FFFF2B002BFFA5A4A3FFFFFFFFFFD3D2D2FFD2D2D1FFD1
          D1D1FFACACDEFF0000FFFFDBDADAFFDAD9D9FFD3D3D3FFFFFFFFFFA5A4A3FF2B
          002BFFFF00FFFFFF00FFFF2A002BFFA6A5A4FFFFFFFFFFCBCBCBFFB6B5D5FF4D
          4DEDFF3F3FEEFF0000FFFF5656EBFF4746EDFFD4D4D3FFF9F8F8FFA6A5A4FF2A
          002BFFFF00FFFFFF00FFFF2A002AFFA7A6A5FFFEFDFCFFCBCBCAFFA9A8DAFF00
          00FEFF0303FDFF0000FFFF0505FDFF0000FFFFF3F1F1FFFBFAF9FFA6A5A4FF2A
          002BFFFF00FFFFFF00FFFF2A002AFFA8A7A6FFFBFBF9FFCBCACAFFD3D2D1FFC8
          C7C7FFA9A8CEFF0000FFFFCDCCCBFFCCCBCBFFD3D2D2FFF9F7F6FFA3A19FFF2B
          002BFFFF00FFFFFF00FFFF2A002AFFA8A8A7FFFAF8F6FFC8C7C6FFC7C5C4FFC9
          C8C6FFA5A4D8FF0000FFFFCCCBCAFFC6C5C3FFD5D3D2FFEEECE9FF989490FF2B
          002CFFFF00FFFFFF00FFFF2A002AFFA9A9A8FFF7F5F3FFC7C5C4FFC1C0BEFFC9
          C7C5FFBFBEBCFFCAC8C7FFD3D2D2FFD2D0CEFFC6C3BFFFDAD3CCFF807970FF2D
          002EFFFF00FFFFFF00FFFF2A002AFFAAA9A8FFF2F0EEFFC9C7C5FFC9C7C6FFC7
          C6C3FFC8C7C5FFD2D0CEFFE3E0DCFFE7E3DFFFEAE7E4FFE9E6E2FF474443FF22
          0022FFFF00FFFFFF00FFFF2A002AFFAAA9A9FFF5F3F0FF737170FFACAAA8FF9D
          9B99FF989694FF9A9997FFD1CBC4FFECEAE7FFE7E4E0FF777977FF140014FFFF
          00FFFFFF00FFFFFF00FFFF2A002AFFADACABFFE9E5E1FFEAE6E2FFE8E4E0FFE8
          E4E1FFE6E2DFFFDFDBD6FFD1C9C2FFF0EEEBFF5C5A5CFF150015FFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFF5E005EFF4B544BFFE1DFDEFFDEDCD9FFDEDCD9FFDD
          DAD8FFD7D3CFFFC5BFB8FFB5AAA0FF797D7BFF150015FFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFF9E009EFF161B16FF202020FF1F1F1FFF1F
          1F1FFF1E1D1DFF1A1918FF161413FF260026FFFE00FEFFFF00FFFFFF00FFFFFF
          00FFFFFF00FF}
      end
      object sgLinkedDocs: TStringGrid
        Left = 1
        Top = 30
        Width = 685
        Height = 110
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelEdges = [beTop, beRight]
        ColCount = 3
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goColSizing, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 1
        OnDblClick = btnViewLinkedDocClick
        OnSelectCell = sgLinkedDocsSelectCell
      end
      object btnViewLinkedDoc: TBitBtn
        Left = 505
        Top = 3
        Width = 147
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&View Linked Document'
        Enabled = False
        TabOrder = 2
        OnClick = btnViewLinkedDocClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
          9E009E1216111B1A1A1B1A1A1B1A1A1B1A1A1B1A1A1B1A1A1B1A1A1B1A1A1216
          119E009EFF00FFFF00FFFF00FF5E005E434A40E2E0DFE7E6E5E7E5E5E7E5E5E7
          E5E5E7E5E5E7E5E5E7E5E5E7E5E5E2E0DF434A405E005EFF00FFFF00FF2B002B
          A3A2A0FFFFFFF4F4F4F6F6F6F7F7F7F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFA3A2A02B002BFF00FFFF00FF2B002BA3A2A0FFFFFFD0D0D0D2D2D2D1D1D1CF
          CFCFDFDFDFE2E2E2D7D7D7F2F2F2FFFFFFA3A2A02B002BFF00FFFF00FF2B002B
          A5A3A1FFFFFFCBCBCACBCBCBD4D3D3DCDCDCDDDCDCD6D6D6DFDEDEFDFCFCFFFF
          FEA5A3A12B002BFF00FFFF00FF2B002BA5A4A3FFFFFFD3D2D2D2D2D1D1D1D1D7
          D7D7DBDADADBDADADAD9D9D3D3D3FFFFFFA5A4A32B002BFF00FFFF00FF2A002B
          A6A5A4FFFFFFCBCBCBD1D0D0D0D0CFCCCCCBCBCBCAD0D0CFCECDCDD4D4D3F9F8
          F8A6A5A42A002BFF00FFFF00FF2A002AA7A6A5FEFDFCCBCBCAD3D2D2CECECDC9
          C8C7CECECDD2D3D1D6D4D4F3F1F1FBFAF9A6A5A42A002BFF00FFFF00FF2A002A
          A8A7A6FBFBF9CBCACAD3D2D1C8C7C7C8C7C6C8C7C7CDCCCBCCCBCBD4D3D2F9F7
          F6A3A19F2B002BFF00FFFF00FF2A002AA8A8A7FAF8F6C8C7C6C7C5C4C9C8C6D1
          D0CFC5C3C3CCCBCAC6C5C3D5D3D2EEECE99894902B002CFF00FFFF00FF2A002A
          A9A9A8F7F5F3C7C5C4C1C0BEC9C7C5BFBEBCCAC8C7D4D3D2D2D0CEC6C3BFDAD3
          CC8079702D002EFF00FFFF00FF2A002AAAA9A8F2F0EEC9C7C5C9C7C6C7C6C3C8
          C7C5D2D0CEE3E0DCE7E3DFEAE7E4E9E6E2474443220022FF00FFFF00FF2A002A
          AAA9A9F5F3F0737170ACAAA89D9B999896949A9997D1CBC4ECEAE7E7E4E07779
          77140014FF00FFFF00FFFF00FF2A002AADACABE9E5E1EAE6E2E8E4E0E8E4E1E6
          E2DFDFDBD6D1C9C2F0EEEB5C5A5C150015FF00FFFF00FFFF00FFFF00FF5E005E
          4B544BE1DFDEDEDCD9DEDCD9DDDAD8D7D3CFC5BFB8B5AAA0797D7B150015FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF9E009E161B162020201F1F1F1F1F1F1E
          1D1D1A1918161413260026FE00FEFF00FFFF00FFFF00FFFF00FF}
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 472
    Data = (
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = lblCom'
        'Status = stsDefault')
      (
        'Component = bbAdd'
        'Status = stsDefault')
      (
        'Component = bbRemove'
        'Status = stsDefault')
      (
        'Component = lstComments'
        'Status = stsDefault')
      (
        'Component = bbEdit'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = bbQuit'
        'Status = stsDefault')
      (
        'Component = bbFile'
        'Status = stsDefault')
      (
        'Component = ckVerify'
        'Status = stsDefault')
      (
        'Component = edRecDate'
        'Label = Label1'
        'Status = stsOK')
      (
        'Component = edResDate'
        'Status = stsDefault')
      (
        'Component = edUpdate'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = rgStatus'
        'Status = stsDefault')
      (
        'Component = rgStage'
        'Status = stsDefault')
      (
        'Component = bbChangeProb'
        'Status = stsDefault')
      (
        'Component = edProb'
        'Status = stsDefault')
      (
        'Component = gbTreatment'
        'Status = stsDefault')
      (
        'Component = ckNSC'
        'Status = stsDefault')
      (
        'Component = ckNRad'
        'Status = stsDefault')
      (
        'Component = ckNAO'
        'Status = stsDefault')
      (
        'Component = ckNENV'
        'Status = stsDefault')
      (
        'Component = ckNHNC'
        'Status = stsDefault')
      (
        'Component = ckNMST'
        'Status = stsDefault')
      (
        'Component = ckNSHAD'
        'Status = stsDefault')
      (
        'Component = cbServ'
        'Status = stsDefault')
      (
        'Component = cbLoc'
        'Label = lblLoc'
        'Status = stsOK')
      (
        'Component = cbProv'
        'Text = Responsible Provider'
        'Status = stsOK')
      (
        'Component = edOnsetdate'
        'Status = stsDefault')
      (
        'Component = frmdlgProb'
        'Status = stsDefault')
      (
        'Component = ckYSC'
        'Status = stsDefault')
      (
        'Component = ckYAO'
        'Status = stsDefault')
      (
        'Component = ckYRad'
        'Status = stsDefault')
      (
        'Component = ckYENV'
        'Status = stsDefault')
      (
        'Component = ckYSHAD'
        'Status = stsDefault')
      (
        'Component = ckYMST'
        'Status = stsDefault')
      (
        'Component = ckYHNC'
        'Status = stsDefault')
      (
        'Component = pnlLinkedNotes'
        'Status = stsDefault')
      (
        'Component = bbAddToNote'
        'Status = stsDefault')
      (
        'Component = edICDCode'
        'Status = stsDefault')
      (
        'Component = pnlLinkedProbs'
        'Status = stsDefault')
      (
        'Component = sgLinkedDocs'
        'Status = stsDefault')
      (
        'Component = btnViewLinkedDoc'
        'Status = stsDefault')
      (
        'Component = edtTMGTags'
        'Status = stsDefault')
      (
        'Component = edTMGFollowup'
        'Status = stsDefault')
      (
        'Component = edICDDescription'
        'Status = stsDefault')
      (
        'Component = bbChangeICD'
        'Status = stsDefault')
      (
        'Component = edSCTCode'
        'Status = stsDefault')
      (
        'Component = btnProbInfo'
        'Status = stsDefault'))
  end
end
