inherited frmFrame: TfrmFrame
  Left = 196
  Top = 119
  Caption = 'p'
  ClientHeight = 754
  ClientWidth = 872
  FormStyle = fsMDIForm
  Menu = mnuFrame
  OldCreateOrder = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 888
  ExplicitHeight = 812
  PixelsPerInch = 96
  TextHeight = 13
  object sbtnFontLarger: TSpeedButton [0]
    Tag = 1
    Left = 58
    Top = 96
    Width = 18
    Height = 18
    Hint = 'LARGER font size'
    Flat = True
    Glyph.Data = {
      42040000424D4204000000000000420000002800000010000000100000000100
      20000300000000040000130B0000130B00000000000000000000000000FF0000
      FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
      C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFDFBB93FFD6
      B189FFD1AE87FFD1AE87FFD6B189FFDFBB93FFE4C4A2FFEAD2B8FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFDFBB93FFDBB083FFCE
      A87DFFFEFDFCFFFEFDFCFFCEA87DFFDBB083FFDFBB93FFE7CAABFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD6B189FFCEA87DFFCD
      A578FFFEFDFCFFFEFDFCFFCDA578FFCEA87DFFD6B189FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
      FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
      FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDBC2A7FFF1DFCDFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFE5D0BAFFDCC3AAFFDB
      C2A8FFFEFDFCFFFEFDFCFFDBC2A8FFDCC3AAFFE5D0BAFFF3E5D7FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF5E9DDFFF4E6D8FFDF
      CBB4FFFEFDFCFFFEFDFCFFDFCBB4FFF4E6D8FFF5E9DDFFF7EEE5FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFAF2EBFFEB
      DFD1FFE2D2C0FFE2D2C0FFEBDFD1FFFAF2EBFFFAF4EEFFFBF6F2FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
      FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbtnFontChangeClick
  end
  object sbtnFontNormal: TSpeedButton [1]
    Left = 41
    Top = 96
    Width = 18
    Height = 18
    Hint = 'NORMAL font size'
    Flat = True
    Glyph.Data = {
      42040000424D4204000000000000420000002800000010000000100000000100
      20000300000000040000130B0000130B00000000000000000000000000FF0000
      FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
      C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFE7CCAEFFEA
      D8C4FFE8D6C3FFE8D6C3FFEAD8C4FFE7CCAEFFE4C4A2FFEAD2B8FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CCAEFFF6EBE0FFFE
      FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF6EBE0FFE7CCAEFFE7CAABFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFEAD8C4FFFEFEFEFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEAD8C4FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFE8D6C3FFFEFEFEFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFE8D6C3FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFEDE0D3FFFEFEFEFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEDE0D3FFF1DFCDFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFF2E7DCFFFEFEFEFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFF2E7DCFFF3E5D7FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFFCF8F5FFFE
      FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFCF8F5FFF7EEE5FFF7EEE5FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFBF5F0FFF5
      EFE8FFF0E8DFFFF0E8DFFFF5EFE8FFFBF5F0FFFAF4EEFFFBF6F2FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
      FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbtnFontChangeClick
  end
  object sbtnFontSmaller: TSpeedButton [2]
    Tag = -1
    Left = 21
    Top = 96
    Width = 18
    Height = 18
    Hint = 'SMALLER font size'
    Flat = True
    Glyph.Data = {
      42040000424D4204000000000000420000002800000010000000100000000100
      20000300000000040000130B0000130B00000000000000000000000000FF0000
      FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC29B87FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFF0DECBFFF0DECBFFF0
      DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFEAD2B8FFEAD2B8FFEA
      D2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CAABFFE7CAABFFE7
      CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFDEBD9AFFD6B189FFD6
      B189FFD6B189FFD6B189FFD6B189FFD6B189FFDCBB96FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
      FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
      FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDDC5ACFFF1DFCDFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFECDCCBFFE6D2BEFFE5
      D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFEAD9C7FFF3E5D8FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFF7EEE5FFF7
      EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF3EDFFFAF4EEFFFA
      F4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFBF6F2FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
      FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
      A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
      00FFFFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbtnFontChangeClick
  end
  object pnlNoPatientSelected: TPanel [3]
    Left = 0
    Top = 0
    Width = 872
    Height = 754
    Align = alClient
    Caption = 'No patient is currently selected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
    ExplicitHeight = 734
    object wbNoPatientSelected: TWebBrowser
      Left = 1
      Top = 1
      Width = 870
      Height = 752
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 80
      ExplicitTop = 232
      ExplicitWidth = 300
      ExplicitHeight = 150
      ControlData = {
        4C000000EB590000B94D00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnlPatientSelected: TPanel [4]
    Left = 0
    Top = 0
    Width = 872
    Height = 754
    Align = alClient
    Color = clInactiveBorder
    TabOrder = 0
    ExplicitHeight = 734
    object bvlPageTop: TBevel
      Left = 1
      Top = 41
      Width = 870
      Height = 1
      Align = alTop
      ExplicitWidth = 674
    end
    object btnEditNormalZoom: TSpeedButton
      Left = 606
      Top = 0
      Width = 18
      Height = 18
      Hint = 'View Normal Size'
      Flat = True
      Glyph.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000130B0000130B00000000000000000000000000FF0000
        FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
        C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFE7CCAEFFEA
        D8C4FFE8D6C3FFE8D6C3FFEAD8C4FFE7CCAEFFE4C4A2FFEAD2B8FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CCAEFFF6EBE0FFFE
        FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF6EBE0FFE7CCAEFFE7CAABFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFEAD8C4FFFEFEFEFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEAD8C4FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFE8D6C3FFFEFEFEFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFE8D6C3FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFEDE0D3FFFEFEFEFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEDE0D3FFF1DFCDFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFF2E7DCFFFEFEFEFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFF2E7DCFFF3E5D7FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFFCF8F5FFFE
        FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFCF8F5FFF7EEE5FFF7EEE5FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFBF5F0FFF5
        EFE8FFF0E8DFFFF0E8DFFFF5EFE8FFFBF5F0FFFAF4EEFFFBF6F2FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
        FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FF}
      ParentShowHint = False
      ShowHint = True
    end
    object btnEditZoomOut: TSpeedButton
      Left = 588
      Top = 0
      Width = 18
      Height = 18
      Hint = 'Zoom Out'
      Flat = True
      Glyph.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000130B0000130B00000000000000000000000000FF0000
        FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC29B87FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFF0DECBFFF0DECBFFF0
        DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFEAD2B8FFEAD2B8FFEA
        D2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CAABFFE7CAABFFE7
        CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFDEBD9AFFD6B189FFD6
        B189FFD6B189FFD6B189FFD6B189FFD6B189FFDCBB96FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
        FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
        FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDDC5ACFFF1DFCDFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFECDCCBFFE6D2BEFFE5
        D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFEAD9C7FFF3E5D8FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFF7EEE5FFF7
        EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF3EDFFFAF4EEFFFA
        F4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFBF6F2FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
        FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FF}
      ParentShowHint = False
      ShowHint = True
    end
    object btnEditZoomIn: TSpeedButton
      Left = 624
      Top = 0
      Width = 18
      Height = 18
      Hint = 'Zoom In'
      Flat = True
      Glyph.Data = {
        42040000424D4204000000000000420000002800000010000000100000000100
        20000300000000040000130B0000130B00000000000000000000000000FF0000
        FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
        C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFDFBB93FFD6
        B189FFD1AE87FFD1AE87FFD6B189FFDFBB93FFE4C4A2FFEAD2B8FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFDFBB93FFDBB083FFCE
        A87DFFFEFDFCFFFEFDFCFFCEA87DFFDBB083FFDFBB93FFE7CAABFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD6B189FFCEA87DFFCD
        A578FFFEFDFCFFFEFDFCFFCDA578FFCEA87DFFD6B189FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
        FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
        FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDBC2A7FFF1DFCDFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFE5D0BAFFDCC3AAFFDB
        C2A8FFFEFDFCFFFEFDFCFFDBC2A8FFDCC3AAFFE5D0BAFFF3E5D7FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF5E9DDFFF4E6D8FFDF
        CBB4FFFEFDFCFFFEFDFCFFDFCBB4FFF4E6D8FFF5E9DDFFF7EEE5FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFAF2EBFFEB
        DFD1FFE2D2C0FFE2D2C0FFEBDFD1FFFAF2EBFFFAF4EEFFFBF6F2FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
        FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
        A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
        00FFFFFF00FF}
      ParentShowHint = False
      ShowHint = True
    end
    object pnlToolbar: TPanel
      Left = 1
      Top = 1
      Width = 870
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      Caption = 'object pnlRemoteData: TKeyClickPanel'
      TabOrder = 0
      object bvlToolTop: TBevel
        Left = 0
        Top = 0
        Width = 870
        Height = 1
        Align = alTop
        Style = bsRaised
        ExplicitWidth = 674
      end
      object pnlCCOW: TPanel
        Left = 0
        Top = 1
        Width = 39
        Height = 39
        Align = alLeft
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        object imgCCOW: TImage
          Left = 2
          Top = 2
          Width = 35
          Height = 35
          Align = alClient
          Center = True
          Picture.Data = {
            07544269746D617052030000424D520300000000000052020000280000001000
            000010000000010008000000000000010000120B0000120B0000870000008700
            00003F3E3F003A393A007B351600BCB6B30082340900642700008D3F0D00985B
            3400B19A8C00B5A59B008B3700008A3700008936000088360000873500008635
            00008535000083340000813300007D3100007D3200007B3100007A3000007830
            0000772F0000762F0000742E00006F2C00006E2B00006C2B00006A2A00006829
            0000662800006528000061260000602600005C2400005B240000592300005823
            0000562200008B3801008C3902008C3903008C3A04008C3B05008D3B06008D3C
            07008E3E0A008F420F009045130090481900935025009B6440009F6D4C00A275
            5800A6806700AA897300AD917F00B8AEA700053A0D00063B0E000C3F14000E41
            16000A3C17002351360000007F0000007B000101800001017F00040480000707
            820007078100080882000A0A82000D0D7200101085000E0E7200131386001313
            7500171787001919880021218A0025258C0023237B002B2B8E002C2C8E002F2F
            8F002C2C79003535840039398500FFFFFF00DFDFDF00BFBFBF00BEBEBE00BCBC
            BC00BBBBBB00B9B9B900B8B8B800B7B7B700B4B4B400B2B2B200B1B1B100ACAC
            AC00A9A9A900A7A7A700A6A6A600A4A4A400A2A2A2009F9F9F00989898009797
            970094949400929292008F8F8F008C8C8C008B8B8B0089898900858585008484
            840083838300818181007F7F7F007E7E7E007D7D7D007B7B7B007A7A7A007979
            79007777770076767600747474000A0A0A000707070001010100000000005D04
            868686865D868686865D5D5D5D5D5D865B5B5B5B865B5B5B5B865D5D5D5D865B
            8686868686868686865B865D5D5D865B865D865D5D5D865D865B865D5D5D865B
            8686868686868686865B865D5D5D0A865B5B5B5B865B5B5B5B865D5D5D5D0A0A
            868686865D868686865D5D5D5D5D0A0A0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A
            0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A0A0A0A0A5D5D5D5D5D5D5D5D5D5D5D29
            0A0A0A5D5D5D5D5D5D0C0C5D5D5D5D5D0A0A5D5D5D5D5D5D5D0C0C0C5D5D5D0A
            0A0A2F5D5D5D5D5D5D5D0C0C0C5D5D0A0A0A305D5D5D5D5D5D5D5D0C0C5D5D02
            0A0A025D5D5D5D5D0C0C0C0C0C5D5D5D5D5D5D5D5D5D5D5D0C0C0C0C5D5D}
          ExplicitLeft = 4
          ExplicitTop = -1
        end
      end
      object pnlPatient: TKeyClickPanel
        Left = 78
        Top = 1
        Width = 187
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click for more patient information.'
        Align = alLeft
        BevelWidth = 2
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoBk
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        OnClick = pnlPatientClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPatientMouseDown
        OnMouseUp = pnlPatientMouseUp
        object lblPtName: TStaticText
          Left = 6
          Top = 4
          Width = 118
          Height = 17
          Cursor = crHandPoint
          Caption = 'No Patient Selected'
          Font.Charset = ANSI_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
        object lblPtSSN: TStaticText
          Left = 6
          Top = 19
          Width = 64
          Height = 17
          Cursor = crHandPoint
          Caption = '000-00-0000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
        object lblPtAge: TStaticText
          Left = 175
          Top = 19
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
      end
      object pnlVisit: TKeyClickPanel
        Left = 265
        Top = 1
        Width = 119
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click to change provider/location.'
        Align = alLeft
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        OnClick = pnlVisitClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        object lblPtLocation: TStaticText
          Left = 6
          Top = 4
          Width = 53
          Height = 17
          Cursor = crHandPoint
          Caption = 'Location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlVisitClick
        end
        object lblPtProvider: TStaticText
          Left = 6
          Top = 17
          Width = 43
          Height = 17
          Cursor = crHandPoint
          Caption = 'Provider'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = lblPtProviderClick
        end
      end
      object pnlPrimaryCare: TKeyClickPanel
        Left = 384
        Top = 1
        Width = 50
        Height = 39
        Cursor = crHandPoint
        Hint = 'Primary Care Team / Primary Care Provider'
        Align = alLeft
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = True
        OnClick = pnlPrimaryCareClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPrimaryCareMouseDown
        OnMouseUp = pnlPrimaryCareMouseUp
        object lblPtCare: TStaticText
          Left = 6
          Top = 4
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtAttending: TStaticText
          Left = 6
          Top = 19
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtMHTC: TStaticText
          Left = 6
          Top = 34
          Width = 4
          Height = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
      end
      object pnlReminders: TKeyClickPanel
        Left = 765
        Top = 1
        Width = 35
        Height = 39
        Cursor = crHandPoint
        Align = alRight
        BevelWidth = 2
        Caption = 'Reminders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        TabStop = True
        OnClick = pnlRemindersClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlRemindersMouseDown
        OnMouseUp = pnlRemindersMouseUp
        object imgReminder: TImage
          Left = 2
          Top = 2
          Width = 31
          Height = 35
          Cursor = crHandPoint
          Align = alClient
          Center = True
          OnMouseDown = pnlRemindersMouseDown
          OnMouseUp = pnlRemindersMouseUp
        end
        object anmtRemSearch: TAnimate
          Left = 2
          Top = 2
          Width = 31
          Height = 35
          Cursor = crHandPoint
          Align = alClient
          Visible = False
        end
      end
      object pnlPostings: TKeyClickPanel
        Left = 800
        Top = 1
        Width = 70
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click to display patient postings.'
        Align = alRight
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        TabStop = True
        OnClick = pnlPostingsClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPostingsMouseDown
        OnMouseUp = pnlPostingsMouseUp
        object lblPtPostings: TStaticText
          Left = 5
          Top = 4
          Width = 57
          Height = 13
          Cursor = crHandPoint
          Alignment = taCenter
          AutoSize = False
          Caption = 'No Postings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
        object lblPtCWAD: TStaticText
          Left = 6
          Top = 19
          Width = 57
          Height = 13
          Cursor = crHandPoint
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
      end
      object paVAA: TKeyClickPanel
        Left = 498
        Top = 1
        Width = 60
        Height = 39
        Cursor = crHandPoint
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        Visible = False
        DesignSize = (
          60
          39)
        object laVAA2: TButton
          Left = 0
          Top = 19
          Width = 59
          Height = 20
          Cursor = crHandPoint
          Hint = 'Click to display patient insurance data'
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'laVAA2'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = laVAA2Click
        end
        object laMHV: TButton
          Left = 0
          Top = 0
          Width = 59
          Height = 18
          Cursor = crHandPoint
          Hint = 'Click to display MHV data'
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'laMHV'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = laMHVClick
        end
      end
      object pnlRemoteData: TKeyClickPanel
        Left = 692
        Top = 1
        Width = 73
        Height = 39
        Align = alRight
        BevelWidth = 2
        Caption = 'Remote Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TabStop = True
        OnClick = pnlCIRNClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlCIRNMouseDown
        OnMouseUp = pnlCIRNMouseUp
        object pnlVistaWeb: TKeyClickPanel
          Left = 2
          Top = 2
          Width = 69
          Height = 18
          Cursor = crHandPoint
          Hint = 'Click to open VistaWeb'
          Align = alTop
          BevelWidth = 2
          Caption = 'VistaWeb'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlVistaWebClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlVistaWebMouseDown
          OnMouseUp = pnlVistaWebMouseUp
          object lblVistaWeb: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 14
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            Caption = 'VistaWeb'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clInfoText
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlVistaWebClick
            ExplicitWidth = 46
            ExplicitHeight = 13
          end
        end
        object pnlCIRN: TKeyClickPanel
          Left = 2
          Top = 20
          Width = 69
          Height = 17
          Align = alClient
          BevelWidth = 2
          Caption = 'Remote Data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = pnlCIRNClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlCIRNMouseDown
          OnMouseUp = pnlCIRNMouseUp
          object lblCIRN: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 13
            Align = alClient
            Alignment = taCenter
            Caption = 'Remote Data'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlCIRNClick
            ExplicitWidth = 63
          end
          object lblLoadSequelPat: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 13
            Hint = 'Load patient who is selected in SequelMed'
            Align = alClient
            Alignment = taCenter
            Caption = 'Sequel Pat'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = lblLoadSequelPatClick
            ExplicitWidth = 52
          end
        end
      end
      object pnlCVnFlag: TPanel
        Left = 558
        Top = 1
        Width = 91
        Height = 39
        Align = alRight
        TabOrder = 4
        object btnCombatVet: TButton
          Left = 1
          Top = 1
          Width = 89
          Height = 37
          Cursor = crHandPoint
          Hint = 'Click to display combat veteran eligibility details.'
          Align = alClient
          Caption = 'CV JAN 30, 2008'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCombatVetClick
        end
        object pnlFlag: TKeyClickPanel
          Left = 1
          Top = 1
          Width = 89
          Height = 37
          Cursor = crHandPoint
          Hint = 'Click to display patient record flags.'
          Align = alClient
          BevelWidth = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlFlagClick
          OnEnter = pnlFlagEnter
          OnExit = pnlFlagExit
          OnMouseDown = pnlFlagMouseDown
          OnMouseUp = pnlFlagMouseUp
          object lblFlag: TLabel
            Left = 2
            Top = 22
            Width = 85
            Height = 13
            Cursor = crHandPoint
            Align = alBottom
            Alignment = taCenter
            Caption = 'Flag'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
            OnClick = pnlFlagClick
            OnMouseDown = pnlFlagMouseDown
            OnMouseUp = pnlFlagMouseUp
            ExplicitWidth = 25
          end
        end
      end
      object pnlPatientImage: TPanel
        Left = 39
        Top = 1
        Width = 39
        Height = 39
        Cursor = crHandPoint
        Align = alLeft
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        object PatientImage: TImage
          Left = 2
          Top = 2
          Width = 35
          Height = 35
          Cursor = crHandPoint
          Hint = 'Patient Photo ID Thumbnail.  Click for more.'
          Align = alClient
          Center = True
          ParentShowHint = False
          Picture.Data = {
            07544269746D617036090000424D360900000000000036000000280000001800
            000018000000010020000000000000090000130B0000130B0000000000000000
            0000FEFEFEFFFEFEFEFFFDFDFDFFFCFCFCFFFAFAFAFFF5F5F5FFECECECFFE1E1
            E1FFD6D6D6FFCCCCCCFFC4C4C4FFC0C0C0FFC2C2C2FFC7C7C7FFD0D0D0FFDBDA
            DAFFE5E5E5FFF0F0F0FFF7F7F7FFFBFBFBFFFCFCFCFFFEFEFEFFFEFEFEFFFEFE
            FEFFFEFEFEFFFDFDFDFFFBFBFBFFDEDEDEFFAEAEADFF8C8B8BFF6F6E6EFF5756
            56FF444242FF343433FF2C2B2AFF292727FF2B2929FF302F2EFF3A3A39FF4C4B
            4BFF616060FF7B7B7AFF9C9B9BFFC3C3C2FFEEEEEEFFFCFCFCFFFDFDFDFFFEFE
            FEFFFFFFFFFFFFFFFFFF9E9E9DFF494848FF474746FF464544FF41403FFF3A39
            39FF333231FF2E2D2CFF2B2A2AFF2A2828FF292828FF2A2929FF2E2C2CFF3534
            34FF3D3C3BFF434241FF4A4949FF4E4E4CFF5A5959FFB8B8B8FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF7E7D7CFF4A4949FF545352FF525150FF4C4C4BFF4545
            43FF3C3B3BFF353434FF2F2E2EFF2D2C2CFF2D2B2BFF2E2E2EFF353434FF3D3C
            3CFF454444FF4C4B4BFF535352FF595958FF504F4FFF8C8B8AFFFFFFFFFFFFFF
            FFFFFEFEFEFFFFFFFFFFB1B1B0FF4B4949FF5B5B5AFF5B5A59FF585857FF5453
            52FF4C4C4BFF424141FF3B3A39FF383737FF383737FF3B3B3AFF434242FF4B4A
            4AFF515050FF555554FF5A5958FF5D5C5BFF4F4E4EFFB2B1B1FFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFF9F9F9FF484746FF5C5A5AFF595858FF555453FF504E
            4EFF464544FF3B3A39FF343332FF323030FF313030FF353333FF3D3C3BFF4745
            45FF4E4C4BFF535150FF585757FF5D5C5BFF474645FFF6F6F6FFFFFFFFFFFFFF
            FFFFFFFFFFFFFEFEFEFFFFFFFFFFB1B0B0FF5F5E5DFF666564FF615F5FFF5655
            54FF464544FF363534FF2C2B2BFF292727FF292827FF2D2D2CFF3A3838FF4948
            47FF565454FF5F5E5DFF636262FF5E5B5BFFAAA9A9FFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFC0C0C0FF8A8989FF696767FF6664
            63FF545352FF3F3D3DFF312F2FFF2B2A2AFF2C2B2AFF333232FF434241FF5856
            55FF636262FF626161FF848382FFBFBEBEFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFD9D9D9FF8785
            84FF666464FF535252FF3E3C3CFF343232FF333232FF3E3C3CFF514F4FFF5E5C
            5CFF8C8B8AFFDBDBDBFFF6F6F6FFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFC5C4C4FF706E6EFF565454FF3D3B3AFF393837FF444442FF7E7D7CFFDFDE
            DEFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFF8C8C8AFF585757FF383635FF373636FF403F3EFFE9E9E9FFFFFF
            FFFFFEFEFEFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE
            FEFFFFFFFFFF7C7B7AFF4A4847FF464443FF424140FF3D3C3BFFE8E8E8FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF3E3D3CFF393736FF363534FF373534FF32302FFFC8C8C7FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFCCCCCBFF2E2C2BFF373534FF494847FF373635FF302E2DFF8F8F8FFFFFFF
            FFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF807F7EFF393837FF383635FFC1C0C0FF3A3837FF3D3A3AFF504F4DFFF5F5
            F5FFFFFFFFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2A2
            A1FF3C3B3AFF474544FF484645FF91908FFF4A4948FF4A4847FF41403FFF5554
            53FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF7D7D
            7CFF454443FF514F4EFF53504FFFBFBFBEFF908F8FFF52504FFF4C4A4AFF4543
            43FFDCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5A4
            A4FF4F4D4CFF5B5A58FF646260FF6D6B6AFFB6B5B5FF898887FF525050FF6565
            64FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAE
            ADFF565554FF666463FF7F7D7DFF817F7EFFB2B2B2FF9A9998FF585756FF5C5B
            5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0AF
            AFFF5B5A59FF6E6D6CFFA1A09FFFB9B8B8FFB2B1B0FF737271FF5D5C5BFF5B59
            59FFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACA
            CAFF626260FF757473FF868584FF8D8C8BFF898887FF787776FF5D5C5BFF7C7B
            7AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF888786FF797878FF908F8EFF999897FF939392FF7B7B7AFF636261FFECEC
            EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFFBFBFBFFFA8A7A6FF9F9F9FFF9D9C9CFFA6A5A4FFE8E8E8FFFFFF
            FFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFF8F8F8FFF5F5F5FFF5F5F5FFFBFBFBFFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          ShowHint = True
          OnClick = PatientImageClick
          OnMouseEnter = PatientImageMouseEnter
          OnMouseLeave = PatientImageMouseLeave
          ExplicitLeft = 4
          ExplicitTop = 6
        end
      end
      object pnlTimer: TPanel
        Left = 649
        Top = 1
        Width = 43
        Height = 39
        Align = alRight
        BevelEdges = [beLeft, beTop, beRight]
        BevelInner = bvRaised
        BevelKind = bkSoft
        Caption = '00:00'
        PopupMenu = popTimerMenu
        TabOrder = 10
        VerticalAlignment = taAlignTop
        OnClick = btnTimerClick
        OnMouseDown = pnlTimerMouseDown
        object btnTimerReset: TButton
          Left = 2
          Top = 21
          Width = 35
          Height = 14
          Align = alBottom
          Caption = 'Reset'
          TabOrder = 0
          OnClick = btnTimerResetClick
        end
      end
      object pnlSchedule: TKeyClickPanel
        Left = 434
        Top = 1
        Width = 64
        Height = 39
        Cursor = crHandPoint
        Align = alClient
        Alignment = taRightJustify
        BevelEdges = [beLeft]
        BevelWidth = 2
        Caption = 'Schedule'
        Font.Charset = ARABIC_CHARSET
        Font.Color = clBtnFace
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        TabStop = True
        OnClick = pnlScheduleClick
      end
    end
    object stsArea: TStatusBar
      Left = 1
      Top = 732
      Width = 870
      Height = 21
      Panels = <
        item
          Width = 200
        end
        item
          Width = 224
        end
        item
          Style = psOwnerDraw
          Width = 50
        end
        item
          Width = 94
        end
        item
          Width = 38
        end
        item
          Width = 33
        end>
      PopupMenu = popAlerts
      SizeGrip = False
      ExplicitTop = 712
    end
    object pnlMain: TPanel
      Left = 1
      Top = 42
      Width = 870
      Height = 690
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitHeight = 670
      object frameLRSplitter: TSplitter
        Left = 781
        Top = 0
        Height = 690
        Color = clSkyBlue
        ParentColor = False
        OnMoved = frameLRSplitterMoved
        ExplicitLeft = 824
        ExplicitTop = 344
        ExplicitHeight = 100
      end
      object pnlMainL: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 690
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 670
        object pnlPageL: TPanel
          Left = 0
          Top = 0
          Width = 781
          Height = 668
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitHeight = 648
          object lstCIRNLocations: TORListBox
            Left = 422
            Top = 5
            Width = 209
            Height = 69
            TabStop = False
            Style = lbOwnerDrawFixed
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 18
            ParentFont = False
            ParentShowHint = False
            PopupMenu = popCIRN
            ShowHint = False
            TabOrder = 0
            Visible = False
            OnClick = lstCIRNLocationsClick
            OnExit = lstCIRNLocationsExit
            Caption = 'Remote Data'
            ItemTipColor = clWindow
            LongList = False
            Pieces = '2,3,4'
            TabPositions = '16'
            OnChange = lstCIRNLocationsChange
            RightClickSelect = True
            CheckBoxes = True
            CheckEntireLine = True
          end
        end
        object tabPageL: TTabControl
          Left = 0
          Top = 668
          Width = 781
          Height = 22
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          OwnerDraw = True
          ParentFont = False
          TabOrder = 1
          TabPosition = tpBottom
          OnChange = tabPageChange
          OnDrawTab = tabPageDrawTab
          OnMouseUp = tabPageMouseUp
          ExplicitTop = 648
        end
      end
      object pnlMainR: TPanel
        Left = 784
        Top = 0
        Width = 86
        Height = 690
        Align = alClient
        TabOrder = 1
        OnResize = pnlMainRResize
        ExplicitHeight = 670
        object pnlPageR: TPanel
          Left = 1
          Top = 1
          Width = 84
          Height = 666
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 646
        end
        object tabPageR: TTabControl
          Left = 1
          Top = 667
          Width = 84
          Height = 22
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          OwnerDraw = True
          ParentFont = False
          TabOrder = 1
          TabPosition = tpBottom
          OnChange = tabPageChange
          OnDrawTab = tabPageDrawTab
          OnMouseUp = tabPageMouseUp
          ExplicitTop = 647
        end
      end
    end
  end
  object btnSplitterHandle: TBitBtn [5]
    Left = 752
    Top = 337
    Width = 30
    Height = 80
    Anchors = [akRight]
    TabOrder = 2
    Visible = False
    OnClick = btnSplitterHandleClick
    OnMouseEnter = btnSplitterHandleMouseEnter
    OnMouseLeave = btnSplitterHandleMouseLeave
    Glyph.Data = {
      36090000424D3609000000000000360000002800000018000000180000000100
      20000000000000090000130B0000130B00000000000000000000D8E9ECFED7E8
      EBFFD8E9EBFED8E9ECFED6E5E8FFD8E9EBFED8E9ECFED3BFC1FFD17778FED238
      33FFD5241CFFD81B13FFD91D13FFD5261DFFD43D36FFD27B7BFED4C0C3FFD8E9
      EBFED8E9ECFED6E5E8FFD8E9EBFED8E9ECFED7E8EBFFD8E9EBFED8E9ECFFD7E8
      EBFFD8E9EBFFD8E9ECFFD7E8EBFFD4CACBFFCF4544FFD51710FFE03A1FFFE96A
      37FFEF8A47FFF09B50FFF19E52FFEF8E4BFFEC723DFFE44527FFD92217FFD34F
      4CFFD5CBCDFFD7E8EBFFD8E9EBFFD8E9ECFFD7E8EBFFD8E9EBFFD8E9ECFED7E8
      EBFFD8E9ECFED8E9ECFED08C8FFFD01511FFE23B20FFED7F41FFF4AE59FFF6C8
      67FFF8D470FFF9DD75FFF8DA74FFF8D472FFF6CB6CFFF5B361FFEE8D4CFFE650
      2EFFD6231BFFD29193FFD8E9ECFED8E9ECFED7E8EBFFD8E9ECFED8E9ECFED7E8
      EBFFD8E9EBFECE6D6FFED6130CFFE6562DFFF29F51FFF4B660FFF6C269FFF7D0
      74FFFADE7CFFFAE883FFFAE682FFFADC7EFFF9D178FFF7C570FFF4BA69FFF3A9
      5DFFEB6F3EFFDE2618FFD27576FED8E9ECFED7E8EBFFD8E9EBFED7E6E9FFD7E8
      EBFFD08C8EFFD6110BFFE6572EFFEF914CFFF1A85AFFF4B564FFF6C26FFFF0CB
      76FFB19C5CFFB2A265FFD0BE73FFF9DE86FFF9D580FFECBC71FFB18752FFAE7E
      4AFFE79755FFEA7240FFDC2417FFD29294FFD7E8EBFFD7E6E8FFD8E9ECFED2C8
      CAFFCF100DFFE24223FFED8244FFF09550FFF2A75EFFF5B66AFFBF995CFF9F8A
      5EFFD3C9B4FFF0E7D8FFC6B286FFEFD588FFC8AB6CFFA48C62FFD5C9B3FFD9C8
      AEFFA86E3EFFCA7C48FFA74729FFD1211AFFD3CACCFFD8E9ECFED8E9ECFECB3F
      40FFD92112FFEB713AFFEE8748FFEF9554FFBB844DFF9C7D52FFBEB197FFFBF5
      E7FFFFFFFAFFF7F2E9FFA1957FFF958258FFD0C5ABFFFEF7EAFFFFFFF7FFD8D2
      C7FF61452BFF7D6751FFC8B29BFFE9654EFFD14F4DFFD8E9EBFED2BEC1FFCF09
      07FFE24324FFEC7740FFCC7441FF916037FFB29D7FFFF3EAD7FFFFFFFBFFF7F4
      EAFFCAC4B9FFA5A094FFB7B1A3FFF5F0E4FFFFFFFCFFEBE7DFFFB0AA9EFF928D
      80FFB6AFA0FFF8F3E3FFFFFCECFFF5B192FFD92018FFD4C1C3FFCF7274FED614
      0CFFD6512BFF884624FF9C7A58FFE1D4BEFFFFFFF6FFFCF7ECFFD0CABFFFA39D
      90FFB4AFA2FFE9E5DBFFFEFEF9FFF7F4EDFFCBC6BBFFA39C8FFFC1BCAFFFEFEA
      DDFFFFFFF7FFFEF9EBFFFEF6E4FFF9D8BFFFE54937FFD37B7CFECD2A2AFFA21B
      0EFF835034FFD2BDA2FFFFFAE6FFFFFFF1FFDCD3C9FF9F988BFFA1988BFFDFD8
      CDFFFFFCF4FFFEFDF6FFE1DBD3FFBAB3A7FFC9C2B4FFF2EDE4FFFFFEF5FFFEFD
      F2FFFFF8EBFFFEF6E9FFFFF5E6FFFEEAD5FFEB795FFFD53B38FFC6100EFFCA6A
      51FFFDE9D1FFFFFBE8FFFFF7E5FFE2D8CBFF9E9487FFC6BBAFFFFBF4E9FFFFFE
      F6FFFFFEF6FFE7E1D8FFCFC6BAFFF5EFE8FFFFFDF9FFFFFDF6FFFFFAF1FFFFF9
      EEFFFEF8ECFFFEF7E8FFFFF6E4FFFEEFDDFFF0957AFFD5221EFFCF0B09FFF4B1
      98FFFFF7E4FFFEF0DCFFFEF2DEFFC9BDB1FFA5968CFFFFFAF0FFFEFBF2FFFEF9
      EFFFFEFBF4FFD4CABFFFF1EBE6FFFFFFFEFFFEFDF8FFFEFAF2FFFEFAF1FFFEF7
      ECFFFDF5E8FFFEF6E8FFFFF5E3FFFEF0DDFFF2A086FFD61714FFC20504FFAC48
      30FFDABFA2FFFFF9E4FFFEF7E5FFEEE3D4FFAC9F92FFAA9E8FFFE4DACDFFFEFA
      F1FFFFFFF7FFEFEAE1FFCBC0B2FFE3DBD0FFF9F5EEFFFEFDF6FFFFFAF1FFFDF5
      E9FFFDF3E7FFFFF4E5FFFEF2E2FFFEF0DCFFF29B83FFD51613FFCD100FFFBF1B
      10FF833018FFAA7E5DFFF3DEBFFFFFFFEFFFFAF1E3FFC4BAADFFA29787FFC0B6
      A7FFF3EDE3FFFFFFF8FFF7F2ECFFD1C8BCFFBBB1A2FFDAD0C4FFFBF4EBFFFFFC
      F1FFFFF8EAFFFFF4E5FFFEF2E1FFFEECD8FFEE846EFFD5201BFFCC2A2BFFD814
      0DFFDF3A21FFA83A23FF924B2DFFBF9C7BFFFDEEDAFFFFFFF2FFF3EDE3FFD0C7
      BDFFC0B6A7FFDAD1C5FFFDFAF3FFFFFFFAFFEDE8E0FFC0B5A8FFA89C8CFFD3C9
      BBFFFFF8E8FFFFFDECFFFFF5E2FFFBE1CCFFE85E4EFFD33938FFD07576FED109
      06FFDB2D1AFFE34126FFE54C2FFFB1462CFFAE6D45FFE4D0B8FFFFFAF0FFFFFF
      FAFFF4EFEAFFD5CEC4FFD1C7B7FFF7F2E9FFFFFFFBFFFBF7F1FFE1DCD4FF9F94
      87FF88725FFFD3C5B5FFFFF3E3FFF8C7B3FFDE3129FFD47F80FED4C0C3FFCD06
      04FFD9180FFFDE3720FFE34128FFEA5B39FFEF7750FFC66142FFCD9C7CFFF1E8
      DCFFFFFFFBFFFFFFFDFFD6BEAEFFBB805BFFEDDBCCFFFFFBF6FFFFFFFDFFF8F3
      EFFF7A3B25FF793523FF997A6CFFDB7768FFD71B1AFFD6C4C6FFD8E9ECFECE43
      44FFD10906FFDD2617FFE03B23FFF1593AFFF46E49FFF47650FFED7955FFCB71
      4FFFD8B3A0FFEBDCD0FFD8987CFFF18E65FFD6724FFFCF9B82FFEFE3D9FFF1E3
      D8FFC1573BFFDD422BFF9B281AFFBA211AFFD86363FFD8E9ECFED8E9ECFED5CB
      CDFFCE0B0BFFD40F0AFFE12D1DFFF24F31FFF45B3CFFF46644FFF46F4BFFF679
      54FFEB7451FFDF6F4DFFF07C58FFF6835CFFF6815AFFF07453FFD0573DFFD053
      38FFEA5538FFDF3422FFDB1C14FFDB3838FFD7CED0FFD8E9EBFED7E6E9FFD7E8
      EBFFD49394FFCF0403FFDA130CFFF13924FFF54D32FFF45437FFF55F3FFFF767
      47FFF66C4BFFF7704FFFF77150FFF7704FFFF76D4BFFF66949FFF65F44FFF65D
      40FFED452DFFD91C14FFDE2C2AFFDBA5A6FFD7E8EBFFD7E6E8FFD8E9ECFED7E8
      EBFFD8E9ECFED27577FECF0605FFE4120DFFF73523FFF6452EFFF64E33FFF655
      3AFFF7593BFFF75F40FFF75F40FFF75D40FFF75C40FFF7553AFFF85339FFF543
      2FFFDF1B14FFDD2B29FFDB9192FED8E9ECFED7E8EBFFD8E9ECFED8E9ECFED7E8
      EBFFD8E9EBFED8E9ECFED69A9CFFD31D1DFFE51714FFF41D15FFF83423FFF93E
      29FFF8422CFFF8452FFFF94831FFF8462FFFF94330FFF93C2BFFF2251BFFE021
      1DFFDD3B3BFFDAA5A7FFD8E9EBFED8E9ECFED7E8EBFFD8E9EBFED8E9ECFFD7E8
      EBFFD8E9EBFFD8E9ECFFD7E8EBFFD9D0D1FFDA6466FFDD2425FFE72323FFEE17
      13FFF31914FFF51F16FFF52117FFF21C15FFEC1B16FFE52A27FFDB2828FFDD6F
      70FFD8D0D2FFD7E8EBFFD8E9EBFFD8E9ECFFD7E8EBFFD8E9EBFFD8E9ECFED7E8
      EBFFD8E9ECFED8E9ECFED6E5E8FFD8E9ECFED8E9ECFED9C7C9FFD98D8FFEDB53
      54FFDF3B3BFFDF2728FFDF2728FFDE3C3CFFDB5354FFDA9091FED9C6C9FFD8E9
      ECFED8E9ECFED6E5E8FFD8E9ECFED8E9ECFED7E8EBFFD8E9ECFE}
    ExplicitTop = 327
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 48
    Data = (
      (
        'Component = pnlNoPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlToolbar'
        'Status = stsDefault')
      (
        'Component = pnlCCOW'
        'Status = stsDefault')
      (
        'Component = pnlPatient'
        'Status = stsDefault')
      (
        'Component = lblPtName'
        'Status = stsDefault')
      (
        'Component = lblPtSSN'
        'Status = stsDefault')
      (
        'Component = lblPtAge'
        'Status = stsDefault')
      (
        'Component = pnlVisit'
        'Status = stsDefault')
      (
        'Component = lblPtLocation'
        'Status = stsDefault')
      (
        'Component = lblPtProvider'
        'Status = stsDefault')
      (
        'Component = pnlPrimaryCare'
        'Status = stsDefault')
      (
        'Component = lblPtCare'
        'Status = stsDefault')
      (
        'Component = lblPtAttending'
        'Status = stsDefault')
      (
        'Component = pnlReminders'
        'Status = stsDefault')
      (
        'Component = anmtRemSearch'
        'Status = stsDefault')
      (
        'Component = pnlPostings'
        'Status = stsDefault')
      (
        'Component = lblPtPostings'
        'Status = stsDefault')
      (
        'Component = lblPtCWAD'
        'Status = stsDefault')
      (
        'Component = paVAA'
        'Status = stsDefault')
      (
        'Component = laVAA2'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = laMHV'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = stsArea'
        'Status = stsDefault')
      (
        'Component = frmFrame'
        'Status = stsDefault')
      (
        'Component = pnlRemoteData'
        'Status = stsDefault')
      (
        'Component = pnlVistaWeb'
        'Status = stsDefault')
      (
        'Component = pnlCIRN'
        'Status = stsDefault')
      (
        'Component = pnlCVnFlag'
        'Status = stsDefault')
      (
        'Component = btnCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlFlag'
        'Status = stsDefault')
      (
        'Component = pnlPatientImage'
        'Status = stsDefault')
      (
        'Component = pnlTimer'
        'Status = stsDefault')
      (
        'Component = btnTimerReset'
        'Status = stsDefault')
      (
        'Component = lblPtMHTC'
        'Status = stsDefault')
      (
        'Component = pnlSchedule'
        'Status = stsDefault')
      (
        'Component = wbNoPatientSelected'
        'Status = stsDefault')
      (
        'Component = btnSplitterHandle'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = pnlMainL'
        'Status = stsDefault')
      (
        'Component = pnlPageL'
        'Status = stsDefault')
      (
        'Component = lstCIRNLocations'
        'Status = stsDefault')
      (
        'Component = tabPageL'
        'Status = stsDefault')
      (
        'Component = pnlMainR'
        'Status = stsDefault')
      (
        'Component = pnlPageR'
        'Status = stsDefault')
      (
        'Component = tabPageR'
        'Status = stsDefault'))
  end
  object mnuFrame: TMainMenu
    Left = 172
    Top = 104
    object mnuFile: TMenuItem
      Caption = '&File'
      GroupIndex = 1
      object mnuFileOpen: TMenuItem
        Caption = 'Select &New Patient...'
        OnClick = mnuFileOpenClick
      end
      object mnuClosePatient: TMenuItem
        Caption = '&Close Patient'
        OnClick = mnuClosePatientClick
      end
      object mnuFileRefresh: TMenuItem
        Caption = 'Refresh Patient &Information'
        OnClick = mnuFileRefreshClick
      end
      object mnuEditDemographics: TMenuItem
        Caption = 'Edit Patient &Demographics'
        OnClick = mnuEditDemographicsClick
      end
      object mnuFileResumeContext: TMenuItem
        Caption = 'Rejoin patient link'
        object mnuFileResumeContextSet: TMenuItem
          Caption = 'Set new context'
          OnClick = mnuFileResumeContextSetClick
        end
        object Useexistingcontext1: TMenuItem
          Caption = 'Use existing context'
          OnClick = mnuFileResumeContextGetClick
        end
      end
      object mnuFileBreakContext: TMenuItem
        Caption = 'Break patient link'
        OnClick = mnuFileBreakContextClick
      end
      object mnuFileEncounter: TMenuItem
        Caption = '&Update Provider / Location...'
        OnClick = mnuFileEncounterClick
      end
      object mnuFileReview: TMenuItem
        Caption = '&Review/Sign Changes...'
        OnClick = mnuFileReviewClick
      end
      object Z7: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuFileNext: TMenuItem
        Caption = 'Next Noti&fication'
        OnClick = mnuFileNextClick
      end
      object mnuFileNotifRemove: TMenuItem
        Caption = 'Remo&ve Current Notification'
        OnClick = mnuFileNotifRemoveClick
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuFilePrintSetup: TMenuItem
        Caption = 'Print &Setup...'
        Enabled = False
        OnClick = mnuFilePrintSetupClick
      end
      object mnuFilePrintSelectedItems: TMenuItem
        Caption = 'Print Selected Items'
        Enabled = False
        OnClick = mnuFilePrintSelectedItemsClick
      end
      object mnuFilePrint: TMenuItem
        Caption = '&Print...'
        Enabled = False
        OnClick = mnuFilePrintClick
      end
      object mnuExportChart: TMenuItem
        Caption = 'Export Chart'
        OnClick = mnuExportChartClick
      end
      object mnuPrintLabels: TMenuItem
        Caption = 'Print Labels...'
        OnClick = mnuPrintLabelsClick
      end
      object mnuPrintAdmissionLabel: TMenuItem
        Caption = 'Print Admission Label...'
        OnClick = mnuPrintAdmissionLabelClick
      end
      object mnuFileExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuFileExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      GroupIndex = 2
      OnClick = mnuEditClick
      object mnuEditUndo: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
        OnClick = mnuEditUndoClick
      end
      object mnuEditRedo: TMenuItem
        Caption = 'Re&do'
        ShortCut = 16473
        OnClick = mnuEditRedoClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuEditCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuEditCutClick
      end
      object mnuEditCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuEditCopyClick
      end
      object mnuEditPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = mnuEditPasteClick
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuEditPref: TMenuItem
        Caption = 'P&references'
        object Prefs1: TMenuItem
          Caption = '&Fonts'
          object mnu8pt: TMenuItem
            Tag = 8
            Caption = '8 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu10pt1: TMenuItem
            Tag = 10
            Caption = '10 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu12pt1: TMenuItem
            Tag = 12
            Caption = '12 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu14pt1: TMenuItem
            Tag = 14
            Caption = '14 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu18pt1: TMenuItem
            Tag = 18
            Caption = '18 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
        end
      end
    end
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
      object mnuViewChart: TMenuItem
        Caption = 'Chart &Tab'
        object mnuChartCover: TMenuItem
          Tag = 1
          Caption = 'Cover &Sheet'
          ShortCut = 16467
          OnClick = mnuChartTabClick
        end
        object mnuChartProbs: TMenuItem
          Tag = 2
          Caption = '&Problem List'
          ShortCut = 16464
          OnClick = mnuChartTabClick
        end
        object mnuChartMeds: TMenuItem
          Tag = 3
          Caption = '&Medications'
          ShortCut = 16461
          OnClick = mnuChartTabClick
        end
        object mnuChartOrders: TMenuItem
          Tag = 4
          Caption = '&Orders'
          ShortCut = 16463
          OnClick = mnuChartTabClick
        end
        object mnuChartNotes: TMenuItem
          Tag = 6
          Caption = 'Progress &Notes'
          ShortCut = 16462
          OnClick = mnuChartTabClick
        end
        object mnuChartCslts: TMenuItem
          Tag = 7
          Caption = 'Consul&ts'
          ShortCut = 16468
          OnClick = mnuChartTabClick
        end
        object mnuChartSurgery: TMenuItem
          Tag = 11
          Caption = 'S&urgery'
          ShortCut = 16469
          OnClick = mnuChartTabClick
        end
        object mnuChartDCSumm: TMenuItem
          Tag = 8
          Caption = '&Discharge Summaries'
          ShortCut = 16452
          OnClick = mnuChartTabClick
        end
        object mnuChartLabs: TMenuItem
          Tag = 9
          Caption = '&Laboratory'
          ShortCut = 16460
          OnClick = mnuChartTabClick
        end
        object mnuChartReports: TMenuItem
          Tag = 10
          Caption = '&Reports'
          ShortCut = 16466
          OnClick = mnuChartTabClick
        end
      end
      object mnuViewInformation: TMenuItem
        Caption = 'Information'
        OnClick = mnuViewInformationClick
        object mnuViewDemo: TMenuItem
          Tag = 1
          Caption = 'De&mographics...'
          OnClick = ViewInfo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Caption = 'Visits/Pr&ovider...'
          OnClick = ViewInfo
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Caption = 'Primary &Care...'
          OnClick = ViewInfo
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Caption = 'MyHealthe&Vet...'
          OnClick = ViewInfo
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Caption = '&Insurance...'
          OnClick = ViewInfo
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Caption = '&Flags...'
          OnClick = ViewInfo
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Caption = 'Remote &Data...'
          OnClick = ViewInfo
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Caption = '&Reminders...'
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
    end
    object mnuTools: TMenuItem
      Caption = '&Tools'
      GroupIndex = 8
      object mnuBillableItems: TMenuItem
        Caption = '&Billable Items'
        OnClick = mnuBillableItemsClick
      end
      object menuNurseNote: TMenuItem
        Caption = 'Quick Nurse Note'
        OnClick = menuNurseNoteClick
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object eprescribing1: TMenuItem
        Caption = 'E-Prescribing...'
        Enabled = False
        ShortCut = 16453
        Visible = False
        OnClick = eprescribing1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuLabText: TMenuItem
        Caption = '&Send text to lab...'
        OnClick = mnuLabTextClick
      end
      object mnuADT: TMenuItem
        Caption = '&ADT'
        OnClick = mnuOpenADTClick
      end
      object mnuAnticoagulationTool: TMenuItem
        Caption = 'Anticoagulation Tool'
        OnClick = mnuAnticoagulationToolClick
      end
      object Z8: TMenuItem
        Caption = '-'
      end
      object mnuChangeES: TMenuItem
        Caption = '&Change  Electronic Signature'
        OnClick = mnuChangeESClick
      end
      object mnuTeams: TMenuItem
        Caption = 'Edit List/Teams'
        OnClick = mnuTeamsClick
      end
      object mnuToolsGraphing: TMenuItem
        Caption = '&Graphing...'
        ShortCut = 16455
        OnClick = mnuToolsGraphingClick
      end
      object LabInfo1: TMenuItem
        Caption = '&Lab Test Information...'
        OnClick = LabInfo1Click
      end
      object mnuToolsOptions: TMenuItem
        Caption = '&Options...'
        OnClick = mnuToolsOptionsClick
      end
      object DigitalSigningSetup1: TMenuItem
        Caption = 'Digital Signing Setup...'
        OnClick = DigitalSigningSetup1Click
      end
      object mnuTMGTemp: TMenuItem
        Caption = 'Test HTML'
        OnClick = mnuTMGTempClick
      end
      object mnuUploadImages: TMenuItem
        Caption = 'Upload Images'
        Visible = False
        OnClick = mnuUploadImagesClick
      end
      object mnuResetTimerSetting: TMenuItem
        Caption = 'Reset'
        Visible = False
        OnClick = mnuResetTimerSettingClick
      end
      object mnuTestGraph: TMenuItem
        Caption = 'TestGraph'
        OnClick = mnuTestGraphClick
      end
      object mnuSendMessage: TMenuItem
        Caption = 'Messager Demo'
        OnClick = mnuSendMessageClick
      end
      object mnuTaskEvent: TMenuItem
        Caption = 'Launch Task Event'
        OnClick = mnuTaskEventClick
      end
      object mnuToggleSidePanel: TMenuItem
        Caption = 'Toggle Side Panel'
        OnClick = mnuToggleSidePanelClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      GroupIndex = 9
      object mnuHelpContents: TMenuItem
        Caption = '&Contents'
        Hint = 'WinHlp32 cprs.hlp'
        OnClick = ToolClick
      end
      object mnuHelpTutor: TMenuItem
        Caption = '&Brief Tutorial'
        Enabled = False
        Visible = False
      end
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuHelpBroker: TMenuItem
        Caption = 'Last Broker Call'
        OnClick = mnuHelpBrokerClick
      end
      object mnuHelpLists: TMenuItem
        Caption = 'Show ListBox Data'
        OnClick = mnuHelpListsClick
      end
      object mnuHelpSymbols: TMenuItem
        Caption = 'Symbol Table'
        OnClick = mnuHelpSymbolsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ViewAuditTrail1: TMenuItem
        Caption = 'View &Audit Trail'
        OnClick = ViewAuditTrail1Click
      end
      object Z6: TMenuItem
        Caption = '-'
      end
      object mnuHelpAbout: TMenuItem
        Caption = '&About CPRS'
        OnClick = mnuHelpAboutClick
      end
    end
  end
  object popCIRN: TPopupMenu
    Left = 270
    Top = 144
    object popCIRNSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = popCIRNSelectAllClick
    end
    object popCIRNSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = popCIRNSelectNoneClick
    end
    object popCIRNClose: TMenuItem
      Caption = 'Close List'
      OnClick = popCIRNCloseClick
    end
  end
  object OROpenDlg: TOpenDialog
    Filter = 'Exe file (*.exe)|*.exe'
    Left = 260
    Top = 257
  end
  object popAlerts: TPopupMenu
    AutoPopup = False
    Left = 192
    Top = 144
    object mnuAlertContinue: TMenuItem
      Caption = 'Continue'
      ShortCut = 16451
      OnClick = mnuFileNextClick
    end
    object mnuAlertForward: TMenuItem
      Caption = 'Forward'
      ShortCut = 16454
      OnClick = mnuAlertForwardClick
    end
    object mnuAlertRenew: TMenuItem
      Caption = 'Renew'
      ShortCut = 16466
      OnClick = mnuAlertRenewClick
    end
  end
  object AppEvents: TApplicationEvents
    OnActivate = AppEventsActivate
    OnShortCut = AppEventsShortCut
    Left = 336
    Top = 256
  end
  object compAccessTabPage: TVA508ComponentAccessibility
    Component = tabPageL
    OnCaptionQuery = compAccessTabPageCaptionQuery
    Left = 56
    Top = 48
  end
  object timerStopwatch: TTimer
    Enabled = False
    OnTimer = timerStopwatchTimer
    Left = 440
    Top = 240
  end
  object popTimerMenu: TPopupMenu
    Left = 232
    Top = 144
    object mnuStartCounter: TMenuItem
      Caption = '&Start'
    end
    object mnuPauseCounter: TMenuItem
      Caption = '&Pause'
    end
    object mnuResetCounter: TMenuItem
      Caption = '&Reset'
    end
    object mnuStartOnKP: TMenuItem
      Caption = 'Start on &Keypress'
    end
    object mnuInsertTime: TMenuItem
      Caption = '&Insert Time'
      OnClick = mnuInsertTimeClick
    end
    object mnuResetTimerPrompt: TMenuItem
      Caption = 'Reset Chart Timer Prompt'
      Visible = False
      OnClick = mnuResetTimerPromptClick
    end
    object mnuShowTodaysReport: TMenuItem
      Caption = 'Show Today'#39's Timer Report'
      OnClick = mnuShowTodaysReportClick
    end
  end
  object timSchedule: TTimer
    Enabled = False
    OnTimer = timScheduleTimer
    Left = 424
    Top = 312
  end
  object timCheckSequel: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = timCheckSequelTimer
    Left = 696
    Top = 192
  end
  object timHideSplitterHandle: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = timHideSplitterHandleTimer
    Left = 800
    Top = 384
  end
  object ImageListSplitterHandle: TImageList
    Height = 24
    Width = 24
    Left = 800
    Top = 416
    Bitmap = {
      494C010104000900040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000060000000480000000100200000000000006C
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D7E8EB00D8E9EB000000
      0000D6E5E800D8E9EB0000000000D3BFC100D1777800D2383300D5241C00D81B
      1300D91D1300D5261D00D43D3600D27B7B00D4C0C300D8E9EB0000000000D6E5
      E800D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D6E5E800D8E9EB0000000000D3BFC100D1777800D2383300D5241C00D81B
      1300D91D1300D5261D00D43D3600D27B7B00D4C0C300D8E9EB0000000000D6E5
      E800D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D6E5E800D8E9EB0000000000D3BFC100D1777800D2383300D5241C00D81B
      1300D91D1300D5261D00D43D3600D27B7B00D4C0C300D8E9EB0000000000D6E5
      E800D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D6E5E800D8E9EB0000000000D3BFC100D1777800D2383300D5241C00D81B
      1300D91D1300D5261D00D43D3600D27B7B00D4C0C300D8E9EB0000000000D6E5
      E800D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D4CACB00CF454400D5171000E03A1F00E96A3700EF8A4700F09B
      5000F19E5200EF8E4B00EC723D00E4452700D9221700D34F4C00D5CBCD00D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D4CACB00CF454400D5171000E03A1F00E96A3700EF8A4700F09B
      5000F19E5200EF8E4B00EC723D00E4452700D9221700D34F4C00D5CBCD00D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D4CACB00CF454400D5171000E03A1F00E96A3700EF8A4700F09B
      5000F19E5200EF8E4B00EC723D00E4452700D9221700D34F4C00D5CBCD00D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D4CACB00CF454400D5171000E03A1F00E96A3700EF8A4700F09B
      5000F19E5200EF8E4B00EC723D00E4452700D9221700D34F4C00D5CBCD00D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00000000000000
      0000D08C8F00D0151100E23B2000ED7F4100F4AE5900F6C86700F8D47000F9DD
      7500F8DA7400F8D47200F6CB6C00F5B36100EE8D4C00E6502E00D6231B00D291
      93000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D08C8F00D0151100E23B2000ED7F4100F4AE5900F6C86700F8D47000F9DD
      7500F8DA7400F8D47200F6CB6C00F5B36100EE8D4C00E6502E00D6231B00D291
      93000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D08C8F00D0151100E23B2000ED7F4100F4AE5900F6C86700F8D47000F9DD
      7500F8DA7400F8D47200F6CB6C00F5B36100EE8D4C00E6502E00D6231B00D291
      93000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D08C8F00D0151100E23B2000ED7F4100F4AE5900F6C86700F8D47000F9DD
      7500F8DA7400F8D47200F6CB6C00F5B36100EE8D4C00E6502E00D6231B00D291
      93000000000000000000D7E8EB000000000000000000D7E8EB00D8E9EB00CE6D
      6F00D6130C00E6562D00F29F5100F4B66000F6C26900F7D07400FADE7C00FAE8
      8300FAE68200FADC7E00F9D17800F7C57000F4BA6900F3A95D00EB6F3E00DE26
      1800D275760000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB00CE6D
      6F00D6130C00E6562D00F29F5100F4B66000F6C26900F7D07400FADE7C00FAE8
      8300FAE68200FADC7E00F9D17800F7C57000F4BA6900F3A95D00EB6F3E00DE26
      1800D275760000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB00CE6D
      6F00D6130C00E6562D00F29F5100F4B66000F6C26900F7D07400FADE7C00FAE8
      8300FAE68200FADC7E00F9D17800F7C57000F4BA6900F3A95D00EB6F3E00DE26
      1800D275760000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB00CE6D
      6F00D6130C00E6562D00F29F5100F4B66000F6C26900F7D07400FADE7C00FAE8
      8300FAE68200FADC7E00F9D17800F7C57000F4BA6900F3A95D00EB6F3E00DE26
      1800D275760000000000D7E8EB00D8E9EB00D7E6E900D7E8EB00D08C8E00D611
      0B00E6572E00EF914C00F1A85A00F2B36300F6C26F00F9D27A00FAE08300FAE8
      8B00FCE98C00F9DE8600F9D58000F8C67700F5B86E00F3AE6500F19D5900EA72
      4000DC241700D2929400D7E8EB00D7E6E800D7E6E900D7E8EB00D08C8E00D611
      0B00E6572E00EF914C00F1A85A00F4B56400F6C26F00F9D27A00FAE08300FAE8
      8B00FCE98C00F9DE8600F9D58000F8C67700F4B86D00F3AE6500F19D5900EA72
      4000DC241700D2929400D7E8EB00D7E6E800D7E6E900D7E8EB00D08C8E00D611
      0B00E6572E00E48B4800A5744000A97E4800E8B76900F9D27A00FAE08300CEBC
      7200B4A36600B49F6000F1CE7C00F8C67700F5B86E00F3AE6500F19D5900EA72
      4000DC241700D2929400D7E8EB00D7E6E800D7E6E900D7E8EB00D08C8E00D611
      0B00E6572E00EF914C00F1A85A00F4B56400F6C26F00F0CB7600B19C5C00B2A2
      6500D0BE7300F9DE8600F9D58000ECBC7100B1875200AE7E4A00E7975500EA72
      4000DC241700D2929400D7E8EB00D7E6E80000000000D2C8CA00CF100D00E242
      2300ED824400F0955000F2A75E00F5B66A00F5C37500F8D18000FADD8A00FAE2
      8E00FBE38F00F9DE8E00F9D58700F7C97E00F6BD7500F4B06B00F29F5D00F092
      5400E85F3700D6211A00D3CACC000000000000000000D2C8CA00CF100D00E242
      2300ED824400F0955000F2A75E00F5B66A00F5C37500F8D18000FADD8A00FAE2
      8E00FBE38F00F9DE8E00F9D58700F7C97E00F6BD7500F4B06B00F29F5D00F092
      5400E85F3700D6211A00D3CACC000000000000000000D2C8CA00C9100D00982E
      1800C26B39009C613200D3C0A300CEC1AA009B835800C3A46500EFD38400C5B1
      8500F0E7D800D6CCB700A6916500C6A16500F6BD7500F4B06B00F29F5D00F092
      5400E85F3700D6211A00D3CACC000000000000000000D2C8CA00CF100D00E242
      2300ED824400F0955000F2A75E00F5B66A00BF995C009F8A5E00D3C9B400F0E7
      D800C6B28600EFD58800C8AB6C00A48C6200D5C9B300D9C8AE00A86E3E00CA7C
      4800A7472900D1211A00D3CACC000000000000000000CB3F4000D9211200EB71
      3A00EE874800EF955400F2A96200F6B76F00F6C37B00F8CF8400FADA8E00F9DC
      9200F9DD9500FADB9300F8D38D00F7C98300F7BF7B00F4B27000F2A16300F093
      5700EE844D00E23D2500D14F4D00D8E9EB0000000000CB3F4000D9211200EB71
      3A00EE874800EF955400F2A96200F6B76F00F5C27A00F8CF8400FADA8E00F9DC
      9200F9DD9500FADB9300F8D38D00F8CA8400F7BF7B00F4B27000F2A16300F093
      5700EE844D00E23D2500D14F4D00D8E9EB0000000000CB3F4000E2473600BFA4
      8C006C56420051382200D1C9BC00FFFFF600FEF6E800CBBEA3008F7D5300A093
      7C00F7F3EA00FFFFFA00FBF6EA00C6BAA100A8895D00C6915C00F2A16300F093
      5700EE844D00E23D2500D14F4D00D8E9EB0000000000CB3F4000D9211200EB71
      3A00EE874800EF955400BB844D009C7D5200BEB19700FBF5E700FFFFFA00F7F2
      E900A1957F0095825800D0C5AB00FEF7EA00FFFFF700D8D2C70061452B007D67
      5100C8B29B00E9654E00D14F4D00D8E9EB00D2BEC100CF090700E2432400EC77
      4000ED854A00F0945700F4A86600F5B67200F6C37C00F9CE8900FAD69100FADB
      9700F8D89500DFC08200F3CE8D00F8CB8A00F7BF7F00F5B47500F3A36700F192
      5900EE875100E85F3800D91B1400D4C1C300D2BEC100CF090700E2432400EC77
      4000ED854A00F0945700F4A86600F5B67200F6C37C00F1C88400DCBB7D00F7D7
      9400FBDC9800FAD99600FAD49200F8CB8A00F7BF7F00F5B47500F3A36700F192
      5900EE875100E85F3800D91B1400D4C1C300D2BEC100CF0C0A00F39D7E00FFFC
      E800F6F0DE00A8A09000827D7000A29C9000E7E2D800FFFFFB00F4EEE000B6AF
      A000A8A29600CFCAC000F9F6ED00FFFFFC00F6EFDF00BDAC8F00A1724600D581
      5000EE875100E85F3800D91B1400D4C1C300D2BEC100CF090700E2432400EC77
      4000CC74410091603700B29D7F00F3EAD700FFFFFB00F7F4EA00CAC4B900A5A0
      9400B7B1A300F5F0E400FFFFFC00EBE7DF00B0AA9E00928D8000B6AFA000F8F3
      E300FFFCEC00F5B19200D9201800D4C1C300CF727400D6140C00E6572E00EC75
      4000EE814B00F1945800F2A56700F5B47300F6C07E00F8CB8A00FAD49300FAD8
      9800EBCC9400D7CEBF00CFC0A700CCA16D00F8BF8300F5B27600F3A36900F092
      5C00EF845100EA6D4200DF2E1D00D37B7C00CF727400D6140C00E6572E00EC75
      4000EE814B00F1945800F2A56700F5B47300C1946000C6B59B00D1C7B800E9C9
      9100FADA9C00FAD99B00F9D49500F8CA8C00F8BF8300F5B27600F3A36900F092
      5C00EF845100EA6D4200DF2E1D00D37B7C00CF727400DC2C2000F8CFB300FDF4
      DF00FEF8E600FFFFF500ECE5D600B3AD9F00948D8000C1BBB000F5F1E900FEFE
      F800EBE7DD00BCB6AB00AFA99C00D9D4CB00FDF9F100FFFFF700E7DDCA00AC8B
      6B0099573200DD673E00DF2E1D00D37B7C00CF727400D6140C00D6512B008846
      24009C7A5800E1D4BE00FFFFF600FCF7EC00D0CABF00A39D9000B4AFA200E9E5
      DB00FEFEF900F7F4ED00CBC6BB00A39C8F00C1BCAF00EFEADD00FFFFF700FEF9
      EB00FEF6E400F9D8BF00E5493700D37B7C00CD2A2A00DB231300E55B3100EA6F
      3F00ED7F4A00E88B5500E79A6200ECA96E00F0B67900F3C38600F6CD9100FAD7
      9C00DAB47E00ECE7DE00FFFFF900E3DFD500C0A58700CC915F00F29F6800F190
      5D00ED805000EA6F4300E33F2700D53B3800CD2A2A00DB231300E55B3100EA6F
      3F00ED7F4A00F0905800BE805000AF927500D8D4C800FFFFF600E5E0D500D6B0
      7A00FBD9A000F8D59B00F6D09500F4C58B00F1B98000EDAB7200EB9B6600F190
      5D00ED805000EA6F4300E33F2700D53B3800CD2A2A00E85C4600FDE7CD00FFF3
      E000FEF4E300FFF6E600FEFDEE00FFFEF100EDE5DA00BBB3A500AEA79B00DED8
      CF00FEFDF700FFFDF700E8E2D900B2AA9D00B1A99D00E4DDD400FFFFF400FFFB
      EC00DBC9B20096644700B1331E00D53B3800CD2A2A00A21B0E0083503400D2BD
      A200FFFAE600FFFFF100DCD3C9009F988B00A1988B00DFD8CD00FFFCF400FEFD
      F600E1DBD300BAB3A700C9C2B400F2EDE400FFFEF500FEFDF200FFF8EB00FEF6
      E900FFF5E600FEEAD500EB795F00D53B3800CC100E00DD2B1800E7583000EA69
      3D00A8644500B6947F00CCAF9900D0B49D00D3BA9F00D7C0A400DEC8AE00E2CD
      B100DFCEB700F7F3EC00FFFFFA00FFFEF800FCF8EF00D3C9BB00B4856600CE79
      4E00ED7D4F00E96A4200E5462B00D5211D00CC100E00DD2B1800E7583000EA69
      3D00C3653D00A2725300C5BAA900FBF4E800FFFEF400FFFEF600F0EBE100D8C7
      B000E7D3B800E9D7BE00E4D0B700E1CBB300DDC6AF00D9C0AD00C5A79400B878
      5700ED7D4F00E96A4200E5462B00D5211D00CC110F00ED7D6300FDEBD600FEF3
      DE00FEF4E200FEF5E400FFF6E700FFF8EC00FFFCF200FFFCF300ECE5DD00C8BF
      B300EBE6DF00FFFEFB00FFFEF900FDF8F100D5CCC000B1A89B00EAE1D600FFF9
      EA00FFFBEC00FEEED900D2836700CF211D00C6100E00CA6A5100FDE9D100FFFB
      E800FFF7E500E2D8CB009E948700C6BBAF00FBF4E900FFFEF600FFFEF600E7E1
      D800CFC6BA00F5EFE800FFFDF900FFFDF600FFFAF100FFF9EE00FEF8EC00FEF7
      E800FFF6E400FEEFDD00F0957A00D5221E00CF060500DC2C1800E5532E00E161
      3800A37B6600F5ECDF00FFFCEF00FFF8ED00FFF8ED00FEF9F000FFFBF500FEFC
      F600FFFEFB00FFFFFC00FEFCF700FDFAF300FEFAF100FFFFF600F7EEE100B39A
      8A00C9674200E8653F00E4462B00D6141100CF060500DC2C1800E5532E00BD54
      3100A2867500F5EADA00FFFFF300FEF6EA00FCF7EB00FEF9F000FFFCF600FFFD
      F800FEFDFA00FFFEFB00FEFCF700FFFAF400FFFBF300FFFCF300F7F0E600B48E
      7B00E6744A00E8653F00E4462B00D6141100CF090700EF8C7100FDEDD600FFF2
      DC00FEF3E100FDF3E100FEF5E600FEF6EA00FEF6EA00FEFBF100FFFFFB00EBE4
      DE00DDD4C900FFFEFB00FEFCF600FEFCF600FFFCF500B7A89F00D4CAC000FEF5
      E600FEF3E300FFF8E800F8C1AA00D61C1700CF0B0900F4B19800FFF7E400FEF0
      DC00FEF2DE00C9BDB100A5968C00FFFAF000FEFBF200FEF9EF00FEFBF400D4CA
      BF00F1EBE600FFFFFE00FEFDF800FEFAF200FEFAF100FEF7EC00FDF5E800FEF6
      E800FFF5E300FEF0DD00F2A08600D6171400CD050500DA271600E44B2B00E15A
      3500A67B6700F7EDE000FFFBEE00FFF7EC00FFF7EC00FEF8EF00FFFBF400FDFB
      F500FFFDFA00FFFEFA00FEFBF500FDF9F000FEFCF300FFF9ED00E5DBCE00B288
      7200CD613F00E85F3B00E43F2800D5131000CD050500DA271600E44B2B00C34F
      2E00A0745E00DDD1C000FFF8E800FEFBED00FCF5E900FEF8EE00FFFCF500FFFC
      F700FEFDF800FFFEFA00FEFBF600FFFAF300FFFAF200FFFBF200F8F1E600B790
      7B00E56C4500E85F3B00E43F2800D5131000CD080600ED866C00FDEDD400FEEF
      DB00FFF0DE00FDF1E100FDF2E200FFF7EA00FEFDF200F5EDE300D6CBBF00C3B7
      AA00F3EFE800FFFFFC00FEFCF800EDE5DB00BDB1A400BCB1A500F2EADC00FEF9
      EA00FFFAE900E1CAB100BB5F4600CC120F00C2050400AC483000DABFA200FFF9
      E400FEF7E500EEE3D400AC9F9200AA9E8F00E4DACD00FEFAF100FFFFF700EFEA
      E100CBC0B200E3DBD000F9F5EE00FEFDF600FFFAF100FDF5E900FDF3E700FFF4
      E500FEF2E200FEF0DC00F29B8300D5161300CD100F00D91F1200E2432600E856
      3300A5594100B7907E00CBA79200CDAC9600D1B09900D5B69D00DBBEA600DDBF
      A600DBC6B000F5F0E800FFFEF800FFFDF400EEE7DB00C5A89300B7694700EA72
      4B00EB664200E6553500E2362300D51E1A00CD100F00D91F1200E2432600E856
      3300E35F3B00A7563800B6957F00E7DECE00FFFBEF00FFFEF400F1EAE000D8C1
      AC00E1C4AA00E4CAB200E0C4AD00DEC1AC00DABDA900D7B8A500C6A39100B66C
      5200EB664200E6553500E2362300D51E1A00CD100F00EB6D5800FDE8D000FDEE
      D900FFF1DE00FFF5E300FFFBEB00F9EFE300CDC1B300ACA19200C6BCB000F5F0
      E900FFFFF900F7F2EB00CFC5B700B4A99A00D2CABE00FBF5EA00FFFFF300F5E5
      CC00B990710094412500CB312000D51E1A00CD100F00BF1B100083301800AA7E
      5D00F3DEBF00FFFFEF00FAF1E300C4BAAD00A2978700C0B6A700F3EDE300FFFF
      F800F7F2EC00D1C8BC00BBB1A200DAD0C400FBF4EB00FFFCF100FFF8EA00FFF4
      E500FEF2E100FEECD800EE846E00D5201B00CC2A2B00D8140D00DF3A2100E44C
      2D00E7593600E2633F00E2724900E87F5500ED926600F1A47600F4B07F00F8B8
      8900E6A87D00F0EAE400FCF8F300D3C0AE00C17F5D00E07C5500EE774F00EC6A
      4600E95E3C00E64E3100DE281B00D3393800CC2A2B00D8140D00DF3A2100E44C
      2D00E7593600E9674100D96D4600B26F5000CBB5A300FBF5EE00ECE5DF00E4A6
      7B00F9BB8C00F7B78700F4AF7F00F09E7000ED8E6200E8815800E7734C00EC6A
      4600E95E3C00E64E3100DE281B00D3393800CC2A2B00E4453700FADAC200FFF3
      DB00FFFCE700FFF6E300C8BDAC00988C7C00B5AA9C00E8E2D900FFFEF900FCF9
      F200DCD4C800C7BDAF00D8D1C600F5F0E900FFFFF600FDF2E100CAAB8C00A35E
      3C00B74B3000E64E3100DE281B00D3393800CC2A2B00D8140D00DF3A2100A83A
      2300924B2D00BF9C7B00FDEEDA00FFFFF200F3EDE300D0C7BD00C0B6A700DAD1
      C500FDFAF300FFFFFA00EDE8E000C0B5A800A89C8C00D3C9BB00FFF8E800FFFD
      EC00FFF5E200FBE1CC00E85E4E00D3393800D0757600D1090600DB2D1A00E341
      2600E54C2F00E75A3800EE744C00F48C6100F59A6C00F7A37700F8AB7E00F8B0
      8200F1AD8400DDC2B400D7A98F00EE9B7100F5986B00EE7D5500EC6A4700EA5D
      3E00E7523500E3412A00D91B1400D47F8000D0757600D1090600DB2D1A00E341
      2600E54C2F00E75A3800EE744C00F48C6100E98E6400D19D8400D9BCAE00F1AC
      8200F9B28400F9B28500F8AE8000F7A67A00F5986B00EE7D5500EC6A4700EA5D
      3E00E7523500E3412A00D91B1400D47F8000D0757600D7191400F6BCA500FFF0
      DD00CABAA70077604D00978A7D00DED6CD00FBF5EE00FFFFFB00F7F0E500D0C6
      B500D7CFC600F6F1EC00FFFFFB00FFFBF200E8D6C100B5764E00BE563900EA5D
      3E00E7523500E3412A00D91B1400D47F8000D0757600D1090600DB2D1A00E341
      2600E54C2F00B1462C00AE6D4500E4D0B800FFFAF000FFFFFA00F4EFEA00D5CE
      C400D1C7B700F7F2E900FFFFFB00FBF7F100E1DCD4009F94870088725F00D3C5
      B500FFF3E300F8C7B300DE312900D47F8000D4C0C300CD060400D9180F00DE37
      2000E3412800EA5B3900F37A5200F4845C00F58F6400F7996C00F79D7100F7A3
      7800F8A67A00F7A17500F8A17600F79A6E00F7936900F4855D00EB604100E751
      3500E4472E00E02C1D00D7191700D6C4C600D4C0C300CD060400D9180F00DE37
      2000E3412800EA5B3900F37A5200F4845C00F58F6400F7996C00F69C7000F7A3
      7800F8A67A00F8A37700F8A17600F79A6E00F7936900F4855D00EB604100E751
      3500E4472E00E02C1D00D7191700D6C4C600D4C0C300CD070700D56153008868
      5A0067271A0074331F00F7F2EE00FFFFFD00FFFBF300E9D6C500B67A5500D5BD
      AC00FFFFFD00FFFFFC00F3ECE100D5A88800CF704D00F0825B00EB604100E751
      3500E4472E00E02C1D00D7191700D6C4C600D4C0C300CD060400D9180F00DE37
      2000E3412800EA5B3900EF775000C6614200CD9C7C00F1E8DC00FFFFFB00FFFF
      FD00D6BEAE00BB805B00EDDBCC00FFFBF600FFFFFD00F8F3EF007A3B25007935
      2300997A6C00DB776800D71B1A00D6C4C60000000000CE434400D1090600DD26
      1700E03B2300F1593A00F46E4900F4765000F5815B00F68A6200F78F6600F792
      6A00F7956B00F7946A00F7916700F78C6400F5835D00F57E5900F0634500E545
      2D00E1372400D91F1900D86363000000000000000000CE434400D1090600DD26
      1700E03B2300F1593A00F46E4900F4765000F5815B00F68A6200F78F6600F792
      6A00F7956B00F7946A00F7916700F78C6400F5835D00F57E5900F0634500E545
      2D00E1372400D91F1900D86363000000000000000000CE434400AB0A07008F1A
      1000D8382200BE4C3000EDDCD000ECDED100C7907600D26A4B00F0896100D795
      7900EBDDD200DBB7A500CF795400EF855F00F5835D00F57E5900F0634500E545
      2D00E1372400D91F1900D86363000000000000000000CE434400D1090600DD26
      1700E03B2300F1593A00F46E4900F4765000ED795500CB714F00D8B3A000EBDC
      D000D8987C00F18E6500D6724F00CF9B8200EFE3D900F1E3D800C1573B00DD42
      2B009B281A00BA211A00D86363000000000000000000D5CBCD00CE0B0B00D40F
      0A00E12D1D00F24F3100F35A3B00F2644200F46F4B00F6795400F67D5800F681
      5C00F6845E00F6835C00F6815A00F67A5700F6714F00F56C4C00F2593D00DF34
      2200DB1C1400DB383800D7CED000D8E9EB0000000000D5CBCD00CE0B0B00D40F
      0A00E12D1D00F24F3100F45B3C00F4664400F46F4B00F6795400F67D5800F681
      5C00F6845E00F6835C00F6815A00F67A5700F4704E00F56B4A00F2593D00DF34
      2200DB1C1400DB383800D7CED000D8E9EB0000000000D5CBCD00CE0B0B00D40F
      0A00E12D1D00EB492F00C7432D00C84D3300EE694800F6795400F67D5800F07A
      5700E1704E00EC795400F6815A00F67A5700F6714F00F56C4C00F2593D00DF34
      2200DB1C1400DB383800D7CED000D8E9EB0000000000D5CBCD00CE0B0B00D40F
      0A00E12D1D00F24F3100F45B3C00F4664400F46F4B00F6795400EB745100DF6F
      4D00F07C5800F6835C00F6815A00F0745300D0573D00D0533800EA553800DF34
      2200DB1C1400DB383800D7CED000D8E9EB00D7E6E900D7E8EB00D4939400CF04
      0300DA130C00F1392400F34C3100F2523700F55E3E00F7674700F66C4B00F770
      4F00F7715000F7704F00F76D4B00F6694900F65F4400F65D4000ED452D00D91C
      1400DE2C2A00DBA5A600D7E8EB00D7E6E800D7E6E900D7E8EB00D4939400CF04
      0300DA130C00F1392400F54D3200F4543700F55F3F00F7674700F66C4B00F770
      4F00F7715000F7704F00F76D4B00F6674700F35D4200F45C3F00ED452D00D91C
      1400DE2C2A00DBA5A600D7E8EB00D7E6E800D7E6E900D7E8EB00D4939400CF04
      0300DA130C00F1392400F54D3200F4543700F55F3F00F7674700F66C4B00F770
      4F00F7715000F7704F00F76D4B00F6694900F65F4400F65D4000ED452D00D91C
      1400DE2C2A00DBA5A600D7E8EB00D7E6E800D7E6E900D7E8EB00D4939400CF04
      0300DA130C00F1392400F54D3200F4543700F55F3F00F7674700F66C4B00F770
      4F00F7715000F7704F00F76D4B00F6694900F65F4400F65D4000ED452D00D91C
      1400DE2C2A00DBA5A600D7E8EB00D7E6E80000000000D7E8EB0000000000D275
      7700CF060500E4120D00F7352300F6452E00F64E3300F6553A00F7593B00F75F
      4000F75F4000F75D4000F75C4000F7553A00F8533900F5432F00DF1B1400DD2B
      2900DB91920000000000D7E8EB000000000000000000D7E8EB0000000000D275
      7700CF060500E4120D00F7352300F6452E00F64E3300F6553A00F7593B00F75F
      4000F75F4000F75D4000F75C4000F7553A00F8533900F5432F00DF1B1400DD2B
      2900DB91920000000000D7E8EB000000000000000000D7E8EB0000000000D275
      7700CF060500E4120D00F7352300F6452E00F64E3300F6553A00F7593B00F75F
      4000F75F4000F75D4000F75C4000F7553A00F8533900F5432F00DF1B1400DD2B
      2900DB91920000000000D7E8EB000000000000000000D7E8EB0000000000D275
      7700CF060500E4120D00F7352300F6452E00F64E3300F6553A00F7593B00F75F
      4000F75F4000F75D4000F75C4000F7553A00F8533900F5432F00DF1B1400DD2B
      2900DB91920000000000D7E8EB000000000000000000D7E8EB00D8E9EB000000
      0000D69A9C00D31D1D00E5171400F41D1500F8342300F93E2900F8422C00F845
      2F00F9483100F8462F00F9433000F93C2B00F2251B00E0211D00DD3B3B00DAA5
      A700D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D69A9C00D31D1D00E5171400F41D1500F8342300F93E2900F8422C00F845
      2F00F9483100F8462F00F9433000F93C2B00F2251B00E0211D00DD3B3B00DAA5
      A700D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D69A9C00D31D1D00E5171400F41D1500F8342300F93E2900F8422C00F845
      2F00F9483100F8462F00F9433000F93C2B00F2251B00E0211D00DD3B3B00DAA5
      A700D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D69A9C00D31D1D00E5171400F41D1500F8342300F93E2900F8422C00F845
      2F00F9483100F8462F00F9433000F93C2B00F2251B00E0211D00DD3B3B00DAA5
      A700D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D9D0D100DA646600DD242500E7232300EE171300F3191400F51F
      1600F5211700F21C1500EC1B1600E52A2700DB282800DD6F7000D8D0D200D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D9D0D100DA646600DD242500E7232300EE171300F3191400F51F
      1600F5211700F21C1500EC1B1600E52A2700DB282800DD6F7000D8D0D200D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D9D0D100DA646600DD242500E7232300EE171300F3191400F51F
      1600F5211700F21C1500EC1B1600E52A2700DB282800DD6F7000D8D0D200D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00D8E9EB000000
      0000D7E8EB00D9D0D100DA646600DD242500E7232300EE171300F3191400F51F
      1600F5211700F21C1500EC1B1600E52A2700DB282800DD6F7000D8D0D200D7E8
      EB00D8E9EB0000000000D7E8EB00D8E9EB0000000000D7E8EB00000000000000
      0000D6E5E8000000000000000000D9C7C900D98D8F00DB535400DF3B3B00DF27
      2800DF272800DE3C3C00DB535400DA909100D9C6C9000000000000000000D6E5
      E8000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D6E5E8000000000000000000D9C7C900D98D8F00DB535400DF3B3B00DF27
      2800DF272800DE3C3C00DB535400DA909100D9C6C9000000000000000000D6E5
      E8000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D6E5E8000000000000000000D9C7C900D98D8F00DB535400DF3B3B00DF27
      2800DF272800DE3C3C00DB535400DA909100D9C6C9000000000000000000D6E5
      E8000000000000000000D7E8EB000000000000000000D7E8EB00000000000000
      0000D6E5E8000000000000000000D9C7C900D98D8F00DB535400DF3B3B00DF27
      2800DF272800DE3C3C00DB535400DA909100D9C6C9000000000000000000D6E5
      E8000000000000000000D7E8EB0000000000424D3E000000000000003E000000
      2800000060000000480000000100010000000000600300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
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
      0000000000000000000000000000000092002492002492002492002490000490
      0004900004900004B0000DB0000DB0000DB0000D800004800004800004800004
      0000000000000000000000008000018000018000018000018000008000008000
      0080000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000180
      0001800001800001800000800000800000800000000000000000000000000000
      A00005A00005A00005A000059000049000049000049000049000049000049000
      04900004B6006DB6006DB6006DB6006D00000000000000000000000000000000
      000000000000}
  end
end
