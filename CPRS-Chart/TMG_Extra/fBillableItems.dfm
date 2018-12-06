object frmBillableItems: TfrmBillableItems
  Left = 0
  Top = 0
  Caption = 'TMG BILLABLE ITEMS'
  ClientHeight = 561
  ClientWidth = 791
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    791
    561)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 72
    Height = 13
    Caption = 'Beginning Date'
  end
  object Label2: TLabel
    Left = 232
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Ending Date'
  end
  object btnGetReport: TButton
    Left = 424
    Top = 23
    Width = 105
    Height = 25
    Caption = '&Get Report'
    TabOrder = 0
    OnClick = btnGetReportClick
  end
  object dateBeginning: TDateTimePicker
    Left = 8
    Top = 27
    Width = 209
    Height = 21
    Date = 42103.996557256940000000
    Time = 42103.996557256940000000
    TabOrder = 1
  end
  object dateEnding: TDateTimePicker
    Left = 232
    Top = 27
    Width = 186
    Height = 21
    Date = 42103.997037037040000000
    Time = 42103.997037037040000000
    TabOrder = 2
  end
  object btnPrintCPTs: TButton
    Left = 17
    Top = 528
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Print CPTs'
    TabOrder = 3
    OnClick = btnPrintCPTsClick
  end
  object Button2: TButton
    Left = 708
    Top = 528
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 4
  end
  object radFilter: TRadioGroup
    Left = 289
    Top = 518
    Width = 377
    Height = 35
    Anchors = [akRight, akBottom]
    Caption = 'Filter'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'All'
      'Procedures'
      'CPT - II')
    TabOrder = 5
    OnClick = radFilterClick
  end
  object btnGetICDs: TButton
    Left = 541
    Top = 23
    Width = 105
    Height = 25
    Caption = 'Get ICDs'
    TabOrder = 6
    OnClick = btnGetICDsClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 64
    Width = 775
    Height = 448
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 7
    object Splitter1: TSplitter
      Left = 385
      Top = 1
      Height = 446
      ExplicitLeft = 398
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 384
      Height = 446
      Align = alLeft
      Caption = 'Panel2'
      TabOrder = 0
      object reBillableReport: TRichEdit
        Left = 1
        Top = 1
        Width = 382
        Height = 444
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnResizeRequest = reBillableReportResizeRequest
      end
    end
    object Panel3: TPanel
      Left = 388
      Top = 1
      Width = 386
      Height = 446
      Align = alClient
      Caption = 'Panel3'
      TabOrder = 1
      OnClick = Panel3Click
      object reICDs: TRichEdit
        Left = 1
        Top = 1
        Width = 384
        Height = 444
        Align = alClient
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnResizeRequest = reICDsResizeRequest
      end
    end
  end
  object btnPrintICDs: TButton
    Left = 113
    Top = 528
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Print &ICDs'
    TabOrder = 8
    OnClick = btnPrintICDsClick
  end
  object dlgPrintReport: TPrintDialog
    Left = 96
    Top = 440
  end
end
