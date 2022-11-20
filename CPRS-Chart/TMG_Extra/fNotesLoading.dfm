object frmNotesLoading: TfrmNotesLoading
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmNotesLoading'
  ClientHeight = 90
  ClientWidth = 222
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 203
    Height = 33
    Caption = 'LOADING NOTES'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 4
    Height = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 65
    Width = 203
    Height = 17
    Smooth = True
    Step = 1
    TabOrder = 0
  end
end
