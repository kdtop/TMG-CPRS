inherited frmTMGProcedures: TfrmTMGProcedures
  Left = 548
  Top = 172
  Caption = 'Encounter Procedure'
  ClientWidth = 622
  OnMouseDown = FormMouseDown
  ExplicitWidth = 638
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
    Width = 88
    Caption = 'Procedure Section'
    ExplicitWidth = 88
  end
  inherited lblList: TLabel
    Left = 154
    ExplicitLeft = 154
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
    Caption = '&Done'
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
      OnMouseDown = FormMouseDown
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
    OnMouseDown = FormMouseDown
  end
  object spnProcQty: TUpDown [11]
    Left = 329
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
    Width = 41
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '1'
    OnChange = txtProcQtyChange
    Caption = 'Quantity'
  end
  object cboProvider: TORComboBox [13]
    Left = 56
    Top = 371
    Width = 165
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
  object btnNext: TBitBtn [18]
    Left = 543
    Top = 314
    Width = 75
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Next'
    TabOrder = 15
    OnClick = btnNextClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD17778D23833D5241CD81B13D91D
      13D5261DD43D36D27B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCF4544D51710E03A1FE96A37
      EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4CFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD08C8FD01511E23B20ED
      7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502E
      D6231BD29193FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCE6D6FD613
      0CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7
      C570F4BA69F3A95DEB6F3EDE2618D27576FF00FFFF00FFFF00FFFF00FFFF00FF
      D08C8ED6110BE6572EEF914CF1A85AF2B363F6C26FF9D27AFAE083FAE88BFCE9
      8CF9DE86F9D580F8C677F5B86EF3AE65F19D59EA7240DC2417D29294FF00FFFF
      00FFFF00FFFF00FFCF100DE24223ED8244F09550F2A75EF5B66AF5C375F8D180
      FADD8AFAE28EFBE38FF9DE8EF9D587F7C97EF6BD75F4B06BF29F5DF09254E85F
      37D6211AFF00FFFF00FFFF00FFCB3F40D92112EB713AEE8748EF9554F2A962F6
      B76FF6C37BF8CF84FADA8EF9DC92F9DD95FADB93F8D38DF7C983F7BF7BF4B270
      F2A163F09357EE844DE23D25D14F4DFF00FFFF00FFCF0907E24324EC7740ED85
      4AF09457F4A866F5B672F6C37CF9CE89FAD691FADB97F8D895DFC082F3CE8DF8
      CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14FF00FFCF7274D6140C
      E6572EEC7540EE814BF19458F2A567F5B473F6C07EF8CB8AFAD493FAD898EBCC
      94D7CEBFCFC0A7CCA16DF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD3
      7B7CCD2A2ADB2313E55B31EA6F3FED7F4AE88B55E79A62ECA96EF0B679F3C386
      F6CD91FAD79CDAB47EECE7DEFFFFF9E3DFD5C0A587CC915FF29F68F1905DED80
      50EA6F43E33F27D53B38CC100EDD2B18E75830EA693DA86445B6947FCCAF99D0
      B49DD3BA9FD7C0A4DEC8AEE2CDB1DFCEB7F7F3ECFFFFFAFFFEF8FCF8EFD3C9BB
      B48566CE794EED7D4FE96A42E5462BD5211DCF0605DC2C18E5532EE16138A37B
      66F5ECDFFFFCEFFFF8EDFFF8EDFEF9F0FFFBF5FEFCF6FFFEFBFFFFFCFEFCF7FD
      FAF3FEFAF1FFFFF6F7EEE1B39A8AC96742E8653FE4462BD61411CD0505DA2716
      E44B2BE15A35A67B67F7EDE0FFFBEEFFF7ECFFF7ECFEF8EFFFFBF4FDFBF5FFFD
      FAFFFEFAFEFBF5FDF9F0FEFCF3FFF9EDE5DBCEB28872CD613FE85F3BE43F28D5
      1310CD100FD91F12E24326E85633A55941B7907ECBA792CDAC96D1B099D5B69D
      DBBEA6DDBFA6DBC6B0F5F0E8FFFEF8FFFDF4EEE7DBC5A893B76947EA724BEB66
      42E65535E23623D51E1ACC2A2BD8140DDF3A21E44C2DE75936E2633FE27249E8
      7F55ED9266F1A476F4B07FF8B889E6A87DF0EAE4FCF8F3D3C0AEC17F5DE07C55
      EE774FEC6A46E95E3CE64E31DE281BD33938D07576D10906DB2D1AE34126E54C
      2FE75A38EE744CF48C61F59A6CF7A377F8AB7EF8B082F1AD84DDC2B4D7A98FEE
      9B71F5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D47F80FF00FFCD0604
      D9180FDE3720E34128EA5B39F37A52F4845CF58F64F7996CF79D71F7A378F8A6
      7AF7A175F8A176F79A6EF79369F4855DEB6041E75135E4472EE02C1DD71917FF
      00FFFF00FFCE4344D10906DD2617E03B23F1593AF46E49F47650F5815BF68A62
      F78F66F7926AF7956BF7946AF79167F78C64F5835DF57E59F06345E5452DE137
      24D91F19D86363FF00FFFF00FFFF00FFCE0B0BD40F0AE12D1DF24F31F35A3BF2
      6442F46F4BF67954F67D58F6815CF6845EF6835CF6815AF67A57F6714FF56C4C
      F2593DDF3422DB1C14DB3838FF00FFFF00FFFF00FFFF00FFD49394CF0403DA13
      0CF13924F34C31F25237F55E3EF76747F66C4BF7704FF77150F7704FF76D4BF6
      6949F65F44F65D40ED452DD91C14DE2C2ADBA5A6FF00FFFF00FFFF00FFFF00FF
      FF00FFD27577CF0605E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F
      40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB9192FF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFD69A9CD31D1DE51714F41D15F83423F93E29
      F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFDA6466DD
      2425E72323EE1713F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFD98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA
      9091FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  inherited btnSelectAll: TBitBtn
    Left = 356
    Top = 371
    Width = 93
    Height = 21
    TabOrder = 6
    TabStop = True
    ExplicitLeft = 356
    ExplicitTop = 371
    ExplicitWidth = 93
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
        Height = 172
        TabOrder = 0
        OnMouseDown = FormMouseDown
        ExplicitWidth = 145
        ExplicitHeight = 172
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
      OnMouseDown = FormMouseDown
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
        'Component = frmTMGProcedures'
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
        'Component = btnNext'
        'Status = stsDefault'))
  end
end
