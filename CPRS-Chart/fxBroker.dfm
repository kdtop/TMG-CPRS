inherited frmBroker: TfrmBroker
  Left = 338
  Top = 235
  BorderIcons = [biSystemMenu]
  Caption = 'Broker Calls'
  ClientHeight = 273
  ClientWidth = 491
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  ExplicitWidth = 499
  ExplicitHeight = 307
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 491
    Height = 75
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      491
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
      Left = 386
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
      Left = 436
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
      Left = 349
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
      Width = 478
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
  object memData: TRichEdit [1]
    Left = 0
    Top = 75
    Width = 491
    Height = 198
    Align = alClient
    HideScrollBars = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
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
        'Status = stsDefault'))
  end
end
