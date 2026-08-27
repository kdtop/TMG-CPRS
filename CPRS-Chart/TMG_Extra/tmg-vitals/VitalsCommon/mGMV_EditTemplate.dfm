object fraGMV_EditTemplate: TfraGMV_EditTemplate
  Left = 0
  Top = 0
  Width = 421
  Height = 354
  Enabled = False
  TabOrder = 0
  OnEnter = FrameEnter
  OnExit = FrameExit
  object Splitter1: TSplitter
    Left = 0
    Top = 200
    Width = 421
    Height = 4
    Cursor = crVSplit
    Align = alTop
  end
  object pnlQualifiers: TPanel
    Left = 0
    Top = 204
    Width = 421
    Height = 150
    Align = alClient
    BevelInner = bvLowered
    Constraints.MinHeight = 115
    TabOrder = 1
    OnResize = pnlQualifiersResize
    object pnlUsMetric: TPanel
      Left = 2
      Top = 2
      Width = 417
      Height = 34
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 0
      object lblQualifiers: TLabel
        Left = 6
        Top = 4
        Width = 46
        Height = 13
        Caption = 'Qualifiers:'
      end
      object rgMetric: TRadioGroup
        Left = 262
        Top = 0
        Width = 155
        Height = 34
        Align = alRight
        Columns = 2
        Items.Strings = (
          'US'
          '&Metric')
        TabOrder = 0
        OnClick = rgMetricClick
        OnEnter = rgMetricEnter
        OnExit = rgMetricExit
      end
    end
  end
  object pnlVitals: TPanel
    Left = 0
    Top = 0
    Width = 421
    Height = 200
    Align = alTop
    Caption = 'pnlVitals'
    Constraints.MinHeight = 200
    Constraints.MinWidth = 350
    TabOrder = 0
    object pnlTop: TPanel
      Left = 1
      Top = 1
      Width = 419
      Height = 76
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlHeader: TPanel
        Left = 0
        Top = 0
        Width = 419
        Height = 20
        Align = alTop
        BevelInner = bvLowered
        BevelOuter = bvNone
        Caption = 'Vitals Template Editor'
        Color = clActiveCaption
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clCaptionText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object pnlNameDescription: TPanel
        Left = 0
        Top = 20
        Width = 419
        Height = 56
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          419
          56)
        object Label2: TLabel
          Left = 132
          Top = 6
          Width = 56
          Height = 13
          Caption = 'D&escription:'
          FocusControl = edtTemplateDescription
        end
        object Label1: TLabel
          Left = 8
          Top = 6
          Width = 78
          Height = 13
          Caption = 'Template &Name:'
          FocusControl = edtTemplateName
        end
        object edtTemplateDescription: TEdit
          Left = 131
          Top = 23
          Width = 278
          Height = 21
          Hint = 'Enter 2..50 characters'
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 50
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnEnter = edtTemplateDescriptionEnter
          OnExit = edtTemplateDescriptionExit
          OnKeyDown = edtTemplateNameKeyDown
        end
        object edtTemplateName: TEdit
          Left = 6
          Top = 23
          Width = 121
          Height = 21
          Hint = 'Enter 2..30 characters'
          MaxLength = 30
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnEnter = edtTemplateNameEnter
          OnExit = edtTemplateNameExit
          OnKeyDown = edtTemplateNameKeyDown
        end
      end
    end
    object pnlUpDownInsertDelete: TPanel
      Left = 386
      Top = 77
      Width = 34
      Height = 122
      Align = alRight
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        34
        122)
      object sbtnMoveUp: TSpeedButton
        Left = 5
        Top = 12
        Width = 25
        Height = 25
        Action = acUp
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FF
          FFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFF000000000
          00FFFFFF000000000FFFFFFFF0000000FFFFFFFFFF00000FFFFFFFFFFFF000FF
          FFFFFFFFFFFF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
      end
      object sbtnMoveDown: TSpeedButton
        Left = 5
        Top = 36
        Width = 25
        Height = 25
        Hint = 'Move Line Down'
        Action = acDown
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF000FFFFFFFFFFFF00000F
          FFFFFFFFF0000000FFFFFFFF000000000FFFFFF00000000000FFFFFFFFF000FF
          FFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FF
          FFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
      end
      object sbtnAddVital: TSpeedButton
        Left = 5
        Top = 67
        Width = 25
        Height = 25
        Hint = 'Add Line'
        Action = acAdd
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFF000FF
          FFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFF00000000000FFFFF000000000
          00FFFFF00000000000FFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FF
          FFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
      end
      object sbtnDeleteVital: TSpeedButton
        Left = 5
        Top = 91
        Width = 25
        Height = 25
        Hint = 'Delete Line'
        Action = acDelete
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C40E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000FFFFF000000000
          00FFFFF00000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
      end
    end
    object pnlListView: TPanel
      Left = 1
      Top = 77
      Width = 385
      Height = 122
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'pnlListView'
      TabOrder = 2
      OnResize = pnlListViewResize
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 383
        Height = 120
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 0
        object Panel2: TPanel
          Left = 0
          Top = 115
          Width = 383
          Height = 5
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 383
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Label3: TLabel
            Left = 8
            Top = 4
            Width = 72
            Height = 13
            Caption = 'Template &Vitals'
            FocusControl = lvVitals
          end
        end
        object lvVitals: TListView
          Left = 9
          Top = 25
          Width = 365
          Height = 90
          Align = alClient
          Columns = <
            item
              Caption = 'Vital'
              Width = 150
            end
            item
              Caption = 'US/Metric'
            end
            item
              Caption = 'Qualifiers'
              Width = -2
              WidthType = (
                -2)
            end>
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnEnter = lvVitalsEnter
          OnExit = lvVitalsExit
          OnKeyDown = lvVitalsKeyDown
          OnSelectItem = lvVitalsSelectItem
        end
        object Panel4: TPanel
          Left = 0
          Top = 25
          Width = 9
          Height = 90
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 3
        end
        object Panel5: TPanel
          Left = 374
          Top = 25
          Width = 9
          Height = 90
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 4
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 257
    Top = 29
    object acUp: TAction
      Hint = 'Move Line Up'
      ShortCut = 16469
      OnExecute = acUpExecute
    end
    object acDown: TAction
      ShortCut = 16471
      OnExecute = acDownExecute
    end
    object acAdd: TAction
      ShortCut = 16449
      OnExecute = acAddExecute
    end
    object acDelete: TAction
      ShortCut = 16452
      OnExecute = acDeleteExecute
    end
  end
end
