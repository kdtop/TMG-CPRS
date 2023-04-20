inherited frmODTMG1: TfrmODTMG1
  Width = 520
  Height = 700
  Caption = 'TMG Lab / Procedure Orders'
  Constraints.MinHeight = 700
  Constraints.MinWidth = 520
  ExplicitTop = -93
  ExplicitWidth = 520
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
    Width = 387
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 581
    ExplicitWidth = 387
    ExplicitHeight = 73
  end
  object btnClear: TButton [2]
    Left = 401
    Top = 633
    Width = 95
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 7
    OnClick = btnClearClick
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 453
    Width = 504
    Height = 95
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Color = clCream
    TabOrder = 8
    DesignSize = (
      504
      95)
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
      Width = 386
      Height = 55
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = memChange
    end
    object edtOtherOrder: TEdit
      Left = 118
      Top = 5
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = edtEditChange
    end
  end
  inherited sbxMain: TScrollBox
    Width = 504
    Height = 453
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    ExplicitWidth = 504
    ExplicitHeight = 453
    object btnToggleSpecialProc: TSpeedButton
      Left = 5
      Top = 423
      Width = 307
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
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
      ExplicitTop = 419
      ExplicitWidth = 341
    end
    object gbICDCodes: TGroupBox
      Left = 8
      Top = 2
      Width = 491
      Height = 132
      Anchors = [akLeft, akTop, akRight]
      Caption = 'ICD Codes'
      TabOrder = 0
      DesignSize = (
        491
        132)
      object edtDx0: TEdit
        Left = 256
        Top = 20
        Width = 230
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 0
        OnChange = edtEditChange
      end
      object edtDx1: TEdit
        Tag = 1
        Left = 256
        Top = 47
        Width = 230
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnChange = edtEditChange
      end
      object edtDx2: TEdit
        Tag = 2
        Left = 256
        Top = 74
        Width = 230
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnChange = edtEditChange
      end
      object cklbCommonDxs: TCheckListBox
        Left = 8
        Top = 20
        Width = 242
        Height = 98
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 3
        OnClick = cklbCommonClick
      end
      object edtDx3: TEdit
        Tag = 3
        Left = 256
        Top = 101
        Width = 230
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 4
        OnChange = edtEditChange
      end
    end
    object gbBundles: TGroupBox
      Left = 5
      Top = 140
      Width = 307
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Lab / Procedure Order Bundles'
      TabOrder = 1
      DesignSize = (
        307
        46)
      object cboBundles: TComboBox
        Left = 3
        Top = 22
        Width = 285
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
    object rgGetLabsTiming: TRadioGroup
      Left = 318
      Top = 202
      Width = 178
      Height = 88
      Anchors = [akTop, akRight]
      Caption = 'Get Labs ...'
      Items.Strings = (
        'Entries will go here...')
      TabOrder = 2
      OnClick = rgClick
    end
    object cklbOther: TCheckListBox
      Left = 318
      Top = 356
      Width = 176
      Height = 87
      Anchors = [akRight, akBottom]
      BevelEdges = []
      BorderStyle = bsNone
      Color = clBtnFace
      ItemHeight = 13
      Items.Strings = (
        'Entries will go here...')
      TabOrder = 3
      OnClick = cklbCommonClick
    end
    object pnlFlags: TPanel
      Left = 318
      Top = 296
      Width = 176
      Height = 54
      Anchors = [akTop, akRight, akBottom]
      BevelInner = bvLowered
      TabOrder = 4
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
    object tcProcTabs: TTabControl
      Left = 5
      Top = 192
      Width = 307
      Height = 225
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      OnChange = tcProcTabsChange
      object pnlProcedures: TPanel
        Left = 4
        Top = 6
        Width = 299
        Height = 215
        Align = alClient
        BevelOuter = bvSpace
        BorderStyle = bsSingle
        TabOrder = 0
        object pnlProcCaption: TPanel
          Left = 1
          Top = 1
          Width = 293
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
          Width = 293
          Height = 184
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
    object rgProvider: TRadioGroup
      Left = 318
      Top = 140
      Width = 176
      Height = 56
      Anchors = [akTop, akRight]
      Caption = 'Set Provider...'
      Items.Strings = (
        'Enteries will go here...')
      TabOrder = 6
      OnClick = rgClick
    end
  end
  inherited cmdAccept: TButton
    Left = 401
    Top = 554
    Width = 95
    Anchors = [akRight, akBottom]
    ExplicitLeft = 401
    ExplicitTop = 554
    ExplicitWidth = 95
  end
  inherited cmdQuit: TButton
    Left = 401
    Top = 581
    Width = 95
    Anchors = [akRight, akBottom]
    ExplicitLeft = 401
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
        'Component = gbICDCodes'
        'Status = stsDefault')
      (
        'Component = gbBundles'
        'Status = stsDefault')
      (
        'Component = cboBundles'
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
        'Component = cklbCommonDxs'
        'Status = stsDefault')
      (
        'Component = edtDx3'
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
        'Status = stsDefault'))
  end
  inherited VA508CompMemOrder: TVA508ComponentAccessibility
    Left = 72
    Top = 144
  end
end
