inherited frmCarePlanPicker: TfrmCarePlanPicker
  Left = 0
  Top = 0
  Caption = 'Pick Care Plan Template'
  ClientHeight = 495
  ClientWidth = 776
  Font.Name = 'Tahoma'
  Menu = mnuMain
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 784
  ExplicitHeight = 549
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 302
    Width = 776
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 152
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 455
    Width = 776
    Height = 40
    Align = alBottom
    TabOrder = 2
    object btnOK: TBitBtn
      Left = 587
      Top = 6
      Width = 184
      Height = 30
      Caption = '&Use Selected Care Plan'
      ModalResult = 1
      TabOrder = 3
      OnClick = btnOKClick
      Glyph.Data = {
        76060000424D7606000000000000360000002800000014000000140000000100
        20000000000040060000130B0000130B00000000000000000000000000000000
        0000000000000000000000000000FFFFFF10B1CCAF44CEDFCE9E4E995AB42F84
        3CAD2C8338B9439655A29BCAA79EB9D0B644FFFFFF1000000000000000000000
        0000000000000000000000000000000000000000000000000000E3ECE160679E
        67D73F9553FF26A15BFF26AA68F225A461CA25A461FF24B16FFF25A662FF3F95
        52FF679E67D7E3ECE16000000000000000000000000000000000000000000000
        000000000000D2E1D1993D8944FF26A25FFF24B372FF299A54FF2B8C42FF2B8A
        41FF2B8A41FF2B8A42FF299A53FF24B272FF26A25EFF3D8944FFD2E1D1990000
        000000000000000000000000000000000000D2E1D1992D873EFF23A763FE28A0
        5BFF2B8E45FF2B9048FF2A934CFF28934CFF2B934CFF2A934BFF2B8F48FF2B8C
        44FF289F5AFF23A662FE2D873EFFD2E1D199000000000000000000000000E3EB
        E1603D8A45FF24A560FE2A964FFF2B934DFF2A9650FF2B9852FF27964FFF2F90
        49FF299A53FF2B9852FF2B9751FF2A954FFF2A924BFF2A944EFF24A460FE3D8A
        45FFE3EBE16000000000FFFFFF10679F67D7269F5AFF299D57FF2A9750FF2A9A
        55FF299C57FF269C55FF51A168FFAFC2ADFF25934AFF299E59FF299C56FF2A9A
        55FF2A9853FF2A954EFF299B56FF269E58FF679F67D7FFFFFF10B3CDB0443F94
        52FF28A35FFF2B9852FF2A9D57FF2AA05BFF1F9B53FF57A56EFFCED6CEFFEBE6
        EAFF82B48EFF219E57FF29A15EFF299F5CFF299D58FF2A9B55FF2B964FFF28A0
        5CFF3F9553FFB0CCAF44BEDBC59E269B55FF2A9B56FF299E5AFF29A25DFF26A2
        5EFF5AA772FFDADED9FFE6E5E6FFE5E5E5FFD5DCD5FF3EA366FF2AA865FF2AA5
        62FF29A35EFF29A05BFF299C57FF2B9852FF27964FFFCEE0CF9E53A76DDA279F
        5BFF289F5BFF28A360FF27A45FFF5AAA75FFD7DED7FFEAEAEBFFE5E5E4FFE6E7
        E7FFE8E9E9FF98C0A1FF20A660FF2AAB69FF29A765FF29A461FF29A15DFF299C
        58FF309C58FF4D9A5CDA39904BF93BA768FF34A968FF29A966FF36A463FFC5D3
        C4FFF1F0F2FFEFEBECFF54A46BFFB9D2BFFFEDEDEEFFE6E8E6FF56A871FF1FAE
        6AFF29AB6AFF28A865FF2CA663FF34A665FF349B58FF31853DF9469656F948AD
        73FF42B277FF43B77DFF2FAD6CFF8CC19EFFE2E5E0FF4CA66BFF20B370FF399F
        5FFFF1EEEEFFF3F1F3FFD3DFD5FF32A563FF2EB273FF3BB478FF43B379FF42AF
        73FF3DA060FF3C8D48F9348D47DA51B47EFF4FBA84FF4EBD87FF4FC18CFF51B2
        7CFF58B17BFF44BE86FF46BF89FF3EBD83FF80B78EFFF7F4F5FFF4F2F3FF9FC9
        ABFF4AB881FF4FBF89FF4EBB84FF4EB880FF4CA76CFF79AF7FDA98CAA79E54B0
        78FF5BC28FFF5BC391FF5AC492FF5AC795FF5AC897FF5AC896FF5AC997FF5AC9
        97FF59C28FFFC3D9C7FFF7F6F7FFEDF0EDFF74B78AFF56C28FFF5BC190FF5CBF
        8DFF4A9F61FFBFD6BF9EB8CFB444509657FF71CDA2FF65C899FF66CA9CFF66CB
        9CFF65CD9EFF65CD9FFF65CEA0FF65CEA0FF64CD9EFF6FBC8EFFEAEFE9FFFFFF
        FFFFBAD2BAFF59B782FF65C899FF71CB9FFF509758FFB1CDB144FFFFFF10669D
        65D766B37FFF7DD5AEFF72CEA4FF73D1A6FF73D1A7FF72D3A8FF71D3AAFF72D4
        AAFF71D3AAFF6DD0A4FF82BF95FFC5D9C5FF77C094FF70CDA2FF7ED4ADFF66B1
        7EFF669D65D7FFFFFF1000000000DFEBE060468C49FF83C9A1FE83D7B2FF7DD4
        ADFF7ED6B0FF7ED7B1FF7DD8B2FF7DD8B3FF7DD8B3FF7ED8B2FF79D1A9FF6EBF
        91FF7DD4ACFF84D6B0FF82C9A0FE468B49FFDFEBE06000000000000000000000
        0000D1E1D099448D4AFF92D0ADFEA0E4C9FF88D9B6FF89DBB8FF8ADCBAFF8ADD
        BBFF8ADDBAFF8BDCB9FF89DAB7FF88D9B5FFA1E4C8FF92D0ADFE448D4AFFD1E1
        D0990000000000000000000000000000000000000000D0E1D099488C4AFF87C1
        97FFBDEDDAFFA4E4CAFF96DFC1FF94E0C0FF94DFC0FF96DFC0FFA4E4C9FFBDEC
        D9FF87C097FF488D4AFFD0E1D099000000000000000000000000000000000000
        00000000000000000000DFEBDF60659D65D7609E65FF86BC92FFA1CFB0FCA0D0
        B2E8AAD7BCFF99CCABFF8BBF98FF609E65FF659D65D7DFEBDF60000000000000
        000000000000000000000000000000000000000000000000000000000000FFFF
        FF10B3CEB344A8C8A99E3787417439894398489353F93F8F4CDA87B68B9EB9D1
        B844FFFFFF100000000000000000000000000000000000000000}
    end
    object btnCancel: TBitBtn
      Left = 483
      Top = 6
      Width = 98
      Height = 30
      Caption = '&Cancel'
      Default = True
      ModalResult = 2
      TabOrder = 2
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFBFBFBF2F2F2EBEBECEBEBEDF2F2F2FBFBFBFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCD5D5DFA3A3D88E8EE187
        87E77373E77070E29292D8D1D1DEFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        D7D7EB7373DA3F3FF45F5FFF8D8DFFA0A0FF9B9BFF7F7FFF4242FE2525EE6D6D
        D1D5D5E8FFFFFFFFFFFFFFFFFFE7E7EC4747DF3131F96060FF7A7AFF9494FFA6
        A6FFAFAFFFA8A8FF9393FF7272FD3A3AEC4545D1E5E5EBFFFFFFEBEBF45B5BD9
        2929F83E3EFF5252FF6060FF7B7BE5DFDFEFF8F8FDEEEEFDC1C1FD8686FE5A5A
        FF3B3BF05A5ACDE9E9F2B3B3E42424E62222FF2B2BFF3D3DFF4A4AFF3131F762
        62DFEEEEEFFFFFFFFCFCFFDFDFFD6363FD3939FF2E2EDCB0B0DE6B6BDB0808F7
        1A1AFE4B4BFC2E2EFF2F2FFF3E3EFF2828FA4A4ADAC8C8E3FEFEFEFFFFFFC8C8
        FA3A3AFC1818F46C6CD44A4ADD0101FD2B2BFBBBBBF97878FC2A2AFF2424FF2C
        2CFE2222F03737D5CDCDDFFDFDFDE4E4F64B4BF60A0AFD4A4AD94444E00101FF
        3636F4DADAF3F8F8FEA8A8FC4343FE5454FF5959FF3C3CF32323CD9A9AD0D2D2
        E73535E70101FF4343DF5F5FE33C3CFE3737F1AAAADFFFFFFFFCFCFEADADFC5E
        5EFE8181FF7C7CFF3535EE1818C55A5AB81717E50101FF5353E3A0A0EC6666F7
        6464FC3838D1C4C4DBF8F8F8FFFFFFD8D8FC6969FD8181FF8D8DFF5454F80D0D
        D65959F55353F79999ECD9D9F55E5EEF9292FF4747F64242C38787C2DDDDDFF0
        F0F0C5C5EE6969F19191FF9D9DFF7474FC9090FE5D5DF0D7D7F4FFFFFFC1C1EF
        6D6DF49D9DFE5C5CFA3636DF2222C33333B82F2FB81B1BC63F3FF99C9CFFA7A7
        FE6E6EF4BEBEEFFFFFFFFFFFFFFEFEFEB2B2F06F6FEFA7A7FF9999FF6F6FF851
        51F34D4DF36565F89393FFA9A9FF7070EFB0B0F0FEFEFEFFFFFFFFFFFFFFFFFF
        FFFFFFF1F1FA9494ED9090F3A7A7F6AAAAF7AAAAF7A7A7F69292F39494EDF0F0
        FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFEEBEBF9D0D0F6CB
        CBF6CBCBF6D0D0F6EBEBF9FDFDFEFFFFFFFFFFFFFFFFFFFFFFFF}
    end
    object btnEdit: TBitBtn
      Left = 5
      Top = 6
      Width = 212
      Height = 30
      Caption = '&Edit or Add New Care Plan Template'
      TabOrder = 0
      OnClick = btnEditCarePlansClick
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000012000000180000000100
        200000000000C0060000C11E0000C11E00000000000000000000E4E4E4FFDDDD
        DDFFD4D4D4FFCECECEFFC8C8C8FFC7C7C7FFC6C6C6FFC6C6C6FFC6C6C6FFC6C6
        C6FFC7C7C7FFCBCBCBFFD2D2D2FFD9D9D9FFDEDEDEFFE2E2E2FFE5E5E5FFE8E8
        E8FFD0D0D0FFA7A7A7FF898989FF828282FF7E7E7EFF7F7F7FFF7E7E7EFF7E7E
        7EFF7E7E7EFF7F7F7FFF7F7F7FFF808080FF868686FFA6A6A6FFC3C3C3FFCBCB
        CBFFD4D4D4FFDDDDDDFFD7D7D7FF727272FFA5A5A5FF999999FF939393FF8989
        89FF868686FF797979FF818181FF737373FF727272FF6D6D6DFF666666FF7272
        72FFB2B2B2FFDADADAFFE3E3E3FFE8E8E8FFDADADAFF717171FFD2D2D2FFBDBD
        BDFFB5B5B5FFA6A6A6FFA4A4A4FF919191FF9F9F9FFF878787FF858585FF7878
        78FF838383FF9B9B9BFF6E6E6EFFB8B8B8FFE3E3E3FFEAEAEAFFDADADAFF7171
        71FFD1D1D1FFC6C6C6FFB8B8B8FFB3B3B3FFAEAEAEFFA2A2A2FFA0A0A0FF9B9B
        9BFF919191FF747474FF919191FFC0C0C0FF9C9C9CFF686868FFB2B2B2FFDFDF
        DFFFDADADAFF717171FFCECECEFFB8B8B8FFB0B0B0FF9F9F9FFF9F9F9FFF8D8D
        8DFF9D9D9DFF848484FF838383FF707070FF888888FFCFCFCFFFC1C1C1FFA5A5
        A5FF707070FFA5A5A5FFDADADAFF717171FFCCCCCCFFBFBFBFFFB1B1B1FFAAAA
        AAFFA7A7A7FF9B9B9BFF9D9D9DFF959595FF8F8F8FFF7B7B7BFF747474FF8383
        83FF828282FF818181FF7F7F7FFF5F5F5FFFDADADAFF707070FFC8C8C8FFB3B3
        B3FFB9B9B9FFAAAAAAFF9C9C9CFF8D8D8DFF9B9B9BFF868686FF888888FF8787
        87FF6E6E6EFF737373FF6E6E6EFF686868FF7E7E7EFF676767FFDADADAFF7070
        70FFC4C4C4FFB1B1B1FFC8C8C8FFBABABAFF9F9F9FFF919191FF9F9F9FFF8B8B
        8BFF8E8E8EFF8E8E8EFF7C7C7CFF888888FF838383FF797979FF8B8B8BFF6C6C
        6CFFDADADAFF707070FFC2C2C2FFBBBBBBFFD5D5D5FFD6D6D6FFCCD0D1FFA7EB
        EDFFCBCBCBFFC6C6C6FFB9B9B9FF8F8F8FFF8D8D8DFF919191FF8F8F8FFF8B8B
        8BFF909090FF6C6C6CFFDADADAFF707070FFBECDDFFFA6A6A6FFC4C4C4FFB1B1
        B1FF81EFEEFF61F2EFFF8D8D8DFF747474FF7B7B7BFF8A8A8AFFAEB9C1FF8787
        87FF828282FF777777FF8E8E8EFF6C6C6CFFDADADAFF6F6F6FFFBDBDBDFF0707
        80FF9FACCFFFBDBDBDFF3FF7F1FF28F9F2FFDCDCDCFFDADADAFF9EABCEFF0F10
        84FF8A8A8AFFBDBDBDFFADADADFF8E8E8EFF919191FF6C6C6CFFDADADAFF6F6F
        6FFFB8B8B8FF333696FF03027DFF4D54A5FF31F9F3FF32FAF4FFA8EEEEFF4F55
        A5FF03027EFF4E54A5FF727272FFB9B9B9FFA2A2A2FF777777FF8E8E8EFF6C6C
        6CFFDADADAFF6F6F6FFFB6B6B6FF757EB9FF0A0981FF0A0A81FF0D1385FF0A0A
        81FF081486FF0A0A81FF070780FF929EC8FF7C7C7CFFBDBDBDFFA8A8A8FF8181
        81FF8F8F8FFF6C6C6CFFABEFEFFFA3F0F0FF9EF1F0FF7ECEDFFF05017DFF0A0A
        81FF03037EFF7D7BACFF050680FF0A0A81FF03007CFF9BEEEFFFABEEEFFFB1EE
        EFFFA8A8A8FF818181FF8F8F8FFF6C6C6CFF89F4F2FF61FCF6FF65FBF6FF6CFF
        FDFF121B8EFF0D0D88FF000083FFC7C7D3FF040485FF0D0D88FF20409FFF6AFF
        FAFF61FCF7FFA8EFF0FFA2A2A2FF777777FF8E8E8EFF6C6C6CFFDADADAFFB0F0
        F0FF77FFFAFF4D9FD0FF0B0A8EFF07078BFF000085FFC5C5D2FF000087FF0707
        89FF0D0D90FF5FB4D8FF898989FFC1C1C1FFAFAFAFFF8E8E8EFF919191FF6C6C
        6CFFDADADAFF6E6E6EFF5965BCFF0F0B9AFF6666B3FFC6C6DCFFC2C2DAFFF0F0
        F2FFC3C3DAFFC9C9DDFF4848A9FF0C0A99FF767FC6FFB9B9B9FFA2A2A2FF7575
        75FF8E8E8EFF6C6C6CFFDADADAFF393CB4FF1212A7FF1414A7FF1111A7FF1010
        A6FF0303A3FFC7C7D6FF0808A4FF0E0EA5FF1212A6FF1414A6FF1010A5FF5055
        BCFFA8A8A8FF828282FF8F8F8FFF6C6C6CFF8E97D8FF858ED5FF858DD4FF7694
        D8FF7097DCFF2D38BCFF0C0CAFFFCDCDD9FF1A1AB5FF4A5FCAFF7793D8FF858D
        D4FF858ED4FF858DD4FF9BA7D9FFD6D6D6FF9B9B9BFF6B6B6BFFDADADAFF6E6E
        6EFFA7A7A7FFBDF9F8FFB8FEFAFF80A6E5FF1514BAFF4949BAFF1E1ABEFFA7E6
        F4FFBEF8F8FF8A8A8AFF757575FFADADADFF999999FF757575FF8D8D8DFF6C6C
        6CFFDDDDDDFF6D6D6DFFA6A6A6FFBEF8F8FF989F9FFF8B8B8BFF2121BEFF1E1E
        BEFF4E58CDFFA5B9B9FFBEF8F8FF909090FF8C8C8CFF8C8C8CFF8B8B8BFF8989
        89FF8F8F8FFF6B6B6BFFE3E3E3FF6A6A6AFFA5A5A5FF8A8A8AFF8B8B8BFF7777
        77FF737AD4FF2323C1FFA0ACDEFF787878FF818181FF8B8B8BFF787878FF8989
        89FF828282FF767676FF8D8D8DFF686868FFE8E8E8FF969696FF6F6F6FFF7070
        70FF707070FF6F6F6FFFC7D5EAFF2A2AC3FF717171FF6F6F6FFF707070FF7070
        70FF6F6F6FFF707070FF707070FF6F6F6FFF6D6D6DFF959595FF}
    end
    object cbHideUnlinked: TCheckBox
      Left = 231
      Top = 12
      Width = 234
      Height = 17
      Caption = '&Show Only Relevant Plan Templates'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = cbHideUnlinkedClick
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 305
    Width = 776
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object reBoil: TRichEdit
      Left = 0
      Top = 0
      Width = 776
      Height = 150
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object pnlTop: TPanel [3]
    Left = 0
    Top = 0
    Width = 776
    Height = 302
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 360
      Top = 0
      Height = 302
      ExplicitLeft = 440
      ExplicitTop = 104
      ExplicitHeight = 100
    end
    object pnlShared: TPanel
      Left = 0
      Top = 0
      Width = 360
      Height = 302
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlShared'
      Padding.Top = 2
      TabOrder = 0
      object lblShared: TLabel
        Left = 0
        Top = 42
        Width = 360
        Height = 13
        Align = alTop
        Caption = '&Shared Care Plans Templates'
        FocusControl = tvShared
        ExplicitWidth = 140
      end
      object pnlSharedBottom: TPanel
        Left = 0
        Top = 278
        Width = 360
        Height = 24
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          360
          24)
        object cbShHide: TCheckBox
          Left = 0
          Top = 4
          Width = 238
          Height = 17
          Hint = 'Hide Inactive Shared CarePlans'
          Anchors = [akLeft, akTop, akRight]
          Caption = '&Hide Inactive'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlSharedGap: TPanel
        Left = 0
        Top = 40
        Width = 360
        Height = 2
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlShSearch: TPanel
        Left = 0
        Top = 2
        Width = 360
        Height = 38
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          360
          38)
        object btnShFind: TORAlignButton
          Left = 302
          Top = 0
          Width = 55
          Height = 21
          Hint = 'Find CarePlan'
          Anchors = [akTop, akRight]
          Caption = 'Find'
          ParentShowHint = False
          PopupMenu = popCarePlans
          ShowHint = True
          TabOrder = 1
          OnClick = btnFindClick
        end
        object edtShSearch: TCaptionEdit
          Left = -2
          Top = 0
          Width = 298
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Caption = 'Shared CarePlans'
        end
        object cbShMatchCase: TCheckBox
          Left = 0
          Top = 21
          Width = 80
          Height = 17
          Caption = 'Match Case'
          TabOrder = 2
        end
        object cbShWholeWords: TCheckBox
          Left = 80
          Top = 21
          Width = 109
          Height = 17
          Caption = 'Whole Words Only'
          TabOrder = 3
        end
      end
      object tvShared: TORTreeView
        Left = 0
        Top = 55
        Width = 360
        Height = 223
        Align = alClient
        DragMode = dmAutomatic
        Images = dmodShared.imgTemplates
        Indent = 19
        PopupMenu = popCarePlans
        RightClickSelect = True
        TabOrder = 3
        OnChange = tvTreeChange
        OnChanging = tvSharedChanging
        OnCustomDrawItem = tvSharedCustomDrawItem
        OnEnter = tvEnter
        OnExpanding = tvSharedExpanding
        OnGetImageIndex = tvGetImageIndex
        OnGetSelectedIndex = tvGetSelectedIndex
        OnKeyDown = tvKeyDown
        Caption = 'Shared CarePlans'
        NodePiece = 0
      end
    end
    object pnlPersonal: TPanel
      Left = 363
      Top = 0
      Width = 413
      Height = 302
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 100
      TabOrder = 1
      object lblPersonal: TLabel
        Tag = 1
        Left = 0
        Top = 40
        Width = 413
        Height = 13
        Align = alTop
        Caption = '&Personal Care Plans Templates'
        FocusControl = tvPersonal
        PopupMenu = popCarePlans
        ExplicitWidth = 147
      end
      object tvPersonal: TORTreeView
        Tag = 1
        Left = 0
        Top = 53
        Width = 413
        Height = 225
        Align = alClient
        DragMode = dmAutomatic
        Images = dmodShared.imgTemplates
        Indent = 19
        PopupMenu = popCarePlans
        RightClickSelect = True
        TabOrder = 1
        OnChange = tvTreeChange
        OnChanging = tvSharedChanging
        OnCustomDrawItem = tvSharedCustomDrawItem
        OnEnter = tvEnter
        OnExpanding = tvSharedExpanding
        OnGetImageIndex = tvGetImageIndex
        OnGetSelectedIndex = tvGetSelectedIndex
        OnKeyDown = tvKeyDown
        Caption = 'Personal CarePlans'
        NodePiece = 0
      end
      object pnlPersonalBottom: TPanel
        Left = 0
        Top = 278
        Width = 413
        Height = 24
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object cbPerHide: TCheckBox
          Left = 3
          Top = 4
          Width = 123
          Height = 17
          Hint = 'Hide Inactive Personal CarePlans'
          Caption = 'Hide &Inactive'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlPersonalGap: TPanel
        Tag = 1
        Left = 0
        Top = 0
        Width = 413
        Height = 2
        Align = alTop
        BevelOuter = bvNone
        PopupMenu = popCarePlans
        TabOrder = 3
      end
      object pnlPerSearch: TPanel
        Left = 0
        Top = 2
        Width = 413
        Height = 38
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          413
          38)
        object btnPerFind: TORAlignButton
          Tag = 1
          Left = 353
          Top = 0
          Width = 55
          Height = 21
          Hint = 'Find CarePlan'
          Anchors = [akTop, akRight]
          Caption = 'Find'
          ParentShowHint = False
          PopupMenu = popCarePlans
          ShowHint = True
          TabOrder = 1
          OnClick = btnFindClick
        end
        object edtPerSearch: TCaptionEdit
          Tag = 1
          Left = 0
          Top = 0
          Width = 348
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          Caption = 'Personal CarePlans'
        end
        object cbPerMatchCase: TCheckBox
          Tag = 1
          Left = 0
          Top = 21
          Width = 80
          Height = 17
          Caption = 'Match Case'
          TabOrder = 2
        end
        object cbPerWholeWords: TCheckBox
          Tag = 1
          Left = 80
          Top = 21
          Width = 109
          Height = 17
          Caption = 'Whole Words Only'
          TabOrder = 3
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnEdit'
        'Status = stsDefault')
      (
        'Component = cbHideUnlinked'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = reBoil'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlShared'
        'Status = stsDefault')
      (
        'Component = pnlSharedBottom'
        'Status = stsDefault')
      (
        'Component = cbShHide'
        'Status = stsDefault')
      (
        'Component = pnlSharedGap'
        'Status = stsDefault')
      (
        'Component = pnlShSearch'
        'Status = stsDefault')
      (
        'Component = btnShFind'
        'Status = stsDefault')
      (
        'Component = edtShSearch'
        'Status = stsDefault')
      (
        'Component = cbShMatchCase'
        'Status = stsDefault')
      (
        'Component = cbShWholeWords'
        'Status = stsDefault')
      (
        'Component = tvShared'
        'Status = stsDefault')
      (
        'Component = pnlPersonal'
        'Status = stsDefault')
      (
        'Component = tvPersonal'
        'Status = stsDefault')
      (
        'Component = pnlPersonalBottom'
        'Status = stsDefault')
      (
        'Component = cbPerHide'
        'Status = stsDefault')
      (
        'Component = pnlPersonalGap'
        'Status = stsDefault')
      (
        'Component = pnlPerSearch'
        'Status = stsDefault')
      (
        'Component = btnPerFind'
        'Status = stsDefault')
      (
        'Component = edtPerSearch'
        'Status = stsDefault')
      (
        'Component = cbPerMatchCase'
        'Status = stsDefault')
      (
        'Component = cbPerWholeWords'
        'Status = stsDefault')
      (
        'Component = frmCarePlanPicker'
        'Status = stsDefault'))
  end
  object popCarePlans: TPopupMenu
    OnPopup = popCarePlansPopup
    Left = 16
    Top = 104
    object mnuNodeSort: TMenuItem
      Caption = 'Sort'
      OnClick = mnuNodeSortClick
    end
    object mnuFindCarePlans: TMenuItem
      Caption = '&Find Care Plans'
      OnClick = mnuFindCarePlansClick
    end
    object mnuCollapseTree: TMenuItem
      Caption = 'Collapse &Tree'
    end
  end
  object imgLblCarePlans: TVA508ImageListLabeler
    Components = <
      item
        Component = tvPersonal
      end
      item
        Component = tvShared
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 176
    Top = 112
  end
  object mnuMain: TMainMenu
    Left = 64
    Top = 104
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      object mnuCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuCopyClick
      end
      object mnuSelectAll: TMenuItem
        Caption = 'Select &All'
        ShortCut = 16449
        OnClick = mnuSelectAllClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mnuTry: TMenuItem
        Caption = 'Preview/Print CarePlan'
        ShortCut = 16468
        OnClick = mnuTryClick
      end
    end
    object mnuCarePlan: TMenuItem
      Caption = '&Action'
      object mnuSort: TMenuItem
        Caption = 'Sort'
        OnClick = mnuSortClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object mnuFindShared: TMenuItem
        Caption = 'Find &Shared CarePlans'
        OnClick = mnuFindSharedClick
      end
      object mnuFindPersonal: TMenuItem
        Caption = '&Find Personal CarePlans'
        OnClick = mnuFindPersonalClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuShCollapse: TMenuItem
        Caption = 'Collapse Shared Tree'
        OnClick = mnuShCollapseClick
      end
      object mnuPerCollapse: TMenuItem
        Caption = 'Collapse Personal Tree'
        OnClick = mnuPerCollapseClick
      end
    end
  end
end
