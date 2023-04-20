inherited frmTMGVisitTypes: TfrmTMGVisitTypes
  Left = 548
  Top = 172
  Caption = 'E/M Visit'
  ClientWidth = 622
  ExplicitWidth = 638
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object lblProcQty: TLabel [0]
    Left = 240
    Top = 375
    Width = 39
    Height = 13
    Caption = 'Quantity'
  end
  inherited lblSection: TLabel
    Caption = 'Visit Type'
  end
  inherited lblList: TLabel
    Left = 154
    Width = 50
    Caption = 'Visit Name'
    ExplicitLeft = 154
    ExplicitWidth = 50
  end
  inherited bvlMain: TBevel
    Top = 232
    Width = 537
    Height = 166
    ExplicitTop = 232
    ExplicitWidth = 537
    ExplicitHeight = 166
  end
  object lblMod: TLabel [5]
    Left = 358
    Top = 6
    Width = 42
    Height = 13
    Hint = 'Modifiers'
    Caption = 'Modifiers'
    ParentShowHint = False
    ShowHint = True
  end
  object lblProvider: TLabel [6]
    Left = 6
    Top = 376
    Width = 42
    Height = 13
    Caption = 'Provider:'
  end
  inherited btnOK: TBitBtn
    Left = 542
    Top = 344
    TabOrder = 8
    ExplicitLeft = 542
    ExplicitTop = 344
  end
  inherited btnCancel: TBitBtn
    Left = 542
    Top = 371
    TabOrder = 9
    ExplicitLeft = 542
    ExplicitTop = 371
  end
  inherited pnlGrid: TPanel
    Width = 523
    TabOrder = 1
    ExplicitWidth = 523
    inherited lbGrid: TORListBox
      Tag = 30
      Width = 523
      Caption = 'Selected Procedures'
      Pieces = '1,2'
      ExplicitWidth = 523
    end
    inherited hcGrid: THeaderControl
      Width = 523
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 52
          Text = 'Quantity'
          Width = 52
        end
        item
          ImageIndex = -1
          MinWidth = 112
          Text = 'Selected Procedures'
          Width = 112
        end>
      ExplicitWidth = 523
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 2
  end
  object spnProcQty: TUpDown [11]
    Left = 348
    Top = 371
    Width = 15
    Height = 21
    Associate = txtProcQty
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 5
  end
  object txtProcQty: TCaptionEdit [12]
    Left = 288
    Top = 371
    Width = 60
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '1'
    OnChange = txtProcQtyChange
    Caption = 'Quantity'
  end
  object cboProvider: TORComboBox [13]
    Left = 54
    Top = 371
    Width = 177
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Provider'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2,3'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 3
    TabStop = True
    OnChange = cboProviderChange
    OnNeedData = cboProviderNeedData
    CharsNeedMatch = 1
  end
  object btnSearch: TBitBtn [14]
    Left = 600
    Top = 1
    Width = 18
    Height = 18
    Anchors = [akTop, akRight]
    TabOrder = 12
    OnClick = btnSearchClick
    Glyph.Data = {
      3E020000424D3E0200000000000036000000280000000D0000000D0000000100
      1800000000000802000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF606060FFFF
      FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF
      606060A0A0A060606000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFBFBFBF606060A0A0A0606060BFBFBF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFBFBFBF606060A0A0A0606060BFBFBFFFFFFF00FFFFFFFFFFFF
      FFBFBFFF7F7FFF7F7FFFBFBFBFBFBF606060A0A0A0606060BFBFBFFFFFFFFFFF
      FF00FFFFFFFF3F3FFF0000FF7F7FFF7F7FFF0000DF2020A0A0A0606060BFBFBF
      FFFFFFFFFFFFFFFFFF00FFBFBFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F7F
      4040BFBFBFFFFFFFFFFFFFFFFFFFFFFFFF00FF3F3FFFBFBFFFFFFFFFFFFFFFFF
      FFFFFFFFFFBFBFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF0000FFFFFF
      7F7F7FBFBFBFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FF00FF0000BFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF00FF7F7FFF7F7FBFBFBFBFBFBF7F7F7FFFFFFFFF7F7FFF
      7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF0000FF7F7FBFBFBFFFFF
      FFFF7F7FFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFBFBF
      FF3F3FFF0000FF0000FF3F3FFFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FF00}
  end
  object btnClearSrch: TBitBtn [15]
    Left = 577
    Top = 1
    Width = 18
    Height = 18
    Anchors = [akRight, akBottom]
    TabOrder = 13
    Visible = False
    OnClick = btnClearSrchClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000130B0000130B00000000000000000000D8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFFD8E9ECFF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFF000080FF000080FF000080FF000080FF000080FF0000
      80FF000080FF808080FF808080FF808080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFF000080FF000080FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF000080FF000080FF808080FF808080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FF808080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFF0000FFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFF0000FFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFF000080FF000080FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF000080FF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFF000080FF000080FF000080FF000080FF000080FF0000
      80FF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFF}
  end
  object edtSearchTerms: TEdit [16]
    Left = 272
    Top = 1
    Width = 301
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 14
    Visible = False
    OnChange = edtSearchTermsChange
  end
  inherited btnRemove: TBitBtn
    Left = 454
    Top = 371
    TabOrder = 7
    ExplicitLeft = 454
    ExplicitTop = 371
  end
  inherited btnSelectAll: TBitBtn
    Left = 374
    Top = 371
    Height = 21
    TabOrder = 6
    TabStop = True
    ExplicitLeft = 374
    ExplicitTop = 371
    ExplicitHeight = 21
  end
  inherited pnlMain: TPanel
    Width = 610
    TabOrder = 0
    ExplicitWidth = 610
    inherited splLeft: TSplitter
      Left = 145
      ExplicitLeft = 145
    end
    object splRight: TSplitter [1]
      Left = 347
      Top = 0
      Height = 204
      Align = alRight
      OnMoved = splRightMoved
      ExplicitLeft = 349
    end
    inherited lbxSection: TORListBox
      Tag = 30
      Left = 148
      Width = 199
      ItemHeight = 14
      Pieces = '2,3'
      ExplicitLeft = 148
      ExplicitWidth = 199
    end
    inherited pnlLeft: TPanel
      Width = 145
      ExplicitWidth = 145
      inherited lbSection: TORListBox
        Tag = 30
        Width = 145
        TabOrder = 0
        ExplicitWidth = 145
      end
      inherited btnOther: TButton
        Tag = 13
        Left = 3
        Caption = 'Other Procedure...'
        TabOrder = 1
        ExplicitLeft = 3
      end
    end
    object lbMods: TORListBox
      Left = 350
      Top = 0
      Width = 260
      Height = 204
      Style = lbOwnerDrawFixed
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = lbModsExit
      Caption = 'Modifiers'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2,3'
      TabPosInPixels = True
      CheckBoxes = True
      CheckEntireLine = True
      OnClickCheck = lbModsClickCheck
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lbMods'
        'Label = lblMod'
        'Status = stsOK')
      (
        'Component = spnProcQty'
        'Status = stsDefault')
      (
        'Component = txtProcQty'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Status = stsDefault')
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
        'Component = btnSearch'
        'Status = stsDefault')
      (
        'Component = btnClearSrch'
        'Status = stsDefault')
      (
        'Component = edtSearchTerms'
        'Status = stsDefault')
      (
        'Component = frmTMGVisitTypes'
        'Status = stsDefault'))
  end
end
