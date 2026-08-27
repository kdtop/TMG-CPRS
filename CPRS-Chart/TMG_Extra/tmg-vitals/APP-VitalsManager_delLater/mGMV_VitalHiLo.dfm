object fraVitalHiLo: TfraVitalHiLo
  Left = 0
  Top = 0
  Width = 181
  Height = 226
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 181
    Height = 226
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object pnlValue: TPanel
      Left = 1
      Top = 186
      Width = 179
      Height = 39
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 0
      OnResize = pnlValueResize
      object edtValue: TEdit
        Left = 24
        Top = 8
        Width = 57
        Height = 21
        TabOrder = 0
        Text = 'edtValue'
        OnExit = edtValueExit
      end
    end
    object pnlSlider: TPanel
      Left = 1
      Top = 50
      Width = 179
      Height = 136
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      OnResize = pnlSliderResize
      object tkbar: TTrackBar
        Left = 41
        Top = 1
        Width = 38
        Height = 134
        Align = alLeft
        Orientation = trVertical
        Frequency = 4
        TabOrder = 0
        TabStop = False
        OnChange = tkbarChange
      end
      object pnlMinMax: TPanel
        Left = 79
        Top = 1
        Width = 99
        Height = 134
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 1
        object lblMax: TLabel
          Left = 5
          Top = 5
          Width = 89
          Height = 13
          Align = alTop
          Caption = 'lblMax'
        end
        object lblMin: TLabel
          Left = 5
          Top = 116
          Width = 89
          Height = 13
          Align = alBottom
          Caption = 'lblMin'
        end
      end
      object pnlSpacer: TPanel
        Left = 1
        Top = 1
        Width = 40
        Height = 134
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 179
      Height = 49
      Align = alTop
      BevelOuter = bvLowered
      BorderWidth = 4
      Color = clHighlight
      TabOrder = 2
      object lblName: TLabel
        Left = 5
        Top = 5
        Width = 169
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblName'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lblHiLo: TLabel
        Left = 5
        Top = 18
        Width = 169
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblHiLo'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lblRange: TLabel
        Left = 5
        Top = 31
        Width = 169
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblRange'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
    end
  end
end
