object frmPtAuditDetail: TfrmPtAuditDetail
  Left = 0
  Top = 0
  Caption = 'Audit Item Detail'
  ClientHeight = 410
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    409
    410)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 326
    Top = 377
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
    ExplicitLeft = 341
    ExplicitTop = 354
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 371
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 1
    OnResize = Panel1Resize
    ExplicitWidth = 424
    ExplicitHeight = 348
  end
end
