inherited frmPCELex: TfrmPCELex
  Left = 239
  Top = 88
  Caption = 'Lookup Other Diagnosis'
  ClientHeight = 442
  ClientWidth = 624
  Constraints.MinHeight = 476
  Constraints.MinWidth = 632
  Font.Name = 'Tahoma'
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = nil
  OnShow = FormShow
  ExplicitWidth = 640
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDialog: TPanel [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 417
    Align = alClient
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 0
      Top = 386
      Width = 624
      Height = 31
      Align = alBottom
      BevelEdges = []
      BevelOuter = bvNone
      Constraints.MaxHeight = 33
      Constraints.MinHeight = 25
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      TabOrder = 2
      DesignSize = (
        624
        31)
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 467
        Top = 3
        Width = 70
        Height = 25
        Hint = 'Click to accept selected term.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = '&OK'
        Enabled = False
        TabOrder = 1
        OnClick = cmdOKClick
      end
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 543
        Top = 3
        Width = 70
        Height = 25
        Hint = 'Click to cancel the search.'
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 2
        OnClick = cmdCancelClick
      end
      object cmdExtendedSearch: TBitBtn
        Left = 11
        Top = 3
        Width = 79
        Height = 25
        Hint = 'Search ICD-9-CM Diagnoses...'
        Align = alLeft
        Caption = '&Extend Search'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = cmdExtendedSearchClick
        NumGlyphs = 2
      end
      object cbShowCodes: TCheckBox
        Left = 104
        Top = 8
        Width = 161
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Show Codes With Names'
        TabOrder = 3
        OnClick = cbShowCodesClick
      end
      object cbAddToTMGEncounter: TCheckBox
        Left = 256
        Top = 8
        Width = 137
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Add To Encounter Form'
        TabOrder = 4
        Visible = False
        OnClick = cbAddToTMGEncounterClick
      end
    end
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 624
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 52
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      TabOrder = 0
      DesignSize = (
        624
        52)
      object lblSearch: TLabel
        Left = 11
        Top = 3
        Width = 442
        Height = 15
        AutoSize = False
        Caption = 'Search for Diagnosis:'
        Constraints.MinHeight = 15
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object txtSearch: TCaptionEdit
        AlignWithMargins = True
        Left = 11
        Top = 24
        Width = 526
        Height = 19
        Margins.Left = 0
        Anchors = [akLeft, akTop, akRight]
        Constraints.MinHeight = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = txtSearchChange
        Caption = 'Search for Diagnosis'
      end
      object cmdSearch: TButton
        AlignWithMargins = True
        Left = 543
        Top = 21
        Width = 70
        Height = 25
        Hint = 'Click to execute the search.'
        Margins.Right = 0
        Anchors = [akTop, akRight]
        Caption = '&Search'
        Default = True
        TabOrder = 1
        OnClick = cmdSearchClick
      end
    end
    object pnlList: TPanel
      Left = 0
      Top = 52
      Width = 624
      Height = 334
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      object lblSelect: TVA508StaticText
        Name = 'lblSelect'
        Left = 11
        Top = 3
        Width = 602
        Height = 15
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Select from one of the following items:'
        TabOrder = 0
        Visible = False
        ShowAccelChar = True
      end
      inline tgfLex: TTreeGridFrame
        Left = 11
        Top = 18
        Width = 602
        Height = 313
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ExplicitLeft = 11
        ExplicitTop = 18
        ExplicitWidth = 602
        ExplicitHeight = 313
        inherited tv: TTreeView
          Width = 602
          Height = 209
          BorderStyle = bsSingle
          OnChange = tgfLextvChange
          OnClick = tgfLextvClick
          OnCustomDrawItem = tgfLextvCustomDrawItem
          OnDblClick = tgfLextvDblClick
          OnEnter = tgfLextvEnter
          OnExit = tgfLextvExit
          OnExpanding = tgfLextvExpanding
          ExplicitWidth = 602
          ExplicitHeight = 209
        end
        inherited pnlTop: TPanel
          Width = 602
          ExplicitWidth = 602
          inherited stTitle: TStaticText
            Width = 28
            Caption = 'Term'
            ExplicitWidth = 28
          end
        end
        inherited pnlSpace: TPanel
          Top = 233
          Width = 602
          ExplicitTop = 233
          ExplicitWidth = 602
        end
        inherited pnlHint: TPanel
          Top = 241
          Width = 602
          ExplicitTop = 241
          ExplicitWidth = 602
          inherited pnlTarget: TPanel
            Top = 241
            Width = 602
            ExplicitTop = 241
            ExplicitWidth = 602
            inherited mmoTargetCode: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlTargetCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'ICD-10-CM:  '
            end
          end
          inherited pnlCode: TPanel
            Top = 265
            Width = 602
            ExplicitTop = 265
            ExplicitWidth = 602
            inherited mmoCode: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'SNOMED CT:  '
            end
          end
          inherited pnlDesc: TPanel
            Width = 602
            ExplicitWidth = 602
            inherited mmoDesc: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlDescText: TPanel
              Alignment = taRightJustify
              Caption = 'Description:  '
            end
          end
        end
      end
    end
  end
  object pnlStatus: TPanel [1]
    Left = 0
    Top = 417
    Width = 624
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblStatus: TVA508StaticText
      Name = 'lblStatus'
      Left = 0
      Top = 0
      Width = 624
      Height = 25
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvLowered
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 152
    Top = 336
    Data = (
      (
        'Component = txtSearch'
        'Status = stsDefault')
      (
        'Component = cmdSearch'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmPCELex'
        'Text = Other Diagnosis search dialog'
        'Status = stsOK')
      (
        'Component = cmdExtendedSearch'
        'Status = stsDefault')
      (
        'Component = lblStatus'
        'Status = stsDefault')
      (
        'Component = lblSelect'
        'Status = stsDefault')
      (
        'Component = tgfLex'
        'Status = stsDefault')
      (
        'Component = tgfLex.tv'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTop'
        'Status = stsDefault')
      (
        'Component = tgfLex.stTitle'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlDesc'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoDesc'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlDescText'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlCodeSys'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTarget'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoTargetCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTargetCodeSys'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlSpace'
        'Status = stsDefault')
      (
        'Component = cbShowCodes'
        'Status = stsDefault')
      (
        'Component = cbAddToTMGEncounter'
        'Status = stsDefault'))
  end
  object timerAutoSearch: TTimer
    Enabled = False
    OnTimer = timerAutoSearchTimer
    Left = 504
    Top = 56
  end
end
