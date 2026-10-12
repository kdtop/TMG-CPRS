object frmTopicTableEdit: TfrmTopicTableEdit
  BorderStyle = bsSizeable
  Caption = 'Edit Related Data Table'
  ClientHeight = 410
  ClientWidth = 620
  ActiveControl = memoTableData
  Constraints.MinHeight = 240
  Constraints.MinWidth = 360
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object memoTableData: TMemo
    Left = 0
    Top = 0
    Width = 620
    Height = 366
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = True
    WantTabs = True
    WordWrap = False
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 366
    Width = 620
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TBitBtn
      Left = 442
      Top = 9
      Width = 80
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      Kind = bkOK
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TBitBtn
      Left = 531
      Top = 9
      Width = 80
      Height = 27
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Kind = bkCancel
      ModalResult = 2
      TabOrder = 1
    end
  end
end
