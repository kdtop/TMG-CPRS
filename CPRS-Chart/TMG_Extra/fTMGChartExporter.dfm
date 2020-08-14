inherited frmTMGChartExporter: TfrmTMGChartExporter
  Left = 364
  Top = 191
  Caption = 'Export Chart'
  ClientHeight = 488
  ClientWidth = 1197
  Constraints.MinHeight = 210
  Constraints.MinWidth = 255
  WindowState = wsMaximized
  OnCreate = FormCreate
  ExplicitWidth = 1205
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 633
    Top = 0
    Height = 488
    ExplicitLeft = 736
    ExplicitTop = 160
    ExplicitHeight = 100
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 633
    Height = 488
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 485
    DesignSize = (
      633
      488)
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 631
      Height = 439
      ActivePage = tsLabs
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      ExplicitHeight = 433
      object tsCover: TTabSheet
        Caption = 'Cover Sheet'
        ImageIndex = 3
        ExplicitHeight = 405
        object Label3: TLabel
          Left = 46
          Top = 16
          Width = 13
          Height = 13
          Caption = 'To'
        end
        object Label4: TLabel
          Left = 276
          Top = 16
          Width = 17
          Height = 13
          Caption = 'Fax'
        end
        object Label5: TLabel
          Left = 41
          Top = 56
          Width = 18
          Height = 13
          Caption = 'RE:'
        end
        object Label6: TLabel
          Left = 7
          Top = 96
          Width = 52
          Height = 13
          Caption = 'Comments:'
        end
        object edtTo: TEdit
          Left = 65
          Top = 13
          Width = 160
          Height = 21
          TabOrder = 0
        end
        object edtToFax: TEdit
          Left = 305
          Top = 13
          Width = 160
          Height = 21
          TabOrder = 1
        end
        object edtRE: TEdit
          Left = 65
          Top = 53
          Width = 400
          Height = 21
          TabOrder = 2
        end
        object memComments: TMemo
          Left = 65
          Top = 93
          Width = 400
          Height = 124
          TabOrder = 3
        end
      end
      object Notes: TTabSheet
        Caption = 'Notes'
        ExplicitHeight = 405
        DesignSize = (
          623
          411)
        object lblListName: TLabel
          Left = 33
          Top = 80
          Width = 54
          Height = 13
          Caption = 'lblListName'
        end
        object Label1: TLabel
          Left = 432
          Top = 16
          Width = 48
          Height = 13
          Caption = 'Start Date'
        end
        object Label2: TLabel
          Left = 435
          Top = 40
          Width = 45
          Height = 13
          Caption = 'End Date'
        end
        object ckbxAll: TCheckBox
          Left = 17
          Top = 38
          Width = 97
          Height = 17
          Caption = 'Select All'
          TabOrder = 0
          OnClick = ckbxAllClick
        end
        object chkHighlightOnly: TCheckBox
          Left = 17
          Top = 15
          Width = 174
          Height = 17
          Caption = 'Show Highlighted Items Only'
          TabOrder = 1
          OnClick = chkHighlightOnlyClick
        end
        object dtNotesStart: TORDateBox
          Left = 486
          Top = 13
          Width = 121
          Height = 21
          Anchors = [akLeft]
          TabOrder = 2
          Text = 'NOW'
          OnChange = dtNotesStartChange
          DateOnly = False
          RequireTime = False
        end
        object dtNotesEnd: TORDateBox
          Left = 486
          Top = 41
          Width = 121
          Height = 21
          Anchors = [akLeft]
          TabOrder = 3
          Text = 'NOW'
          OnChange = dtNotesEndChange
          DateOnly = False
          RequireTime = False
          ExplicitTop = 40
        end
        object btnApply: TButton
          Left = 532
          Top = 78
          Width = 75
          Height = 21
          Anchors = [akLeft]
          Caption = '&Apply'
          TabOrder = 4
          OnClick = btnApplyClick
          ExplicitTop = 77
        end
        object cklbTitles: TCheckListBox
          Left = 0
          Top = 110
          Width = 623
          Height = 301
          Align = alBottom
          ItemHeight = 13
          TabOrder = 5
          OnClick = cklbTitlesClick
          ExplicitTop = 104
        end
      end
      object tsLabs: TTabSheet
        Caption = 'Labs'
        ImageIndex = 1
        ExplicitHeight = 405
        object Label7: TLabel
          Left = 432
          Top = 16
          Width = 48
          Height = 13
          Caption = 'Start Date'
        end
        object Label8: TLabel
          Left = 435
          Top = 40
          Width = 45
          Height = 13
          Caption = 'End Date'
        end
        object lstLabs: TCheckListBox
          Left = 0
          Top = 110
          Width = 623
          Height = 301
          Align = alBottom
          ItemHeight = 13
          TabOrder = 0
          OnClick = cklbTitlesClick
          ExplicitTop = 104
        end
        object dtLabsStartDt: TORDateBox
          Left = 486
          Top = 13
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'NOW'
          DateOnly = False
          RequireTime = False
        end
        object dtLabsEndDt: TORDateBox
          Left = 486
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'NOW'
          DateOnly = False
          RequireTime = False
        end
        object btnLoadLabs: TButton
          Left = 532
          Top = 77
          Width = 75
          Height = 21
          Caption = '&Apply'
          TabOrder = 3
          OnClick = btnLoadLabsClick
        end
      end
      object tsRadiology: TTabSheet
        Caption = 'Radiology'
        ImageIndex = 2
        ExplicitHeight = 405
        object Label9: TLabel
          Left = 432
          Top = 16
          Width = 48
          Height = 13
          Caption = 'Start Date'
        end
        object Label10: TLabel
          Left = 435
          Top = 40
          Width = 45
          Height = 13
          Caption = 'End Date'
        end
        object lstRad: TCheckListBox
          Left = 0
          Top = 110
          Width = 623
          Height = 301
          Align = alBottom
          ItemHeight = 13
          TabOrder = 0
          OnClick = cklbTitlesClick
          ExplicitTop = 104
        end
        object dtRadStartDt: TORDateBox
          Left = 486
          Top = 13
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'NOW'
          OnChange = dtNotesStartChange
          DateOnly = False
          RequireTime = False
        end
        object dtRadEndDt: TORDateBox
          Left = 486
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'NOW'
          OnChange = dtNotesEndChange
          DateOnly = False
          RequireTime = False
        end
        object btnLoadRad: TButton
          Left = 532
          Top = 77
          Width = 75
          Height = 21
          Caption = '&Apply'
          TabOrder = 3
          OnClick = btnLoadRadClick
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        ImageIndex = 4
        ExplicitHeight = 405
      end
    end
    object btnExport: TBitBtn
      Left = 514
      Top = 451
      Width = 113
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Export Selected'
      Enabled = False
      TabOrder = 1
      OnClick = btnExportClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF299D49FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF30A2502DCC622AA84EFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF32A4522ACC5F20D25F28
        D05F2DA14EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF35A55529D16120D25FFFFFFF1FD15E27BF594FB16BFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF38A65729D16520D25F2EDA6B29AB512E
        DA6B21D3602AAE53FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37A656
        2AD2651FD15E43E17B2FAD537BCA932CAB502EDA6B22D05F2BA24DFF00FFFF00
        FFFF00FFFF00FFFF00FF32A6562EDA6B21D15F7CF2A631B353FF00FFFF00FF38
        B25A2CAD502EDA6B21C4573FAD5EFF00FFFF00FFFF00FFFF00FFFF00FF32A656
        8EF8B633B658FF00FFFF00FFFF00FFFF00FFFF00FF2DAD511FCB5C2AB75538B2
        5AFF00FFFF00FFFF00FFFF00FFFF00FF32A656FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF2FB1541FC9572DAE51FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF32B35620C2
        5538B25AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FF34B75625B75238B25AFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF37B65B25AD4838B25AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38B75C2EB04FFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FF3EB961FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ExplicitTop = 448
    end
    object btnNext: TBitBtn
      Left = 119
      Top = 451
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Ne&xt'
      TabOrder = 2
      OnClick = btnCancelClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
        1111111111111111111111111111111111111111111F11111111111111011111
        11111111117FF1111111111111001111111111111177FF111111111111000111
        1111111111777FF11111111111000011111111FFFF7777FF1111100000000001
        111117777777777FF1111000000000001111177777777777FF11100000000000
        01111777777777777F1110000000000001111777777777777111100000000000
        1111177777777777111110000000000111111777777777711111111111000011
        1111111111777711111111111100011111111111117771111111111111001111
        1111111111771111111111111101111111111111117111111111}
      NumGlyphs = 2
      ExplicitTop = 448
    end
    object btnPrev: TBitBtn
      Left = 6
      Top = 451
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Pre&v'
      TabOrder = 3
      OnClick = btnCancelClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
        11111111111111111111111111111111111111111111F1111111111111101111
        111111111117F1111111111111001111111111111177F1111111111110001111
        111111111777F1111111111100001111111111117777FFFFFF11111000000000
        01111117777777777F1111000000000001111177777777777F11100000000000
        01111777777777777F1110000000000001111777777777777F11110000000000
        01111177777777777F1111100000000001111117777777777111111100001111
        111111117777F1111111111110001111111111111777F1111111111111001111
        111111111177F111111111111110111111111111111711111111}
      NumGlyphs = 2
      ExplicitTop = 448
    end
  end
  object Panel2: TPanel [2]
    Left = 636
    Top = 0
    Width = 557
    Height = 488
    Align = alLeft
    TabOrder = 1
    ExplicitHeight = 485
    DesignSize = (
      557
      488)
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 555
      Height = 436
      Anchors = [akLeft, akTop, akRight, akBottom]
      Align = alTop
      TabOrder = 0
      ExplicitHeight = 428
      ControlData = {
        4C0000005C390000102D00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object btnCancel: TBitBtn
      Left = 442
      Top = 451
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FF808080000000000000000000000000000000808080FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000800000FF00
        00FF0000FF0000FF0000FF000080000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF000000FF00FFFF00FFFF00FFFF00FF0000000000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF000000FF00FFFF00FF808080
        0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF000080808080FF00FF0000000000FF0000FF0000FFFFFFFFFFFFFF00
        00FF0000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FF000000FF00FF000000
        0000FF0000FF0000FF0000FFFFFFFFFFFFFF0000FFFFFFFFFFFFFF0000FF0000
        FF0000FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FF000000FF00FF000000
        0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000
        FF0000FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FFFFFFFFFF
        FFFF0000FFFFFFFFFFFFFF0000FF0000FF0000FF0000FF000000FF00FF808080
        0000800000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFF0000
        FF0000FF000080808080FF00FFFF00FF0000000000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF000000FF00FFFF00FFFF00FF
        FF00FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000800000FF00
        00FF0000FF0000FF0000FF000080000000FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF808080000000000000000000000000000000808080FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ExplicitTop = 448
    end
    object btnPrint: TBitBtn
      Left = 6
      Top = 451
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Print'
      TabOrder = 2
      OnClick = btnCancelClick
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        10000300000000020000130B0000130B0000000000000000000000F80000E007
        00001F0000001FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF8
        1FF81FF81FF81FF81FF800000000000000000000000000000000000000000000
        1FF81FF81FF81FF8000028422842284228422842284228422842284200002842
        00001FF81FF80000000000000000000000000000000000000000000000000000
        284200001FF80000284228422842284228422842E0FFE0FFE0FF284228420000
        000000001FF80000284228422842284228422842284228422842284228420000
        284200001FF80000000000000000000000000000000000000000000000000000
        2842284200000000284228422842284228422842284228422842284200002842
        0000284200001FF8000000000000000000000000000000000000000028420000
        2842000000001FF81FF80000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00002842
        0000284200001FF81FF81FF80000FFFF00000000000000000000FFFF00000000
        000000001FF81FF81FF81FF80000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
        1FF81FF81FF81FF81FF81FF81FF80000FFFF00000000000000000000FFFF0000
        1FF81FF81FF81FF81FF81FF81FF80000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        00001FF81FF81FF81FF81FF81FF81FF800000000000000000000000000000000
        00001FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF81FF8
        1FF81FF81FF8}
      ExplicitTop = 448
    end
    object btnSave: TBitBtn
      Left = 119
      Top = 451
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Sa&ve'
      TabOrder = 3
      OnClick = btnCancelClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500000000005
        555500B8B8B8B8B000000B0B8B8B8B8B0FF00FB0B8B8B8B8B0F00BF000000000
        00F00FB0F0F0FFFFFFF00BF0F0F0F00000F00FB0F0F0FFFFFFF050F0F0F0F000
        00F05700F0F0FFFFFFF05550F0F0F00F00005550F0F0FFFF0F055550F0F0FFFF
        00555550F0F0000005555550F000000555555550000005555555}
      ExplicitTop = 448
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 896
    Top = 24
    Data = (
      (
        'Component = frmTMGChartExporter'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = PageControl1'
        'Status = stsDefault')
      (
        'Component = Notes'
        'Status = stsDefault')
      (
        'Component = ckbxAll'
        'Status = stsDefault')
      (
        'Component = chkHighlightOnly'
        'Status = stsDefault')
      (
        'Component = dtNotesStart'
        'Status = stsDefault')
      (
        'Component = dtNotesEnd'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = cklbTitles'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = WebBrowser1'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnExport'
        'Status = stsDefault')
      (
        'Component = tsLabs'
        'Status = stsDefault')
      (
        'Component = tsRadiology'
        'Status = stsDefault')
      (
        'Component = tsCover'
        'Status = stsDefault')
      (
        'Component = lstLabs'
        'Status = stsDefault')
      (
        'Component = lstRad'
        'Status = stsDefault')
      (
        'Component = edtTo'
        'Status = stsDefault')
      (
        'Component = edtToFax'
        'Status = stsDefault')
      (
        'Component = edtRE'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = dtLabsStartDt'
        'Status = stsDefault')
      (
        'Component = dtLabsEndDt'
        'Status = stsDefault')
      (
        'Component = btnLoadLabs'
        'Status = stsDefault')
      (
        'Component = btnPrint'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = dtRadStartDt'
        'Status = stsDefault')
      (
        'Component = dtRadEndDt'
        'Status = stsDefault')
      (
        'Component = btnLoadRad'
        'Status = stsDefault')
      (
        'Component = btnNext'
        'Status = stsDefault')
      (
        'Component = btnPrev'
        'Status = stsDefault')
      (
        'Component = TabSheet1'
        'Status = stsDefault'))
  end
end
