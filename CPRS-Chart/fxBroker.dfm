inherited frmBroker: TfrmBroker
  Left = 338
  Top = 235
  BorderIcons = [biSystemMenu]
  Caption = 'Broker Calls'
  ClientHeight = 571
  ClientWidth = 979
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  ExplicitWidth = 995
  ExplicitHeight = 609
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 979
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      979
      75)
    object lblMaxCalls: TLabel
      Left = 8
      Top = 8
      Width = 91
      Height = 13
      Caption = 'Max Calls Retained'
    end
    object lblStoredCallsNum: TLabel
      Left = 236
      Top = 8
      Width = 68
      Height = 13
      Caption = 'Stored Calls: 0'
    end
    object lblCallID: TStaticText
      Left = 236
      Top = 27
      Width = 90
      Height = 17
      Alignment = taCenter
      Caption = 'Last Broker Call -0'
      TabOrder = 4
    end
    object txtMaxCalls: TCaptionEdit
      Left = 8
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 0
      Text = '100'
      Caption = 'Max Calls Retained'
    end
    object cmdPrev: TBitBtn
      Left = 874
      Top = 8
      Width = 50
      Height = 37
      Anchors = [akTop, akRight]
      Caption = 'Prev'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = cmdPrevClick
      Glyph.Data = {
        36010000424D360100000000000076000000280000001E0000000C0000000100
        040000000000C000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777887777
        7777777778877777770077777008777777777777778777777700777700087777
        7777777777877777770077700008888888877777778888888800770000000000
        0087777777777777780070000000000000877777777777777800F00000000000
        008F7777777777777800FF0000000000008F77777777777778007FF00007FFFF
        FF77FF77777FFFFFF70077FF0008777777777FF7778777777700777FF0087777
        777777FF7787777777007777FFF777777777777FFF7777777700}
      Layout = blGlyphTop
    end
    object cmdNext: TBitBtn
      Left = 924
      Top = 8
      Width = 50
      Height = 37
      Anchors = [akTop, akRight]
      Caption = 'Next'
      TabOrder = 2
      OnClick = cmdNextClick
      Glyph.Data = {
        36010000424D360100000000000076000000280000001E0000000C0000000100
        040000000000C000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777778877
        777777777778877777007777777F00877777777777F7787777007777777F0008
        7777777777F77787770078888887000087778888887777787700F00000000000
        087F7777777777778700F00000000000008F7777777777777800F00000000000
        007F7777777777777700F00000000000077F7777777777777700FFFFFFFF0000
        777FFFFFFFF7777777007777777F00077777777777F7777777007777777F0077
        7777777777F7777777007777777FF7777777777777FF77777700}
      Layout = blGlyphTop
    end
    object udMax: TUpDown
      Left = 89
      Top = 24
      Width = 15
      Height = 21
      Associate = txtMaxCalls
      Min = 1
      Position = 100
      TabOrder = 3
    end
    object btnRLT: TButton
      Left = 837
      Top = 23
      Width = 31
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'RLT'
      TabOrder = 6
      OnClick = btnRLTClick
    end
    object cboJumpTo: TComboBox
      Left = 8
      Top = 50
      Width = 966
      Height = 21
      Hint = 'Jump to a prior stored call'
      Anchors = [akLeft, akTop, akRight]
      Constraints.MinWidth = 400
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '-- Select a call to jump to --'
      OnChange = cboJumpToChange
      OnDropDown = cboJumpToDropDown
    end
    object btnClear: TBitBtn
      Left = 110
      Top = 22
      Width = 57
      Height = 24
      Caption = '&Clear'
      TabOrder = 8
      OnClick = btnClearClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFDAE0FAD8DFFAFFFFFFFFFFFFFFFFFFD9DFFAE9ECFCFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFBAC7F7143CE25875E9FFFFFFFFFFFFFFFFFF
        1B43E1294EE3D9E0FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEBDF6123D
        E44465E9EDF0FDFFFFFFFFFFFFFFFFFF4363E60833DE1A42E2E5E9FCFFFFFFFF
        FFFFFFFFFFFFFFFFAFBDF70633E5244CE6EDF1FDFFFFFFFFFFFFFFFFFFFFFFFF
        F3F5FD728AED0632E1234AE7CED7FAFFFFFFFFFFFF92A6F5153FE8244DE8E7EB
        FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFCFF8399F10C38E7274FEBD3
        DBFBACBCF90D3AEB2B51EBE6EAFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFACBBF70C39EB0735EC0534EC103CEBE2E7FCFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5C7AF405
        34EE0434EFADBDF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFCFDFF8BA1F90434F01C47F12952F41E49F5DAE2FEFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A87F80636F31C47F1E1
        E6FDF2F5FE4065F82650FAF3F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        F9FAFF7C95FB0434F41844F4CBD5FCFFFFFFFFFFFFF3F5FF6785FC2C56FBE9ED
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5E7EFB0335F7133FF5DAE1FDFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF7F98FD1442FBEBEFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0637F91241F7C8D2FDFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFFBFCC
        FEDEE5FEFFFFFFFFFFFFFFFFFFFFFFFF6A87FBB2C1FDFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
    object btnFilter: TBitBtn
      Left = 173
      Top = 22
      Width = 57
      Height = 24
      Caption = '&Filter'
      TabOrder = 9
      OnClick = btnFilterClick
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777700007000000000000000000700007C0CCCCCCC0CCCCCCC0700007C07
        FFFFFC077FFFFC0700007C0F7FFFFC077FFFFC0700007C07F7FFFC077FFFFC07
        00007C077F7FFC077FFFFC0700007C077FF7FC077FFFFC0700007C0777777C07
        77777C0700007C00000000000000000700007C0CCCCCCC0CCCCCCC0700007C07
        7FFFFC07FFFFFC0700007C077FFFFC0F7FFFFC0700007C077FFFFC07F7FFFC07
        00007C077FFFFC077F7FFC0700007C077FFFFC077FF7FC0700007C0777777C07
        77777C0700007C00000000000000000700007CCCCCCCCCCCCCCCCC0700007777
        77777777777777770000}
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 75
    Width = 979
    Height = 496
    Align = alClient
    BevelOuter = bvNone
    Color = clActiveCaption
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 252
      Top = 0
      Height = 496
      ExplicitLeft = 232
      ExplicitTop = 48
      ExplicitHeight = 100
    end
    object PanelBottomLeft: TPanel
      Left = 0
      Top = 0
      Width = 252
      Height = 496
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object tabRPCViewMode: TTabControl
        Left = 0
        Top = 28
        Width = 252
        Height = 25
        Align = alTop
        TabOrder = 0
        Tabs.Strings = (
          'Time'
          'Name'
          'Tree')
        TabIndex = 0
        OnChange = tabRPCViewModeChange
        ExplicitLeft = 8
        ExplicitTop = 64
        ExplicitWidth = 250
      end
      object lbRPCList: TListBox
        Left = 24
        Top = 216
        Width = 121
        Height = 97
        ItemHeight = 13
        TabOrder = 1
        OnClick = lbRPCListClick
      end
      object tvRPC: TTreeView
        Left = 24
        Top = 344
        Width = 121
        Height = 97
        Indent = 19
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        OnClick = tvRPCClick
        OnCollapsing = tvRPCCollapsing
        OnDblClick = tvRPCDblClick
      end
      object pnlBanner: TPanel
        Left = 0
        Top = 0
        Width = 252
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          252
          28)
        object edtSearch: TEdit
          Left = 2
          Top = 1
          Width = 202
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object btnSearch: TBitBtn
          Left = 230
          Top = 1
          Width = 20
          Height = 20
          Anchors = [akTop, akRight]
          TabOrder = 1
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
        object btnClearSrch: TBitBtn
          Left = 208
          Top = 1
          Width = 20
          Height = 20
          Anchors = [akTop, akRight]
          TabOrder = 2
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
      end
    end
    object pnlbottomRight: TPanel
      Left = 255
      Top = 0
      Width = 724
      Height = 496
      Align = alClient
      Caption = 'pnlbottomRight'
      TabOrder = 1
      ExplicitLeft = 253
      ExplicitWidth = 726
      object memData: TRichEdit
        Left = 1
        Top = 1
        Width = 722
        Height = 494
        Align = alClient
        HideScrollBars = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WantReturns = False
        ExplicitWidth = 724
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 184
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lblCallID'
        'Status = stsDefault')
      (
        'Component = txtMaxCalls'
        'Status = stsDefault')
      (
        'Component = cmdPrev'
        'Status = stsDefault')
      (
        'Component = cmdNext'
        'Status = stsDefault')
      (
        'Component = udMax'
        'Status = stsDefault')
      (
        'Component = btnRLT'
        'Status = stsDefault')
      (
        'Component = memData'
        'Status = stsDefault')
      (
        'Component = frmBroker'
        'Status = stsDefault')
      (
        'Component = cboJumpTo'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = btnFilter'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = PanelBottomLeft'
        'Status = stsDefault')
      (
        'Component = pnlbottomRight'
        'Status = stsDefault')
      (
        'Component = tabRPCViewMode'
        'Status = stsDefault')
      (
        'Component = lbRPCList'
        'Status = stsDefault')
      (
        'Component = tvRPC'
        'Status = stsDefault')
      (
        'Component = pnlBanner'
        'Status = stsDefault')
      (
        'Component = edtSearch'
        'Status = stsDefault')
      (
        'Component = btnSearch'
        'Status = stsDefault')
      (
        'Component = btnClearSrch'
        'Status = stsDefault'))
  end
end
