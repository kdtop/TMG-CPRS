object frmPtAuditLog: TfrmPtAuditLog
  Left = 0
  Top = 0
  Caption = 'View Audit Log For'
  ClientHeight = 415
  ClientWidth = 535
  Color = clBtnFace
  Constraints.MinWidth = 540
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    535
    415)
  PixelsPerInch = 96
  TextHeight = 13
  object lblStartDT: TLabel
    Left = 8
    Top = 24
    Width = 82
    Height = 13
    Caption = 'Start Date / Time'
  end
  object Label1: TLabel
    Left = 280
    Top = 24
    Width = 76
    Height = 13
    Caption = 'End Date / Time'
  end
  object dbStartDate: TORDateBox
    Left = 104
    Top = 21
    Width = 161
    Height = 21
    TabOrder = 0
    OnChange = dbStartDateChange
    DateOnly = False
    RequireTime = False
  end
  object dbEndDate: TORDateBox
    Left = 368
    Top = 21
    Width = 161
    Height = 21
    TabOrder = 1
    Text = 'NOW'
    OnChange = dbEndDateChange
    DateOnly = False
    RequireTime = False
  end
  object btnDone: TBitBtn
    Left = 447
    Top = 382
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Done'
    ModalResult = 1
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 8
    Top = 48
    Width = 523
    Height = 328
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 3
    OnResize = Panel1Resize
  end
  object btnGetDetails: TBitBtn
    Left = 4
    Top = 382
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Get &Details'
    TabOrder = 4
    OnClick = btnGetDetailsClick
  end
  object btnPrint: TBitBtn
    Left = 92
    Top = 382
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = '&Print'
    TabOrder = 5
    OnClick = btnPrintClick
  end
end
