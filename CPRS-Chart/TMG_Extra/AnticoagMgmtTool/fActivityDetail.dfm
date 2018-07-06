object frmActivityDetail: TfrmActivityDetail
  Left = 0
  Top = 0
  Caption = 'Activity Detail'
  ClientHeight = 269
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTWeek: TPanel
    Left = 0
    Top = 0
    Width = 332
    Height = 269
    Align = alClient
    Constraints.MinHeight = 260
    Constraints.MinWidth = 260
    TabOrder = 0
    DesignSize = (
      332
      269)
    object memMemo: TMemo
      Left = 8
      Top = 48
      Width = 324
      Height = 181
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitWidth = 252
      ExplicitHeight = 183
    end
    object lblLine1: TStaticText
      Left = 8
      Top = 8
      Width = 33
      Height = 17
      Caption = 'Line 1'
      Constraints.MaxHeight = 34
      Constraints.MaxWidth = 336
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Transparent = False
    end
    object btnClose: TBitBtn
      Left = 219
      Top = 235
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      TabOrder = 2
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
      ExplicitLeft = 147
      ExplicitTop = 237
    end
    object lblLine2: TStaticText
      Left = 8
      Top = 25
      Width = 33
      Height = 17
      Caption = 'Line 2'
      Constraints.MaxHeight = 34
      Constraints.MaxWidth = 336
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Transparent = False
    end
  end
end
