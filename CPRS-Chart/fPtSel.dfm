inherited frmPtSel: TfrmPtSel
  Left = 145
  Top = 113
  BorderIcons = []
  Caption = 'Patient Selection'
  ClientHeight = 559
  ClientWidth = 780
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 788
  ExplicitHeight = 593
  PixelsPerInch = 96
  TextHeight = 13
  object sptVert: TSplitter [0]
    Left = 0
    Top = 290
    Width = 780
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 785
  end
  object pnlDivide: TORAutoPanel [1]
    Left = 0
    Top = 294
    Width = 780
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 0
    Visible = False
    object lblNotifications: TLabel
      Left = 4
      Top = 4
      Width = 58
      Height = 13
      Caption = 'Notifications'
    end
    object ggeInfo: TGauge
      Left = 212
      Top = 1
      Width = 100
      Height = 15
      BackColor = clHighlightText
      Color = clBtnFace
      ForeColor = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Progress = 0
      Visible = False
    end
  end
  object pnlPtSel: TORAutoPanel [2]
    Left = 0
    Top = 0
    Width = 780
    Height = 290
    Align = alTop
    BevelWidth = 2
    TabOrder = 3
    OnResize = pnlPtSelResize
    DesignSize = (
      780
      290)
    object lblPatient: TLabel
      Left = 216
      Top = 4
      Width = 33
      Height = 13
      Caption = 'Patient'
      ShowAccelChar = False
    end
    object cboPatient: TORComboBox
      Left = 216
      Top = 23
      Width = 272
      Height = 261
      Hint = 'Enter name or use "Last 4" (x1234) format'
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Patient'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20,25,30'
      TabOrder = 1
      OnChange = cboPatientChange
      OnDblClick = cboPatientDblClick
      OnEnter = cboPatientEnter
      OnExit = cboPatientExit
      OnKeyDown = cboPatientKeyDown
      OnKeyUp = cboPatientKeyUp
      OnKeyPause = cboPatientKeyPause
      OnMouseClick = cboPatientMouseClick
      OnNeedData = cboPatientNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cmdOK: TButton
      Left = 692
      Top = 9
      Width = 78
      Height = 21
      Anchors = [akTop]
      Caption = 'OK'
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 692
      Top = 36
      Width = 78
      Height = 21
      Anchors = [akTop]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object cmdSaveList: TButton
      Left = 494
      Top = 252
      Width = 175
      Height = 21
      Caption = 'Save Patient List Settings'
      TabOrder = 0
      OnClick = cmdSaveListClick
    end
    object TMGcmdAdd: TButton
      Left = 523
      Top = 20
      Width = 75
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Add Patient'
      TabOrder = 5
      OnClick = TMGcmdAddClick
    end
    object btnSearchPt: TBitBtn
      Left = 492
      Top = 20
      Width = 25
      Height = 27
      Hint = 'Advanced Search'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = False
      TabOrder = 6
      OnClick = btnSearchPtClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBF
        BF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFBFBFBF6060607070707F7F7FFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF606060A0A0
        A0606060BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFBFBFBF606060A0A0A0606060BFBFBFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF606060A0A0A0606060BFBF
        BFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFFBFBFBF
        BFBF606060A0A0A0606060BF7FBFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF3F3FFF0000FF7F7FFF7F7FFF0000DF2020A0A0A0606060BFBFBFFFBFFFFFBF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFF
        3F3F7F4040BFBFBFFFFFFFFF7FFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F
        FFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFFFFFFFFFFFFFF7FFFFF7F
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFF7F7F7FBFBFBFFFFFFFFFFFFFFF
        FFFFFF0000FFFFFFFFFFFFFF7FFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
        BFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF3F
        FFFF3FFFFFFFFFFFFFFFFFFFFFFF7F7FFF7F7FBFBFBFBFBFBF7F7F7FFFFFFFFF
        7F7FFF7F7FFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFFF7FFFFFFFFFFFFFFFFFFFFF
        FF0000FF7F7FBFBFBFFFFFFFFF7F7FFF0000FFFFFFFFBFFFFFBFFFFFFFFFFFFF
        FFFF3FFFFF7FFFFFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FF3F3FFF
        BFBFFFFFFFFFBFFFFF00FFFF7FFFFF3FFFFF3FFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFF7FFFFF7F
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
    object RadioGroup1: TRadioGroup
      Left = 494
      Top = 181
      Width = 281
      Height = 65
      Caption = 'Specific "In-Depth" Lookup by '
      ItemIndex = 0
      Items.Strings = (
        '&None of the below'
        '&PHONE NUMBER [RESIDENCE]'
        '&DATE OF BIRTH')
      TabOrder = 4
      OnClick = onclick1
    end
  end
  object pnlNotifications: TORAutoPanel [3]
    Left = 0
    Top = 524
    Width = 780
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object txtCmdComments: TVA508StaticText
      Name = 'txtCmdComments'
      Left = 441
      Top = 0
      Width = 159
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Show Comments Button Disabled'
      TabOrder = 6
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdRemove: TVA508StaticText
      Name = 'txtCmdRemove'
      Left = 577
      Top = 0
      Width = 120
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Remove Button Disabled'
      TabOrder = 9
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdForward: TVA508StaticText
      Name = 'txtCmdForward'
      Left = 344
      Top = 0
      Width = 118
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Forward Button Disabled'
      TabOrder = 7
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdProcess: TVA508StaticText
      Name = 'txtCmdProcess'
      Left = 232
      Top = 0
      Width = 118
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Process Button Disabled'
      TabOrder = 8
      Visible = False
      ShowAccelChar = True
    end
    object cmdProcessInfo: TButton
      Left = 11
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process Info'
      TabOrder = 0
      OnClick = cmdProcessInfoClick
    end
    object cmdProcessAll: TButton
      Left = 120
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process All'
      TabOrder = 1
      OnClick = cmdProcessAllClick
    end
    object cmdProcess: TButton
      Left = 229
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process'
      Enabled = False
      TabOrder = 2
      OnClick = cmdProcessClick
    end
    object cmdForward: TButton
      Left = 335
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Forward'
      Enabled = False
      TabOrder = 3
      OnClick = cmdForwardClick
    end
    object cmdRemove: TButton
      Left = 577
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Remove'
      Enabled = False
      TabOrder = 5
      OnClick = cmdRemoveClick
    end
    object cmdComments: TButton
      Left = 441
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Show Comments'
      Enabled = False
      TabOrder = 4
      OnClick = cmdCommentsClick
    end
  end
  object lstvAlerts: TCaptionListView [4]
    Left = 0
    Top = 311
    Width = 780
    Height = 213
    Align = alClient
    Columns = <
      item
        Caption = 'Info'
        Width = 30
      end
      item
        Caption = 'Patient'
        Tag = 1
        Width = 120
      end
      item
        Caption = 'Location'
        Tag = 2
        Width = 60
      end
      item
        Caption = 'Urgency'
        Tag = 3
        Width = 67
      end
      item
        Caption = 'Alert Date/Time'
        Tag = 4
        Width = 110
      end
      item
        Caption = 'Message'
        Tag = 5
        Width = 280
      end
      item
        Caption = 'Forwarded By/When'
        Tag = 6
        Width = 180
      end>
    HideSelection = False
    HoverTime = 0
    IconOptions.WrapText = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = popNotifications
    ShowWorkAreas = True
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lstvAlertsColumnClick
    OnCompare = lstvAlertsCompare
    OnDblClick = lstvAlertsDblClick
    OnInfoTip = lstvAlertsInfoTip
    OnKeyDown = lstvAlertsKeyDown
    OnSelectItem = lstvAlertsSelectItem
    Caption = 'Notifications'
  end
  object pnlPatientImage: TPanel [5]
    Left = 620
    Top = 10
    Width = 45
    Height = 45
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      45
      45)
    object PatientImage: TImage
      Left = 0
      Top = 0
      Width = 35
      Height = 35
      Cursor = crHandPoint
      Hint = 'Patient Photo ID Thumbnail.  Click to Enlarge.'
      Anchors = [akRight]
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
      Stretch = True
      OnClick = PatientImageClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlDivide'
        'Status = stsDefault')
      (
        'Component = pnlPtSel'
        'Status = stsDefault')
      (
        'Component = cboPatient'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdSaveList'
        'Status = stsDefault')
      (
        'Component = pnlNotifications'
        'Status = stsDefault')
      (
        'Component = cmdProcessInfo'
        'Status = stsDefault')
      (
        'Component = cmdProcessAll'
        'Status = stsDefault')
      (
        'Component = cmdProcess'
        'Status = stsDefault')
      (
        'Component = cmdForward'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = lstvAlerts'
        'Status = stsDefault')
      (
        'Component = frmPtSel'
        'Status = stsDefault')
      (
        'Component = cmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdRemove'
        'Status = stsDefault')
      (
        'Component = txtCmdForward'
        'Status = stsDefault')
      (
        'Component = txtCmdProcess'
        'Status = stsDefault')
      (
        'Component = pnlPatientImage'
        'Status = stsDefault'))
  end
  object popNotifications: TPopupMenu
    Left = 508
    Top = 323
    object mnuProcess: TMenuItem
      Caption = 'Process'
      OnClick = cmdProcessClick
    end
    object mnuForward: TMenuItem
      Caption = 'Forward'
      OnClick = cmdForwardClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuRemove: TMenuItem
      Caption = 'Remove'
      OnClick = cmdRemoveClick
    end
  end
end
