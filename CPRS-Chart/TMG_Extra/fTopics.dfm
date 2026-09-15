inherited frmTopics: TfrmTopics
  Left = 0
  Top = 0
  Caption = 'Topics'
  ClientHeight = 624
  ClientWidth = 924
  Font.Name = 'Tahoma'
  OnClose = nil
  ExplicitWidth = 940
  ExplicitHeight = 663
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 619
    Width = 924
    ExplicitTop = 535
    ExplicitWidth = 713
  end
  object splTopicsLeft: TSplitter [1]
    Left = 240
    Top = 0
    Width = 5
    Height = 619
    Color = clMedGray
    MinSize = 32
    ParentColor = False
    ResizeStyle = rsUpdate
    OnMoved = splTopicsLeftMoved
    ExplicitHeight = 535
  end
  object splTopicsRight: TSplitter [2]
    Left = 679
    Top = 0
    Width = 5
    Height = 619
    Align = alRight
    Color = clMedGray
    MinSize = 120
    ParentColor = False
    ResizeStyle = rsUpdate
    ExplicitLeft = 468
    ExplicitHeight = 535
  end
  object pnlTopicsLeft: TPanel [3]
    Left = 0
    Top = 0
    Width = 240
    Height = 619
    Align = alLeft
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
    OnMouseEnter = pnlTopicsLeftMouseEnter
    OnMouseLeave = pnlTopicsLeftMouseLeave
    ExplicitLeft = -1
    ExplicitTop = 8
    object lvTopics: TCaptionListView
      Left = 0
      Top = 0
      Width = 240
      Height = 537
      Align = alTop
      Columns = <>
      TabOrder = 0
      AutoSize = False
      Caption = 'lvTopics'
    end
  end
  object pnlTopicsRight: TPanel [4]
    Left = 684
    Top = 0
    Width = 240
    Height = 619
    Align = alRight
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 473
    ExplicitHeight = 535
    object wbTopicData: TWebBrowser
      Left = 0
      Top = 0
      Width = 240
      Height = 537
      Align = alTop
      TabOrder = 0
      ControlData = {
        4C000000CE180000803700000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnlTopicsCenter: TPanel [5]
    Left = 245
    Top = 0
    Width = 434
    Height = 619
    Align = alClient
    BevelOuter = bvNone
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 2
    object wbDisplayPrior: TWebBrowser
      Left = 0
      Top = 0
      Width = 434
      Height = 337
      Align = alTop
      TabOrder = 0
      ControlData = {
        4C000000DB2C0000D42200000100000001020000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object wbEnterNew: TWebBrowser
      Left = 0
      Top = 408
      Width = 434
      Height = 211
      Align = alBottom
      TabOrder = 4
      ControlData = {
        4C000000DB2C0000CF1500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object btnTopicsLeftHandle: TBitBtn [6]
    Left = 228
    Top = 228
    Width = 30
    Height = 80
    TabOrder = 3
    Visible = False
    OnClick = btnTopicsLeftHandleClick
    OnMouseEnter = btnTopicsLeftHandleMouseEnter
    OnMouseLeave = btnTopicsLeftHandleMouseLeave
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = btnTopicsLeftHandle'
        'Status = stsDefault')
      (
        'Component = pnlTopicsLeft'
        'Status = stsDefault')
      (
        'Component = pnlTopicsCenter'
        'Status = stsDefault')
      (
        'Component = pnlTopicsRight'
        'Status = stsDefault')
      (
        'Component = frmTopics'
        'Status = stsDefault')
      (
        'Component = wbDisplayPrior'
        'Status = stsDefault')
      (
        'Component = wbEnterNew'
        'Status = stsDefault')
      (
        'Component = lvTopics'
        'Status = stsDefault')
      (
        'Component = wbTopicData'
        'Status = stsDefault'))
  end
  object timHideTopicsLeftHandle: TTimer
    Enabled = False
    OnTimer = timHideTopicsLeftHandleTimer
  end
  object timTopicsLeftCollapse: TTimer
    Enabled = False
    Interval = 125
    OnTimer = timTopicsLeftCollapseTimer
  end
end
