object frmGMV_UserSettings: TfrmGMV_UserSettings
  Left = 314
  Top = 284
  HelpContext = 5
  BorderStyle = bsDialog
  BorderWidth = 8
  Caption = 'frmGMV_UserSettings'
  ClientHeight = 305
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlControls: TPanel
    Left = 0
    Top = 264
    Width = 487
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      487
      41)
    object btnApply: TButton
      Left = 252
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Apply'
      Enabled = False
      TabOrder = 1
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 412
      Top = 16
      Width = 75
      Height = 25
      Hint = 'Restore Settings and Exit'
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object btnOK: TButton
      Left = 332
      Top = 16
      Width = 75
      Height = 25
      Hint = 'Save Settings and exit'
      Anchors = [akTop, akRight]
      Caption = '&OK'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnOKClick
    end
    object Button1: TButton
      Left = 0
      Top = 16
      Width = 81
      Height = 25
      Action = acRestoreDefaults
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object pgctrl: TPageControl
    Left = 0
    Top = 0
    Width = 487
    Height = 264
    ActivePage = tbshtValueDisplay
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    object tbshtValueDisplay: TTabSheet
      Caption = '&Values Display'
      object gbxNormal: TGroupBox
        Left = 0
        Top = 0
        Width = 479
        Height = 50
        Align = alTop
        Caption = 'Normal Values:'
        TabOrder = 0
        object tbarNormal: TToolBar
          Left = 2
          Top = 15
          Width = 475
          Height = 30
          ButtonWidth = 91
          Caption = 'tbarAbnormal'
          EdgeBorders = []
          EdgeInner = esNone
          EdgeOuter = esNone
          Images = frmGMV_SelectColor.ilColors
          List = True
          ShowCaptions = True
          TabOrder = 0
          object ToolButton3: TToolButton
            Left = 0
            Top = 2
            Width = 8
            Caption = 'ToolButton1'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbtnNormalText: TToolButton
            Left = 8
            Top = 2
            AllowAllUp = True
            Caption = '&Text'
            Grouped = True
            ImageIndex = 0
            OnClick = tbtnNormalTextClick
          end
          object ToolButton6: TToolButton
            Left = 99
            Top = 2
            Width = 8
            Caption = 'ToolButton2'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbtnNormalBackground: TToolButton
            Left = 107
            Top = 2
            AllowAllUp = True
            Caption = '&Background'
            Grouped = True
            ImageIndex = 15
            OnClick = tbtnNormalBackgroundClick
          end
          object ToolButton7: TToolButton
            Left = 198
            Top = 2
            Width = 8
            Caption = 'ToolButton7'
            ImageIndex = 17
            Style = tbsSeparator
          end
          object tbtnNormalTodayBackground: TToolButton
            Left = 206
            Top = 2
            Caption = 'Today'
            ImageIndex = 11
            Visible = False
            OnClick = tbtnNormalTodayBackgroundClick
          end
          object ToolButton4: TToolButton
            Left = 297
            Top = 2
            Width = 11
            Caption = 'ToolButton4'
            ImageIndex = 16
            Style = tbsSeparator
          end
          object ckbNormalBold: TCheckBox
            Left = 308
            Top = 2
            Width = 47
            Height = 22
            Alignment = taLeftJustify
            Caption = 'Bold:'
            TabOrder = 0
            OnClick = ckbNormalBoldClick
          end
          object ckbNormalQuals: TCheckBox
            Left = 355
            Top = 2
            Width = 97
            Height = 22
            Alignment = taLeftJustify
            Caption = 'Show Qualifiers:'
            TabOrder = 1
            OnClick = ckbNormalQualsClick
          end
        end
      end
      object gbxAbnormal: TGroupBox
        Left = 0
        Top = 50
        Width = 479
        Height = 50
        Align = alTop
        Caption = 'Abnormal Values:'
        TabOrder = 1
        object tbarAbnormal: TToolBar
          Left = 2
          Top = 15
          Width = 475
          Height = 30
          ButtonWidth = 91
          Caption = 'tbarAbnormal'
          EdgeBorders = []
          EdgeInner = esNone
          EdgeOuter = esNone
          Images = frmGMV_SelectColor.ilColors
          List = True
          ShowCaptions = True
          TabOrder = 0
          object ToolButton1: TToolButton
            Left = 0
            Top = 2
            Width = 8
            Caption = 'ToolButton1'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbtnAbnormalText: TToolButton
            Left = 8
            Top = 2
            AllowAllUp = True
            Caption = 'Te&xt'
            Grouped = True
            ImageIndex = 9
            OnClick = tbtnAbnormalTextClick
          end
          object ToolButton2: TToolButton
            Left = 99
            Top = 2
            Width = 8
            Caption = 'ToolButton2'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbtnAbnormalBackground: TToolButton
            Left = 107
            Top = 2
            AllowAllUp = True
            Caption = 'Back&ground'
            Grouped = True
            ImageIndex = 15
            OnClick = tbtnAbnormalBackgroundClick
          end
          object ToolButton9: TToolButton
            Left = 198
            Top = 2
            Width = 8
            Caption = 'ToolButton9'
            ImageIndex = 17
            Style = tbsSeparator
          end
          object tbtnAbNormalTodayBackground: TToolButton
            Left = 206
            Top = 2
            Caption = 'Today'
            ImageIndex = 11
            Visible = False
            OnClick = tbtnAbNormalTodayBackgroundClick
          end
          object ckbAbnormalBold: TCheckBox
            Left = 297
            Top = 2
            Width = 47
            Height = 22
            Alignment = taLeftJustify
            Caption = 'Bold:'
            TabOrder = 0
            OnClick = ckbAbnormalBoldClick
          end
          object ToolButton5: TToolButton
            Left = 344
            Top = 2
            Width = 11
            Caption = 'ToolButton5'
            ImageIndex = 16
            Style = tbsSeparator
          end
          object ckbAbnormalQuals: TCheckBox
            Left = 355
            Top = 2
            Width = 97
            Height = 22
            Alignment = taLeftJustify
            Caption = 'Show Qualifiers:'
            TabOrder = 1
            OnClick = ckbAbnormalQualsClick
          end
        end
      end
      object gbxSamples: TGroupBox
        Left = 0
        Top = 100
        Width = 479
        Height = 136
        Align = alClient
        Caption = 'Sample Display:'
        TabOrder = 2
        object Label1: TLabel
          Left = 360
          Top = 22
          Width = 52
          Height = 13
          Caption = 'Templates:'
        end
        object Label2: TLabel
          Left = 8
          Top = 22
          Width = 59
          Height = 13
          Caption = 'Grid Display:'
        end
        object edtNormal: TEdit
          Left = 360
          Top = 40
          Width = 82
          Height = 21
          TabStop = False
          ReadOnly = True
          TabOrder = 0
          Text = 'Normal'
        end
        object edtAbnormal: TEdit
          Left = 360
          Top = 67
          Width = 81
          Height = 21
          TabStop = False
          ReadOnly = True
          TabOrder = 1
          Text = 'Abnormal'
        end
        object grdSample: TStringGrid
          Left = 8
          Top = 40
          Width = 345
          Height = 81
          TabStop = False
          ColCount = 4
          DefaultColWidth = 70
          DefaultRowHeight = 14
          DefaultDrawing = False
          Enabled = False
          RowCount = 6
          GridLineWidth = 0
          Options = [goVertLine, goHorzLine, goRangeSelect]
          ScrollBars = ssNone
          TabOrder = 2
          OnDrawCell = grdSampleDrawCell
          RowHeights = (
            14
            14
            14
            14
            14
            14)
        end
      end
    end
    object tbsParameters: TTabSheet
      Caption = '&Search Delay'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 479
        Height = 236
        Align = alClient
        TabOrder = 0
        object lblSearchDelay: TLabel
          Left = 16
          Top = 24
          Width = 93
          Height = 13
          Caption = 'Search Delay (sec) '
        end
        object Label3: TLabel
          Left = 16
          Top = 56
          Width = 81
          Height = 13
          Caption = 'Default Template'
          Visible = False
        end
        object SpeedButton1: TSpeedButton
          Left = 280
          Top = 80
          Width = 161
          Height = 22
          Caption = 'Select Inquiry Header Color'
          Visible = False
          OnClick = SpeedButton1Click
        end
        object SpeedButton2: TSpeedButton
          Left = 280
          Top = 128
          Width = 161
          Height = 22
          Caption = 'Select Inquiry Text Bkgd'
          Visible = False
          OnClick = SpeedButton2Click
        end
        object Label4: TLabel
          Left = 280
          Top = 8
          Width = 66
          Height = 13
          Caption = 'Inquiry routine'
          Visible = False
        end
        object cbxSearchDelay: TComboBox
          Left = 128
          Top = 24
          Width = 145
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = '1.5'
          OnChange = cbxSearchDelayChange
          Items.Strings = (
            '0.5'
            '1.0'
            '1.5'
            '2.0'
            '2.5'
            '3.0'
            '5.0')
        end
        object cbxDefaultTemplate: TComboBox
          Left = 128
          Top = 48
          Width = 145
          Height = 21
          ItemHeight = 0
          TabOrder = 1
          Visible = False
        end
        object pnlInquiry: TPanel
          Left = 128
          Top = 80
          Width = 145
          Height = 41
          Caption = 'Patient Inquiry'
          TabOrder = 2
          Visible = False
        end
        object memInquiry: TMemo
          Left = 128
          Top = 128
          Width = 145
          Height = 81
          Lines.Strings = (
            'Patient Inquiry Text'
            '------------------------------'
            '1. Line number One'
            '2. Line number Two'
            '3. Line number Three'
            '4. Line number Four'
            '')
          TabOrder = 3
          Visible = False
        end
        object lbxInquiryName: TListBox
          Left = 280
          Top = 24
          Width = 169
          Height = 49
          ItemHeight = 13
          Items.Strings = (
            'ORWPT PTINQ'
            'GMV LATEST VM')
          TabOrder = 4
          Visible = False
          OnClick = lbxInquiryNameClick
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 328
    object acRestoreDefaults: TAction
      Caption = '&Defaults'
      OnExecute = acRestoreDefaultsExecute
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 360
  end
end
