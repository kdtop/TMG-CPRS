inherited frmVisitType: TfrmVisitType
  Left = 260
  Caption = 'Encounter VisitType'
  ClientHeight = 449
  ClientWidth = 592
  Constraints.MinHeight = 465
  Constraints.MinWidth = 600
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 608
  ExplicitHeight = 487
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOK: TBitBtn
    Left = 436
    Top = 425
    TabOrder = 3
    ExplicitLeft = 436
    ExplicitTop = 425
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 592
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object splLeft: TSplitter
      Left = 145
      Top = 0
      Height = 105
      ExplicitLeft = 154
      ExplicitTop = 7
      ExplicitHeight = 145
    end
    object splRight: TSplitter
      Left = 361
      Top = 0
      Height = 105
      ExplicitLeft = 634
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 105
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblVTypeSection: TLabel
        Left = 0
        Top = 0
        Width = 145
        Height = 13
        Align = alTop
        Caption = 'Type of Visit'
        ExplicitWidth = 58
      end
      object lstVTypeSection: TORListBox
        Tag = 10
        Left = 0
        Top = 13
        Width = 145
        Height = 92
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstVTypeSectionClick
        Caption = 'Type of Visit'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        CheckEntireLine = True
      end
    end
    object pnlModifiers: TPanel
      Left = 364
      Top = 0
      Width = 228
      Height = 105
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object lblMod: TLabel
        Left = 0
        Top = 0
        Width = 228
        Height = 13
        Hint = 'Modifiers'
        Align = alTop
        Caption = 'Modifiers'
        ParentShowHint = False
        ShowHint = True
        ExplicitWidth = 42
      end
      object lbMods: TORListBox
        Left = 0
        Top = 13
        Width = 228
        Height = 92
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
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
    object pnlSection: TPanel
      Left = 148
      Top = 0
      Width = 213
      Height = 105
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlSection'
      TabOrder = 1
      object lblVType: TLabel
        Left = 0
        Top = 0
        Width = 213
        Height = 13
        Align = alTop
        Caption = 'Codes'
        ExplicitWidth = 30
      end
      object lbxVisits: TORListBox
        Tag = 10
        Left = 0
        Top = 13
        Width = 213
        Height = 92
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lbxVisitsClick
        Caption = 'Section Name'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3,4,5'
        TabPosInPixels = True
        CheckBoxes = True
        CheckEntireLine = True
        OnClickCheck = lbxVisitsClickCheck
      end
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 105
    Width = 592
    Height = 164
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    inline fraVisitRelated: TfraVisitRelated
      Left = 384
      Top = 0
      Width = 208
      Height = 164
      Align = alRight
      TabOrder = 1
      TabStop = True
      ExplicitLeft = 384
      ExplicitWidth = 208
      ExplicitHeight = 164
      inherited gbVisitRelatedTo: TGroupBox
        Width = 208
        Height = 164
        ExplicitWidth = 208
        ExplicitHeight = 164
        inherited chkMSTYes: TCheckBox
          Top = 127
          ExplicitTop = 127
        end
        inherited chkMSTNo: TCheckBox
          Top = 127
          ExplicitTop = 127
        end
        inherited chkHNCYes: TCheckBox
          Top = 143
          ExplicitTop = 143
        end
        inherited chkHNCNo: TCheckBox
          Top = 142
          Width = 150
          Height = 18
          Caption = 'Head and/or Neck Cancer     No'
          ExplicitTop = 142
          ExplicitWidth = 150
          ExplicitHeight = 18
        end
      end
    end
    object pnlSC: TPanel
      Left = 0
      Top = 0
      Width = 384
      Height = 164
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblSCDisplay: TLabel
        Left = 0
        Top = 0
        Width = 384
        Height = 13
        Align = alTop
        Caption = 'Service Connection && Rated Disabilities'
        ExplicitWidth = 186
      end
      object memSCDisplay: TCaptionMemo
        Left = 0
        Top = 13
        Width = 384
        Height = 151
        Align = alClient
        Color = clBtnFace
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnEnter = memSCDisplayEnter
        Caption = 'Service Connection && Rated Disabilities'
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 269
    Width = 592
    Height = 141
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnAdd: TButton
      Left = 260
      Top = 35
      Width = 75
      Height = 21
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 260
      Top = 72
      Width = 75
      Height = 21
      Caption = 'Remove'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnPrimary: TButton
      Left = 260
      Top = 112
      Width = 75
      Height = 21
      Caption = 'Primary'
      TabOrder = 3
      OnClick = btnPrimaryClick
    end
    object pnlBottomLeft: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 141
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblProvider: TLabel
        Left = 0
        Top = 0
        Width = 240
        Height = 13
        Align = alTop
        Caption = 'Available providers'
        ExplicitWidth = 89
      end
      object cboPtProvider: TORComboBox
        Left = 0
        Top = 13
        Width = 240
        Height = 128
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Available providers'
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
        TabOrder = 0
        CheckEntireLine = True
        OnChange = cboPtProviderChange
        OnDblClick = cboPtProviderDblClick
        OnNeedData = cboPtProviderNeedData
        CharsNeedMatch = 1
      end
    end
    object pnlBottomRight: TPanel
      Left = 352
      Top = 0
      Width = 240
      Height = 141
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 4
      object lblCurrentProv: TLabel
        Left = 0
        Top = 0
        Width = 240
        Height = 13
        Align = alTop
        Caption = 'Current providers for this encounter'
        ExplicitWidth = 165
      end
      object lbProviders: TORListBox
        Left = 0
        Top = 13
        Width = 240
        Height = 128
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = lbProvidersDblClick
        Caption = 'Current providers for this encounter'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = lbProvidersChange
        CheckEntireLine = True
      end
    end
  end
  inherited btnCancel: TBitBtn
    Left = 517
    Top = 425
    TabOrder = 4
    ExplicitLeft = 517
    ExplicitTop = 425
  end
  object btnNext: TBitBtn [5]
    Left = 8
    Top = 415
    Width = 129
    Height = 32
    Anchors = [akLeft, akBottom]
    Caption = '&Next'
    TabOrder = 5
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
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 24
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmVisitType'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lstVTypeSection'
        'Label = lblVTypeSection'
        'Status = stsOK')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAOYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAONo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.lblSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.lblSCYes'
        'Status = stsDefault')
      (
        'Component = pnlSC'
        'Status = stsDefault')
      (
        'Component = memSCDisplay'
        'Label = lblSCDisplay'
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnPrimary'
        'Status = stsDefault')
      (
        'Component = pnlBottomLeft'
        'Status = stsDefault')
      (
        'Component = cboPtProvider'
        'Label = lblProvider'
        'Status = stsOK')
      (
        'Component = pnlBottomRight'
        'Status = stsDefault')
      (
        'Component = lbProviders'
        'Label = lblCurrentProv'
        'Status = stsOK')
      (
        'Component = pnlModifiers'
        'Status = stsDefault')
      (
        'Component = lbMods'
        'Label = lblMod'
        'Status = stsOK')
      (
        'Component = pnlSection'
        'Status = stsDefault')
      (
        'Component = lbxVisits'
        'Label = lblVType'
        'Status = stsOK')
      (
        'Component = btnNext'
        'Status = stsDefault'))
  end
end
