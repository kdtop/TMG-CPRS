object frmEndAnticoagationManagement: TfrmEndAnticoagationManagement
  Left = 0
  Top = 0
  Caption = 'End Anticoagulation Management'
  ClientHeight = 495
  ClientWidth = 679
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 679
    Height = 35
    Align = alBottom
    TabOrder = 0
  end
  object pnlHTMLObjHolder: TPanel
    Left = 0
    Top = 0
    Width = 679
    Height = 460
    Align = alClient
    BevelOuter = bvNone
    Caption = 'HTMl Editor will go here'
    Color = clActiveCaption
    TabOrder = 1
  end
end
