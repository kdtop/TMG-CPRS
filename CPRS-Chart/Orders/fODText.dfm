inherited frmODText: TfrmODText
  Width = 408
  Height = 488
  Anchors = [akLeft, akTop, akBottom]
  Caption = 'Text Only Order'
  Constraints.MinHeight = 305
  Constraints.MinWidth = 320
  ExplicitWidth = 408
  ExplicitHeight = 488
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel [0]
    Left = 6
    Top = 4
    Width = 126
    Height = 13
    Caption = 'Enter the text of the order -'
  end
  object lblStart: TLabel [1]
    Left = 8
    Top = 148
    Width = 76
    Height = 13
    Caption = 'Start Date/Time'
  end
  object lblStop: TLabel [2]
    Left = 156
    Top = 148
    Width = 76
    Height = 13
    Caption = 'Stop Date/Time'
  end
  object lblOrderSig: TLabel [3]
    Left = 8
    Top = 183
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  inherited memOrder: TCaptionMemo
    Top = 199
    Width = 378
    Height = 203
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
    ExplicitTop = 199
    ExplicitWidth = 378
    ExplicitHeight = 203
  end
  object memText: TMemo [5]
    Left = 6
    Top = 18
    Width = 378
    Height = 124
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnChange = ControlChange
  end
  object txtStart: TORDateBox [6]
    Left = 8
    Top = 162
    Width = 140
    Height = 21
    TabOrder = 2
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Start Date/Time'
  end
  object txtStop: TORDateBox [7]
    Left = 156
    Top = 162
    Width = 140
    Height = 21
    TabOrder = 3
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Stop Date/Time'
  end
  inherited cmdAccept: TButton
    Left = 312
    Top = 408
    Anchors = [akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 312
    ExplicitTop = 408
  end
  inherited cmdQuit: TButton
    Left = 267
    Top = 408
    Anchors = [akRight, akBottom]
    TabOrder = 6
    ExplicitLeft = 267
    ExplicitTop = 408
  end
  inherited pnlMessage: TPanel
    Left = 15
    Top = 10
    Width = 359
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitLeft = 15
    ExplicitTop = 10
    ExplicitWidth = 359
    inherited imgMessage: TImage
      Left = 3
      Top = 3
      ExplicitLeft = 3
      ExplicitTop = 3
    end
    inherited memMessage: TRichEdit
      Width = 306
      Anchors = [akLeft, akTop, akRight]
      ExplicitWidth = 306
    end
  end
  inherited chkCopyWhenAccepted: TCheckBox
    Top = 408
    TabOrder = 10
    ExplicitTop = 408
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = txtStart'
        'Status = stsDefault')
      (
        'Component = txtStop'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Label = lblOrderSig'
        'Status = stsOK')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODText'
        'Status = stsDefault')
      (
        'Component = chkCopyWhenAccepted'
        'Status = stsDefault'))
  end
  object VA508CompMemOrder: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompMemOrderStateQuery
    Left = 8
    Top = 64
  end
end
