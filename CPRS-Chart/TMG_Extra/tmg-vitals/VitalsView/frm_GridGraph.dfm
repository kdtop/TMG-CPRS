object frm_GridGraph: Tfrm_GridGraph
  Left = 460
  Top = 228
  Width = 754
  Height = 677
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnResize = FrameResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 746
    Height = 650
    Align = alClient
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object pnlGridGraph: TPanel
      Left = 0
      Top = 50
      Width = 746
      Height = 600
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splGridGraph: TSplitter
        Left = 0
        Top = 329
        Width = 746
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        Color = clSilver
        ParentColor = False
      end
      object pnlGraph: TPanel
        Left = 0
        Top = 0
        Width = 746
        Height = 329
        Align = alClient
        BevelOuter = bvLowered
        Caption = 'pnlGraph'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object pnlDateRange: TPanel
          Left = 1
          Top = 1
          Width = 120
          Height = 327
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object pnlGraphOptions: TPanel
            Left = 0
            Top = 253
            Width = 120
            Height = 74
            Align = alBottom
            BevelOuter = bvNone
            PopupMenu = PopupMenu1
            TabOrder = 1
            object CheckBox1: TCheckBox
              Left = 8
              Top = 4
              Width = 97
              Height = 17
              Action = acValueCaptions
              PopupMenu = PopupMenu1
              TabOrder = 0
            end
            object CheckBox2: TCheckBox
              Left = 8
              Top = 36
              Width = 97
              Height = 17
              Action = ac3D
              PopupMenu = PopupMenu1
              TabOrder = 2
            end
            object CheckBox3: TCheckBox
              Left = 8
              Top = 20
              Width = 97
              Height = 17
              Action = acZoom
              Checked = True
              PopupMenu = PopupMenu1
              State = cbChecked
              TabOrder = 1
            end
            object cbChrono: TCheckBox
              Left = 8
              Top = 52
              Width = 97
              Height = 17
              Caption = 'Ti&me Scale'
              Checked = True
              State = cbChecked
              TabOrder = 3
              OnClick = cbChronoClick
            end
          end
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 120
            Height = 253
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object pnlPTop: TPanel
              Left = 0
              Top = 0
              Width = 120
              Height = 3
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
            end
            object pnlPRight: TPanel
              Left = 117
              Top = 3
              Width = 3
              Height = 247
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 1
            end
            object pnlPLeft: TPanel
              Left = 0
              Top = 3
              Width = 3
              Height = 247
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 2
            end
            object pnlPBot: TPanel
              Left = 0
              Top = 250
              Width = 120
              Height = 3
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 3
            end
            object pnlDateRangeTop: TPanel
              Left = 3
              Top = 3
              Width = 114
              Height = 247
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 4
              object lbDateRange: TListBox
                Left = 0
                Top = 25
                Width = 114
                Height = 222
                Align = alClient
                BevelInner = bvNone
                BevelOuter = bvNone
                BorderStyle = bsNone
                Color = clSilver
                ItemHeight = 13
                PopupMenu = PopupMenu1
                TabOrder = 0
                OnDblClick = cbxDateRangeClick
                OnEnter = lbDateRangeEnter
                OnExit = lbDateRangeExit
                OnKeyDown = lbDateRangeKeyDown
                OnMouseMove = lbDateRangeMouseMove
                OnMouseUp = lbDateRangeMouseUp
              end
              object Panel6: TPanel
                Left = 0
                Top = 0
                Width = 114
                Height = 25
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 1
                Visible = False
                object lblDateRange: TLabel
                  Left = 8
                  Top = 8
                  Width = 69
                  Height = 13
                  Caption = '&Date Range'
                  FocusControl = lbDateRange
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
              end
            end
          end
        end
        object pnlGraphBackground: TPanel
          Left = 121
          Top = 1
          Width = 624
          Height = 327
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Sorry, no graph available for this vital type.'
          TabOrder = 1
          object Bevel1: TBevel
            Left = 0
            Top = 0
            Width = 624
            Height = 327
            Align = alClient
          end
          object chrtVitals: TChart
            Left = 0
            Top = 0
            Width = 624
            Height = 327
            AnimatedZoomSteps = 10
            BackImageInside = True
            BackWall.Brush.Color = clWhite
            BottomWall.Size = 1
            Foot.Visible = False
            Gradient.EndColor = 15724527
            LeftWall.Brush.Color = clWhite
            MarginBottom = 0
            MarginLeft = 4
            MarginRight = 4
            MarginTop = 2
            PrintProportional = False
            Title.Alignment = taLeftJustify
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clBlack
            Title.Font.Height = -13
            Title.Font.Name = 'Microsoft Sans Serif'
            Title.Font.Style = []
            Title.Frame.Color = clWhite
            Title.Frame.Style = psClear
            Title.Text.Strings = (
              'PtName, Ward Loc')
            Title.Visible = False
            OnClickSeries = chrtVitalsClickSeries
            OnScroll = scbHGraphChange
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.DateTimeFormat = 'M/d/yy'
            BottomAxis.Grid.Color = 3947580
            BottomAxis.Grid.Style = psSolid
            BottomAxis.GridCentered = True
            BottomAxis.Increment = 1
            BottomAxis.LabelsMultiLine = True
            BottomAxis.LabelsOnAxis = False
            BottomAxis.LabelsSize = 38
            BottomAxis.Maximum = 9
            BottomAxis.MinorTickCount = 0
            BottomAxis.MinorTickLength = 0
            BottomAxis.RoundFirstLabel = False
            BottomAxis.TickLength = 0
            BottomAxis.TickOnLabelsOnly = False
            Chart3DPercent = 10
            DepthAxis.Grid.Style = psSolid
            LeftAxis.ExactDateTime = False
            LeftAxis.Increment = 1
            LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
            LeftAxis.LabelsFont.Color = clBlack
            LeftAxis.LabelsFont.Height = -9
            LeftAxis.LabelsFont.Name = 'Arial'
            LeftAxis.LabelsFont.Style = []
            Legend.Alignment = laTop
            Legend.ColorWidth = 35
            Legend.Font.Charset = ANSI_CHARSET
            Legend.Font.Color = clBlack
            Legend.Font.Height = -11
            Legend.Font.Name = 'Times New Roman'
            Legend.Font.Style = []
            Legend.HorizMargin = 5
            Legend.LegendStyle = lsSeries
            Legend.ShadowSize = 1
            Legend.TopPos = 39
            Legend.VertMargin = 12
            MaxPointsPerPage = 10
            TopAxis.Visible = False
            View3D = False
            View3DOptions.Elevation = 334
            View3DOptions.HorizOffset = 5
            View3DOptions.Perspective = 0
            View3DOptions.Rotation = 360
            View3DOptions.VertOffset = 14
            OnAfterDraw = chrtVitalsAfterDraw
            OnBeforeDrawSeries = chrtVitalsBeforeDrawSeries
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 1
            Color = clWhite
            ParentShowHint = False
            PopupMenu = PopupMenu1
            ShowHint = True
            TabOrder = 0
            OnResize = chrtVitalsResize
            object Series1: TPointSeries
              Marks.Arrow.Color = 4194368
              Marks.ArrowLength = 2
              Marks.BackColor = 16777088
              Marks.Style = smsValue
              Marks.Visible = True
              SeriesColor = 10485760
              Pointer.HorizSize = 2
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psRectangle
              Pointer.VertSize = 2
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series2: TPointSeries
              HorizAxis = aBothHorizAxis
              Marks.Arrow.Color = 4194368
              Marks.ArrowLength = 2
              Marks.BackColor = 8454016
              Marks.Style = smsValue
              Marks.Visible = True
              SeriesColor = clGreen
              Pointer.HorizSize = 3
              Pointer.InflateMargins = True
              Pointer.Style = psCircle
              Pointer.VertSize = 3
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series3: TPointSeries
              Marks.ArrowLength = 8
              Marks.Style = smsValue
              Marks.Visible = True
              SeriesColor = 8421631
              Pointer.HorizSize = 2
              Pointer.InflateMargins = True
              Pointer.Style = psTriangle
              Pointer.VertSize = 2
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series4: TPointSeries
              Marks.ArrowLength = 8
              Marks.BackColor = 4227327
              Marks.Style = smsValue
              Marks.Visible = True
              SeriesColor = 4194368
              Pointer.InflateMargins = True
              Pointer.Style = psDownTriangle
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series5: TPointSeries
              Marks.ArrowLength = 8
              Marks.Visible = False
              SeriesColor = clRed
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series6: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clGreen
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series7: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clBlue
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series8: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clGray
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series9: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clFuchsia
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series10: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clTeal
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series11: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clNavy
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series12: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = clMaroon
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
            object Series13: TPointSeries
              Marks.ArrowLength = 0
              Marks.Visible = False
              SeriesColor = 8388672
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = True
              XValues.DateTime = False
              XValues.Name = 'X'
              XValues.Multiplier = 1
              XValues.Order = loAscending
              YValues.DateTime = False
              YValues.Name = 'Y'
              YValues.Multiplier = 1
              YValues.Order = loNone
            end
          end
        end
      end
      object pnlGrid: TPanel
        Left = 0
        Top = 334
        Width = 746
        Height = 266
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 1
        OnResize = pnlGridResize
        object grdVitals: TStringGrid
          Left = 4
          Top = 33
          Width = 602
          Height = 230
          Align = alClient
          BorderStyle = bsNone
          Color = clBtnFace
          ColCount = 2
          DefaultColWidth = 112
          DefaultRowHeight = 14
          DefaultDrawing = False
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          PopupMenu = PopupMenu1
          ScrollBars = ssVertical
          TabOrder = 1
          OnDrawCell = grdVitalsDrawCell
          OnEnter = grdVitalsEnter
          OnExit = grdVitalsExit
          OnMouseDown = grdVitalsSelectCell
          OnTopLeftChanged = grdVitalsTopLeftChanged
          RowHeights = (
            14
            14
            14
            15
            14
            14
            14
            14
            14
            14
            14
            14
            14
            14
            14)
        end
        object pnlGridTop: TPanel
          Left = 1
          Top = 1
          Width = 744
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          Color = clSilver
          TabOrder = 0
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 121
            Height = 29
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            DesignSize = (
              121
              29)
            object Label1: TLabel
              Left = 11
              Top = 6
              Width = 39
              Height = 13
              Alignment = taRightJustify
              Caption = '&Graph:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              Visible = False
              WordWrap = True
            end
            object cbxGraph: TComboBox
              Left = 4
              Top = 4
              Width = 109
              Height = 21
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              Color = clSilver
              DropDownCount = 12
              ItemHeight = 13
              TabOrder = 0
              OnChange = cbxGraphChange
            end
          end
          object Panel4: TPanel
            Left = 121
            Top = 0
            Width = 623
            Height = 29
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            DesignSize = (
              623
              29)
            object trbHGraph: TTrackBar
              Left = 22
              Top = -5
              Width = 603
              Height = 31
              Anchors = [akLeft, akRight, akBottom]
              BorderWidth = 2
              Ctl3D = True
              Orientation = trHorizontal
              ParentCtl3D = False
              Frequency = 1
              Position = 0
              SelEnd = 0
              SelStart = 0
              TabOrder = 0
              ThumbLength = 16
              TickMarks = tmTopLeft
              TickStyle = tsAuto
              OnChange = scbHGraphChange
            end
          end
        end
        object pnlGBot: TPanel
          Left = 1
          Top = 263
          Width = 744
          Height = 2
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
        end
        object pnlGTop: TPanel
          Left = 1
          Top = 30
          Width = 744
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
        end
        object pnlGLeft: TPanel
          Left = 1
          Top = 33
          Width = 3
          Height = 230
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 4
        end
        object pnlGRight: TPanel
          Left = 606
          Top = 33
          Width = 2
          Height = 230
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 5
        end
        object pnlDebug: TPanel
          Left = 608
          Top = 33
          Width = 137
          Height = 230
          Align = alRight
          BevelOuter = bvLowered
          TabOrder = 6
          Visible = False
          object lblPos: TLabel
            Left = 8
            Top = 16
            Width = 28
            Height = 13
            Caption = 'lblPos'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblMin: TLabel
            Left = 8
            Top = 80
            Width = 27
            Height = 13
            Caption = 'lblMin'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblMax: TLabel
            Left = 8
            Top = 96
            Width = 30
            Height = 13
            Caption = 'lblMax'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblDate: TLabel
            Left = 8
            Top = 32
            Width = 33
            Height = 13
            Caption = 'lblDate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblX: TLabel
            Left = 8
            Top = 56
            Width = 17
            Height = 13
            Caption = 'lblX'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object pnlTitle: TPanel
      Left = 0
      Top = 0
      Width = 746
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 1
      Visible = False
      object pnlPtInfo: TPanel
        Left = 0
        Top = 0
        Width = 233
        Height = 50
        Hint = 'Selected patient demographics.'
        Align = alLeft
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 0
        object lblPatientName: TLabel
          Left = 9
          Top = 6
          Width = 139
          Height = 16
          Caption = 'No Patient Selected'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblPatientInfo: TLabel
          Left = 9
          Top = 26
          Width = 60
          Height = 13
          Caption = '000-00-0000'
        end
        object SpeedButton8: TSpeedButton
          Left = 207
          Top = 9
          Width = 17
          Height = 17
          Flat = True
          Visible = False
          OnClick = sbStyleClick
        end
        object Bevel2: TBevel
          Left = 224
          Top = 0
          Width = 9
          Height = 50
          Align = alRight
          Shape = bsRightLine
        end
      end
      object Panel9: TPanel
        Left = 233
        Top = 0
        Width = 279
        Height = 50
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        OnResize = Panel9Resize
        DesignSize = (
          279
          50)
        object lblHospital: TLabel
          Left = 140
          Top = 6
          Width = 39
          Height = 16
          Caption = '             '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label6: TLabel
          Left = 7
          Top = 6
          Width = 126
          Height = 16
          Caption = 'Hospital Location:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Bevel3: TBevel
          Left = 270
          Top = 0
          Width = 9
          Height = 50
          Align = alRight
          Shape = bsRightLine
        end
        object pnlDateRangeInfo: TPanel
          Left = 0
          Top = 25
          Width = 285
          Height = 25
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label11: TLabel
            Left = 8
            Top = 4
            Width = 72
            Height = 16
            Caption = 'From - To:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblDateFromTitle: TLabel
            Left = 84
            Top = 4
            Width = 102
            Height = 16
            Caption = '                                  '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object pnlActions: TPanel
        Left = 512
        Top = 0
        Width = 234
        Height = 50
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sbEnterVitals: TSpeedButton
          Left = 88
          Top = 2
          Width = 78
          Height = 44
          Action = acEnterVitals
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
            000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
            00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
            F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
            0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
            FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
            FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
            0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
            00333377737FFFFF773333303300000003333337337777777333}
          Layout = blGlyphTop
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
        end
        object sbEnteredInError: TSpeedButton
          Left = 2
          Top = 2
          Width = 86
          Height = 44
          Action = acEnteredInError
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
            305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
            005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
            B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
            B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
            B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
            B0557777FF577777F7F500000E055550805577777F7555575755500000555555
            05555777775555557F5555000555555505555577755555557555}
          Layout = blGlyphTop
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
        end
        object sbtnAllergies: TSpeedButton
          Left = 166
          Top = 2
          Width = 63
          Height = 44
          Action = acPatientAllergies
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000C40E0000C40E00000001000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000A0A0A0A0A0A
            0F0F0F0F0F0A0A0A0A0A0A0A0A0A0F04040404040F0F0F0A0A0A0A0A0A040404
            0404040404040F0F0A0A0A0A04040404040404040404040F0F0A0A0404040404
            0F0F0F0F040404040F0A0A04040404040F0F0F0F0F0404040F0F040404040404
            0F0F0F0404040404040F040404040F0F0F0F0F0404040404040F04040404040F
            0F0F0F0404040404040F0404040404040F0F0F0F04040404040F040404040404
            0404040404040404040A0A0404040404040F0F04040404040F0A0A0404040404
            0F0F0F0F040404040A0A0A0A04040404040F0F040404040A0A0A0A0A0A040404
            0404040404040A0A0A0A0A0A0A0A0A04040404040A0A0A0A0A0A}
          Layout = blGlyphTop
          Spacing = 1
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 400
    Top = 8
    object acResizeGraph: TAction
      Caption = 'Resi&ze'
      Hint = 'Maximize/Restore graph.'
      ImageIndex = 4
      ShortCut = 116
      OnExecute = acResizeGraphExecute
    end
    object acPrintGraph: TAction
      Caption = '&Print Graph'
      Hint = 'Print graph to a windows printer.'
      ImageIndex = 3
      ShortCut = 120
      OnExecute = acPrintGraphExecute
    end
    object acValueCaptions: TAction
      Caption = '&Values'
      Hint = 'Show/Hide individual value tags.'
      ImageIndex = 0
      ShortCut = 119
      OnExecute = acValueCaptionsExecute
    end
    object acGraphButtons: TAction
      Caption = 'H/V Graph Buttons '
      ShortCut = 16450
    end
    object acEnterVitals: TAction
      Caption = '&Enter Vitals'
      OnExecute = acEnterVitalsExecute
    end
    object ac3D: TAction
      Caption = '&3D'
      OnExecute = ac3DExecute
    end
    object acOptions: TAction
      Caption = '&Options'
    end
    object acEnteredInError: TAction
      Caption = 'E&ntered in Error'
      OnExecute = acEnteredInErrorExecute
    end
    object acCustomRange: TAction
      Caption = '&Add Range'
      OnExecute = acCustomRangeExecute
    end
    object acZoom: TAction
      Caption = 'Allow &Zoom'
      OnExecute = acZoomExecute
    end
    object acGraphOptions: TAction
      Caption = 'Show/Hide Graph Options'
      OnExecute = acGraphOptionsExecute
    end
    object acEnteredInErrorByTime: TAction
      Caption = 'Mark as Entered In Error'
      OnExecute = acEnteredInErrorByTimeExecute
    end
    object acPatientAllergies: TAction
      Caption = 'Allergies'
      OnExecute = acPatientAllergiesExecute
    end
    object ColorSelect1: TColorSelect
      Category = 'Dialog'
      Caption = 'Select Graph &Color...'
      Dialog.Ctl3D = True
      Hint = 'Color Select'
      OnAccept = ColorSelect1Accept
    end
  end
  object ImageList1: TImageList
    Left = 432
    Top = 8
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000FFFF000000000000
      C003000000000000DFFB000000000000DFFB000000000000DFFB000000000000
      DFFB000000000000DFFB000000000000DFFB000000000000DFFB000000000000
      DFFB000000000000C003000000000000C003000000000000C003000000000000
      FFFF000000000000FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFC007
      FFFFFEFFFF7F8003FFFFFCFFFF3F0001FFFFF8FFFF1F0001C1FFF0FFFF0F0001
      C1FFE003C0070000C1FFC003C0030000C1FFE003C00780000001F0FFFF0FC000
      0001F8FFFF1FE0010001FCFFFF3FE0070001FEFFFF7FF0070001FFFFFFFFF003
      0001FFFFFFFFF8030001FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 472
    Top = 8
    object MarkasEnteredInError1: TMenuItem
      Action = acEnteredInError
    end
    object EnterVitals1: TMenuItem
      Action = acEnterVitals
    end
    object Allergies1: TMenuItem
      Action = acPatientAllergies
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowHideGraphOptions1: TMenuItem
      Action = acGraphOptions
    end
    object SelectGraphColor1: TMenuItem
      Action = ColorSelect1
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Print1: TMenuItem
      Action = acPrintGraph
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 544
    Top = 8
  end
end
