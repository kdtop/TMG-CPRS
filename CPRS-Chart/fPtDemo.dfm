inherited frmPtDemo: TfrmPtDemo
  Left = 248
  Top = 283
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Inquiry'
  ClientHeight = 271
  ClientWidth = 580
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 588
  ExplicitHeight = 305
  PixelsPerInch = 96
  TextHeight = 13
  object lblFontTest: TLabel [0]
    Left = 264
    Top = 148
    Width = 77
    Height = 14
    Caption = 'lblFontTest'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object pnlHTMLView: TPanel [1]
    Left = 0
    Top = 0
    Width = 580
    Height = 234
    Align = alClient
    TabOrder = 2
  end
  object memPtDemo: TRichEdit [2]
    Left = 0
    Top = 0
    Width = 580
    Height = 234
    Align = alClient
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123ABCDEFGHIJKLMNOPQRSTUVWXYZ0123abcd' +
        'efghijklmnopqrs')
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object pnlTop: TORAutoPanel [3]
    Left = 0
    Top = 234
    Width = 580
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cmdNewPt: TButton
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      Caption = 'Select New Patient'
      TabOrder = 0
      OnClick = cmdNewPtClick
    end
    object EditaPtButton: TButton
      Left = 144
      Top = 8
      Width = 145
      Height = 21
      BiDiMode = bdRightToLeftNoAlign
      Caption = '&Edit Patient Demographics'
      ParentBiDiMode = False
      TabOrder = 3
      WordWrap = True
      OnClick = EditaPtButtonClick
    end
    object cmdClose: TButton
      Left = 501
      Top = 8
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 2
      OnClick = cmdCloseClick
    end
    object cmdPrint: TButton
      Left = 411
      Top = 8
      Width = 75
      Height = 21
      Caption = 'Print'
      TabOrder = 1
      OnClick = cmdPrintClick
    end
    object btnShowDueInfo: TKeyClickPanel
      Left = 295
      Top = 8
      Width = 26
      Height = 21
      Hint = 'Show Appt Due Info'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnShowDueInfoClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memPtDemo'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = cmdNewPt'
        'Status = stsDefault')
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = cmdPrint'
        'Status = stsDefault')
      (
        'Component = frmPtDemo'
        'Status = stsDefault')
      (
        'Component = btnShowDueInfo'
        'Status = stsDefault')
      (
        'Component = pnlHTMLView'
        'Status = stsDefault'))
  end
  object dlgPrintReport: TPrintDialog
    Left = 369
    Top = 237
  end
end
