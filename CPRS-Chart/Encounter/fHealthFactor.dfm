inherited frmHealthFactors: TfrmHealthFactors
  Left = 374
  Top = 205
  Caption = 'Health Factor page'
  ClientHeight = 417
  ClientWidth = 627
  OnShow = FormShow
  ExplicitWidth = 643
  ExplicitHeight = 455
  PixelsPerInch = 96
  TextHeight = 13
  object lblHealthLevel: TLabel [0]
    Left = 490
    Top = 264
    Width = 69
    Height = 13
    Caption = 'Level/Severity'
  end
  inherited lblSection: TLabel
    Width = 103
    Caption = 'Health Factor Section'
    ExplicitWidth = 103
  end
  inherited btnOK: TBitBtn
    Left = 467
    Top = 393
    TabOrder = 6
    ExplicitTop = 390
  end
  inherited btnCancel: TBitBtn
    Left = 547
    Top = 393
    TabOrder = 7
    ExplicitTop = 390
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lbGrid: TORListBox
      Tag = 70
      Caption = 'Selected Health Factors'
      Pieces = '1,2'
    end
    inherited hcGrid: THeaderControl
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 85
          Text = 'Level/Severity'
          Width = 85
        end
        item
          ImageIndex = -1
          MinWidth = 130
          Text = 'Selected Health Factors'
          Width = 130
        end>
    end
  end
  inherited edtComment: TCaptionEdit
    MaxLength = 245
    TabOrder = 3
  end
  object cboHealthLevel: TORComboBox [9]
    Tag = 50
    Left = 490
    Top = 280
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Level/Severity'
    Color = clWindow
    DropDownCount = 8
    Enabled = False
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 4
    OnChange = cboHealthLevelChange
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    TabOrder = 5
  end
  object btnEditDiscreteData: TBitBtn [11]
    Left = 5
    Top = 390
    Width = 148
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = '&Edit Discrete Data'
    TabOrder = 9
    OnClick = btnEditDiscreteDataClick
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555500005577777777777777777500005000000000000000007500005088
      80FFFFFF0FFFF0750000508180F4444F0F44F0750000508880FFFFFF0FFFF075
      0000508180F4444F0F44F0750000508880FFFFFF0FFFF0750000508180F4444F
      0F44F0750000508880FF0078088880750000508180F400007844807500005088
      80FF7008007880750000508180F4408FF80080750000508880FFF70FFF800075
      0000500000000008FF803007000050EEEEEEEE70880B43000000500000000000
      00FBB43000005555555555550BFFBB43000055555555555550BFFBB400005555
      55555555550BFFBB0000}
    ExplicitTop = 387
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  inherited pnlMain: TPanel
    Width = 615
    Height = 221
    TabOrder = 0
    ExplicitHeight = 218
    inherited splLeft: TSplitter
      Height = 221
      ExplicitHeight = 218
    end
    inherited lbxSection: TORListBox
      Tag = 70
      Width = 408
      Height = 221
      ExplicitHeight = 218
    end
    inherited pnlLeft: TPanel
      Height = 221
      ExplicitHeight = 218
      inherited lbSection: TORListBox
        Tag = 70
        TabOrder = 0
        Caption = 'Health Factor Section'
      end
      inherited btnOther: TButton
        Tag = 23
        Caption = 'Other Health Factor...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboHealthLevel'
        'Label = lblHealthLevel'
        'Status = stsOK')
      (
        'Component = edtComment'
        'Label = lblComment'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lbxSection'
        'Label = lblList'
        'Status = stsOK')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lbSection'
        'Label = lblSection'
        'Status = stsOK')
      (
        'Component = btnOther'
        'Status = stsDefault')
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = lbGrid'
        'Status = stsDefault')
      (
        'Component = hcGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmHealthFactors'
        'Status = stsDefault')
      (
        'Component = btnEditDiscreteData'
        'Status = stsDefault'))
  end
end
