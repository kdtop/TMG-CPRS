inherited frmTMGDiagnoses: TfrmTMGDiagnoses
  Left = 304
  Top = 169
  Width = 660
  Height = 433
  AutoScroll = True
  Caption = 'Encounter Diagnoses'
  ExplicitWidth = 660
  ExplicitHeight = 433
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblSection: TLabel
    Width = 89
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Diagnoses Section'
    ExplicitWidth = 89
  end
  inherited lblList: TLabel
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited lblComment: TLabel
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited bvlMain: TBevel
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited btnOK: TBitBtn
    Left = 484
    Top = 371
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    TabOrder = 7
    ExplicitLeft = 480
    ExplicitTop = 377
  end
  inherited btnCancel: TBitBtn
    Left = 564
    Top = 371
    Margins.Left = 7
    Margins.Top = 7
    Margins.Right = 7
    Margins.Bottom = 7
    TabOrder = 8
    ExplicitLeft = 560
    ExplicitTop = 377
  end
  inherited pnlGrid: TPanel
    Width = 523
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 1
    ExplicitWidth = 523
    inherited lbGrid: TORListBox
      Tag = 20
      Width = 523
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Pieces = '1,2,3'
      ExplicitWidth = 523
    end
    inherited hcGrid: THeaderControl
      Width = 523
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 60
          Text = 'Add to PL'
          Width = 60
        end
        item
          ImageIndex = -1
          MinWidth = 65
          Text = 'Primary'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 110
          Text = 'Selected Diagnoses'
          Width = 110
        end>
      ExplicitWidth = 523
    end
  end
  inherited edtComment: TCaptionEdit
    Left = 10
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 3
    ExplicitLeft = 10
  end
  object cmdDiagPrimary: TButton [8]
    Left = 536
    Top = 306
    Width = 75
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Primary'
    Enabled = False
    TabOrder = 5
    OnClick = cmdDiagPrimaryClick
  end
  object ckbDiagProb: TCheckBox [9]
    Left = 535
    Top = 258
    Width = 76
    Height = 38
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Add to Problem list'
    TabOrder = 4
    WordWrap = True
    OnClick = ckbDiagProbClicked
  end
  object BitBtn1: TBitBtn [10]
    Left = 8
    Top = 369
    Width = 20
    Height = 20
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    OnClick = BitBtn1Click
    Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      08000000000000010000130B0000130B00000001000000010000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A60000000000313063005A595A009C613100FFFF000000309C006361CE00009E
      CE0000CFFF0063CFCE009C9E9C009C9EFF00C0C0C000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
      0707070707070707070707070714141414141414141407070707070707000000
      0000000000141407070707070C1313131313131313001414070707070C171717
      1717171717130014140707070C17000C0000000C0C171300140707070C170C11
      1200101117001013000707070C1714171112000000131300070707070C17170C
      1711120010110007070707070C1717170C1711120000070707070707070C0C0C
      070C171112000707070707070707070707070C17000E00070707070707070707
      0707070F170D10000707070707070707070707070F17150B0707070707070707
      07070707070F1007070707070707070707070707070707070707}
    ExplicitTop = 375
  end
  object btnSearch: TBitBtn [11]
    Left = 618
    Top = 1
    Width = 18
    Height = 18
    Anchors = [akTop, akRight]
    TabOrder = 11
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
  object edtSearchTerms: TEdit [12]
    Left = 288
    Top = 1
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 12
    OnChange = edtSearchTermsChange
  end
  object btnClearSrch: TBitBtn [13]
    Left = 596
    Top = 1
    Width = 18
    Height = 18
    Anchors = [akRight, akBottom]
    TabOrder = 13
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
  inherited btnRemove: TButton
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 6
  end
  inherited btnSelectAll: TButton
    Left = 454
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 454
  end
  inherited pnlMain: TPanel
    Width = 632
    Height = 199
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 0
    ExplicitWidth = 628
    ExplicitHeight = 205
    inherited splLeft: TSplitter
      Height = 199
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitHeight = 205
    end
    inherited lbxSection: TORListBox
      Tag = 20
      Width = 425
      Height = 196
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      IntegralHeight = True
      PopupMenu = popSectionRClick
      OnContextPopup = lbxSectionContextPopup
      OnDrawItem = lbxSectionDrawItem
      OnMouseLeave = lbxSectionMouseLeave
      OnMouseUp = lbxSectionMouseUp
      Pieces = '2,3'
      ExplicitWidth = 425
      ExplicitHeight = 196
    end
    inherited pnlLeft: TPanel
      Height = 199
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitHeight = 205
      inherited lbSection: TORListBox
        Tag = 20
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 0
      end
      inherited btnOther: TButton
        Tag = 12
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Other Diagnosis...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdDiagPrimary'
        'Status = stsDefault')
      (
        'Component = ckbDiagProb'
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
        'Component = frmTMGDiagnoses'
        'Status = stsDefault')
      (
        'Component = BitBtn1'
        'Status = stsDefault')
      (
        'Component = btnSearch'
        'Status = stsDefault')
      (
        'Component = edtSearchTerms'
        'Status = stsDefault')
      (
        'Component = btnClearSrch'
        'Status = stsDefault'))
  end
  object popSectionRClick: TPopupMenu
    Left = 304
    Top = 88
    object popOptEditLink: TMenuItem
      Caption = '&Change Linked ICD'
      OnClick = popOptEditLinkClick
    end
    object popOptRemoveLink: TMenuItem
      Caption = '&Remove Linked ICD'
      OnClick = popOptRemoveLinkClick
    end
  end
end
