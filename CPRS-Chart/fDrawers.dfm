inherited frmDrawers: TfrmDrawers
  Left = 284
  Top = 320
  BorderStyle = bsNone
  Caption = 'frmDrawers'
  ClientHeight = 365
  ClientWidth = 189
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 189
  ExplicitHeight = 365
  PixelsPerInch = 96
  TextHeight = 13
  object pnlRemindersButton: TKeyClickPanel [0]
    Left = 0
    Top = 193
    Width = 189
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Reminders'
    TabOrder = 4
    TabStop = True
    OnClick = sbRemindersClick
    OnEnter = pnlTemplatesButtonEnter
    OnExit = pnlTemplatesButtonExit
    object sbReminders: TORAlignSpeedButton
      Left = 0
      Top = 0
      Width = 189
      Height = 22
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Reminders'
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
      Margin = 60
      NumGlyphs = 4
      Spacing = 2
      OnClick = sbRemindersClick
      OnResize = sbResize
    end
  end
  object pnlEncounterButton: TKeyClickPanel [1]
    Left = 0
    Top = 107
    Width = 189
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Encounter'
    TabOrder = 2
    TabStop = True
    OnClick = sbEncounterClick
    OnEnter = pnlTemplatesButtonEnter
    OnExit = pnlTemplatesButtonExit
    object sbEncounter: TORAlignSpeedButton
      Left = 0
      Top = 0
      Width = 189
      Height = 22
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Encounter'
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
      Margin = 60
      NumGlyphs = 4
      Spacing = 2
      OnClick = sbEncounterClick
      OnResize = sbResize
    end
  end
  object pnlTemplatesButton: TKeyClickPanel [2]
    Left = 0
    Top = 0
    Width = 189
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Templates'
    TabOrder = 0
    TabStop = True
    OnClick = sbTemplatesClick
    OnEnter = pnlTemplatesButtonEnter
    OnExit = pnlTemplatesButtonExit
    object sbTemplates: TORAlignSpeedButton
      Left = 0
      Top = 0
      Width = 189
      Height = 22
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Templates'
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
      Margin = 60
      NumGlyphs = 4
      PopupMenu = popTemplates
      Spacing = 2
      OnClick = sbTemplatesClick
      OnResize = sbResize
      ExplicitTop = -6
    end
  end
  object pnlOrdersButton: TKeyClickPanel [3]
    Left = 0
    Top = 279
    Width = 189
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Orders'
    TabOrder = 6
    TabStop = True
    OnClick = sbOrdersClick
    OnEnter = pnlTemplatesButtonEnter
    OnExit = pnlTemplatesButtonExit
    object sbOrders: TORAlignSpeedButton
      Left = 0
      Top = 0
      Width = 189
      Height = 22
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Orders'
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
      Margin = 60
      NumGlyphs = 4
      Spacing = 11
      OnClick = sbOrdersClick
      OnResize = sbResize
    end
  end
  object lbOrders: TORListBox [4]
    Left = 0
    Top = 301
    Width = 189
    Height = 64
    Align = alTop
    ItemHeight = 13
    Items.Strings = (
      'Orders')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Visible = False
    Caption = 'Orders'
    ItemTipColor = clWindow
    LongList = False
  end
  object lbEncounter: TORListBox [5]
    Left = 0
    Top = 129
    Width = 189
    Height = 64
    Align = alTop
    ItemHeight = 13
    Items.Strings = (
      'Encounter')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    Caption = 'Encounter'
    ItemTipColor = clWindow
    LongList = False
  end
  object pnlTemplates: TPanel [6]
    Left = 0
    Top = 22
    Width = 189
    Height = 85
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object tvTemplates: TORTreeView
      Left = 0
      Top = 38
      Width = 189
      Height = 47
      Align = alClient
      DragMode = dmAutomatic
      HideSelection = False
      Images = dmodShared.imgTemplates
      Indent = 19
      ParentShowHint = False
      PopupMenu = popTemplates
      ReadOnly = True
      RightClickSelect = True
      ShowHint = False
      TabOrder = 1
      OnClick = tvTemplatesClick
      OnCollapsing = tvTemplatesCollapsing
      OnDblClick = tvTemplatesDblClick
      OnExpanding = tvTemplatesExpanding
      OnGetImageIndex = tvTemplatesGetImageIndex
      OnGetSelectedIndex = tvTemplatesGetSelectedIndex
      OnKeyDown = tvTemplatesKeyDown
      OnKeyUp = tvTemplatesKeyUp
      Caption = 'Templates'
      NodePiece = 2
      OnDragging = tvTemplatesDragging
    end
    object pnlTemplateSearch: TPanel
      Left = 0
      Top = 0
      Width = 189
      Height = 38
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlTemplateSearchResize
      DesignSize = (
        189
        38)
      object btnFind: TORAlignButton
        Left = 134
        Top = 0
        Width = 55
        Height = 21
        Hint = 'Find Template'
        Anchors = [akTop, akRight]
        Caption = 'Find'
        ParentShowHint = False
        PopupMenu = popTemplates
        ShowHint = True
        TabOrder = 1
        OnClick = btnFindClick
      end
      object edtSearch: TCaptionEdit
        Left = 0
        Top = 0
        Width = 134
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = edtSearchChange
        OnEnter = edtSearchEnter
        OnExit = edtSearchExit
        Caption = 'Text to find'
      end
      object cbMatchCase: TCheckBox
        Left = 0
        Top = 21
        Width = 80
        Height = 17
        Caption = 'Match Case'
        TabOrder = 2
        OnClick = cbFindOptionClick
      end
      object cbWholeWords: TCheckBox
        Left = 80
        Top = 21
        Width = 109
        Height = 17
        Caption = 'Whole Words Only'
        TabOrder = 3
        OnClick = cbFindOptionClick
      end
      object btnMultiSearch: TBitBtn
        Left = 348
        Top = 0
        Width = 21
        Height = 21
        Hint = 'Quick Search'
        Anchors = [akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = btnMultiSearchClick
        Glyph.Data = {
          42040000424D4204000000000000420000002800000010000000100000000100
          20000300000000040000130B0000130B00000000000000000000000000FF0000
          FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFF4059BFFF0077AAFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F3CD5FF0079ACFF0079ACFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF007CAFFF00B8EBFF00
          7CAFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F3FD8FF00A6D9FF00
          B9ECFF007FB2FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF0082B5FF00
          BBEEFF00B9ECFF0082B5FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F43DBFF07
          ABDCFF06BAEBFF0ABDEDFF0086B9FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFF4067CDFF008ABDFF008ABDFF008ABDFF008ABDFF09
          9DCEFF05B0E2FF0BB8E8FF19C1EEFF008ABDFFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFF7F47DFFF1DB4E0FF1CC1EEFF1CC1EEFF1CC1EEFF15
          BCEAFF0BB3E3FF00AADDFF0EB6E5FF2BC6EFFF008EC1FFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFF0093C6FF33CBF2FF33CAF2FF39CFF4FF47
          D7FAFF50DDFEFF50DDFEFF49D8FBFF46D7FAFF3ECCF1FF0093C6FFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFF7F4BE4FF38BEE5FF6FE5FFFF6FE5FFFF6F
          E5FFFFA6F2FFFFDDFFFFFFDDFFFFFFDDFFFFFFDDFFFFFFA6E5F2FF0097CAFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF009BCEFF8AECFFFF8AECFFFF8A
          ECFFFF8AECFFFF67D8F3FF23AFDAFF009BCEFF009BCEFF009BCEFF009BCEFF40
          74DAFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F4FE8FF52C9E9FFA4F2FFFFA4
          F2FFFFA4F2FFFFA4F2FFFF7BDDF4FF009FD2FFFF00FFFFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF00A2D5FFBBF7FFFFBB
          F7FFFFBBF7FFFFBBF7FFFFBBF7FFFF8CE2F4FF00A2D5FFFF00FFFFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F52EBFF68D1ECFFCF
          FCFFFFCFFCFFFFCFFCFFFFCFFCFFFFCFFCFFFF9BE6F5FF00A5D8FFFF00FFFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF00A8DBFFDD
          FFFFFFDDFFFFFFDDFFFFFFDDFFFFFFDDFFFFFFDDFFFFFFA6E9F6FF00A8DBFFFF
          00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF7F55EDFF17
          B3E0FF37BFE6FF58CCEBFF6FD5EEFF6FD5EEFF58CCEBFF37BFE6FF17B3E0FF40
          7FE5FFFF00FF}
      end
    end
  end
  object tvReminders: TORTreeView [7]
    Left = 0
    Top = 215
    Width = 189
    Height = 64
    HelpContext = 11300
    Align = alTop
    HideSelection = False
    Images = dmodShared.imgReminders
    Indent = 23
    ReadOnly = True
    RightClickSelect = True
    StateImages = dmodShared.imgReminders
    TabOrder = 5
    OnCollapsed = tvRemindersCurListChanged
    OnExpanded = tvRemindersCurListChanged
    OnKeyDown = tvRemindersKeyDown
    OnMouseUp = tvRemindersMouseUp
    Caption = 'Reminders'
    NodePiece = 0
    OnNodeCaptioning = tvRemindersNodeCaptioning
  end
  object pnlProblemsButton: TKeyClickPanel [8]
    Left = 0
    Top = 365
    Width = 189
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Problems'
    TabOrder = 11
    TabStop = True
    OnClick = sbOrdersClick
    OnEnter = pnlTemplatesButtonEnter
    OnExit = pnlTemplatesButtonExit
    object sbProblems: TORAlignSpeedButton
      Left = 0
      Top = 0
      Width = 189
      Height = 22
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Problems'
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
      Margin = 60
      NumGlyphs = 4
      Spacing = 2
      OnClick = sbProblemsClick
      OnResize = sbResize
    end
  end
  object tvProblems: TORTreeView [9]
    Left = 0
    Top = 387
    Width = 189
    Height = 64
    Hint = ' '
    Align = alTop
    HideSelection = False
    Images = dmodShared.imgTemplates
    Indent = 23
    ParentShowHint = False
    PopupMenu = popProblems
    ReadOnly = True
    RightClickSelect = True
    ShowHint = True
    StateImages = dmodShared.imgReminders
    TabOrder = 12
    OnDblClick = tvProblemsDblClick
    OnMouseMove = tvProblemsMouseMove
    Caption = 'Problems'
    NodePiece = 0
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 72
    Top = 72
    Data = (
      (
        'Component = pnlRemindersButton'
        'Status = stsDefault')
      (
        'Component = pnlEncounterButton'
        'Status = stsDefault')
      (
        'Component = pnlTemplatesButton'
        'Status = stsDefault')
      (
        'Component = pnlOrdersButton'
        'Status = stsDefault')
      (
        'Component = lbOrders'
        'Status = stsDefault')
      (
        'Component = lbEncounter'
        'Status = stsDefault')
      (
        'Component = pnlTemplates'
        'Status = stsDefault')
      (
        'Component = tvTemplates'
        'Status = stsDefault')
      (
        'Component = pnlTemplateSearch'
        'Status = stsDefault')
      (
        'Component = btnFind'
        'Status = stsDefault')
      (
        'Component = edtSearch'
        'Status = stsDefault')
      (
        'Component = cbMatchCase'
        'Status = stsDefault')
      (
        'Component = cbWholeWords'
        'Status = stsDefault')
      (
        'Component = tvReminders'
        'Status = stsDefault')
      (
        'Component = frmDrawers'
        'Status = stsDefault')
      (
        'Component = btnMultiSearch'
        'Status = stsDefault')
      (
        'Component = pnlProblemsButton'
        'Status = stsDefault')
      (
        'Component = tvProblems'
        'Status = stsDefault'))
  end
  object popTemplates: TPopupMenu
    OnPopup = popTemplatesPopup
    Left = 8
    Top = 70
    object mnuCopyTemplate: TMenuItem
      Caption = 'Copy Template Text'
      ShortCut = 16451
      OnClick = mnuCopyTemplateClick
    end
    object mnuInsertTemplate: TMenuItem
      Caption = '&Insert Template'
      ShortCut = 16429
      OnClick = mnuInsertTemplateClick
    end
    object mnuPreviewTemplate: TMenuItem
      Caption = '&Preview/Print Template'
      ShortCut = 16471
      OnClick = mnuPreviewTemplateClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuGotoDefault: TMenuItem
      Caption = '&Goto Default'
      ShortCut = 16455
      OnClick = mnuGotoDefaultClick
    end
    object mnuDefault: TMenuItem
      Caption = '&Mark as Default'
      ShortCut = 16416
      OnClick = mnuDefaultClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuViewNotes: TMenuItem
      Caption = '&View Template Notes'
      ShortCut = 16470
      OnClick = mnuViewNotesClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuFindTemplates: TMenuItem
      Caption = '&Find Templates'
      ShortCut = 16454
      OnClick = mnuFindTemplatesClick
    end
    object mnuCollapseTree: TMenuItem
      Caption = '&Collapse Tree'
      OnClick = mnuCollapseTreeClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuEditTemplates: TMenuItem
      Caption = '&Edit Templates'
      OnClick = mnuEditTemplatesClick
    end
    object mnuNewTemplate: TMenuItem
      Caption = 'Create &New Template'
      OnClick = mnuNewTemplateClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuViewTemplateIconLegend: TMenuItem
      Caption = 'Template Icon Legend'
      OnClick = mnuViewTemplateIconLegendClick
    end
    object N6: TMenuItem
      Caption = '-'
      Visible = False
    end
    object mnuTMGInsertIntoHTML: TMenuItem
      Caption = 'TEST Insert into HTML'
      Visible = False
      OnClick = InsertEmbeddedDlgIntoHTML
    end
  end
  object fldAccessTemplates: TVA508ComponentAccessibility
    Component = pnlTemplatesButton
    OnStateQuery = fldAccessTemplatesStateQuery
    OnInstructionsQuery = fldAccessTemplatesInstructionsQuery
    ComponentName = 'Drawer'
    Left = 104
    Top = 72
  end
  object fldAccessReminders: TVA508ComponentAccessibility
    Component = pnlRemindersButton
    OnStateQuery = fldAccessRemindersStateQuery
    OnInstructionsQuery = fldAccessRemindersInstructionsQuery
    ComponentName = 'Drawer'
    Left = 128
    Top = 232
  end
  object imgLblReminders: TVA508ImageListLabeler
    Components = <
      item
        Component = tvReminders
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblReminders
    Left = 96
    Top = 232
  end
  object imgLblTemplates: TVA508ImageListLabeler
    Components = <
      item
        Component = tvTemplates
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 136
    Top = 72
  end
  object popProblems: TPopupMenu
    OnPopup = popProblemsPopup
    Left = 112
    Top = 148
    object mnuEditProblem: TMenuItem
      Caption = '&Edit Problem'
      OnClick = mnuEditProblemClick
    end
    object mnuNewProblem: TMenuItem
      Caption = '&Add New Problem'
      OnClick = mnuNewProblemClick
    end
    object popAutoAddProblems: TMenuItem
      Caption = 'Add New Problem From &Topics'
      OnClick = popAutoAddProblemsClick
    end
    object mnuCopyProbName: TMenuItem
      Caption = '&Copy Problem Name To Clipboard'
      OnClick = mnuCopyProbNameClick
    end
    object mnuInsertProbName: TMenuItem
      Caption = '&Insert Problem Name'
      OnClick = mnuInsertProbNameClick
    end
    object RefreshProblemList1: TMenuItem
      Caption = '&Refresh Problem List'
      OnClick = RefreshProblemList1Click
    end
  end
end
