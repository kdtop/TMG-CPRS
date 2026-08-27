object frmGMV_EditUserTemplates: TfrmGMV_EditUserTemplates
  Left = 270
  Top = 326
  Width = 810
  Height = 531
  HelpContext = 4
  Caption = 'Create/Edit user templates'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 6
    Width = 201
    Height = 456
    Caption = '&User Templates'
    TabOrder = 0
    DesignSize = (
      201
      456)
    object lbxTemplates: TListBox
      Left = 8
      Top = 16
      Width = 185
      Height = 429
      Anchors = [akLeft, akTop, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnClick = lbxTemplatesClick
      OnEnter = lbxTemplatesEnter
      OnExit = lbxTemplatesExit
    end
  end
  object Panel1: TPanel
    Left = 213
    Top = 11
    Width = 577
    Height = 451
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    inline fraGMV_EditTemplate1: TfraGMV_EditTemplate
      Left = 0
      Top = 0
      Width = 577
      Height = 451
      Align = alClient
      Enabled = False
      TabOrder = 0
      inherited Splitter1: TSplitter
        Width = 577
      end
      inherited pnlQualifiers: TPanel
        Width = 577
        Height = 247
        inherited pnlUsMetric: TPanel
          Width = 573
          inherited rgMetric: TRadioGroup
            Left = 418
          end
        end
      end
      inherited pnlVitals: TPanel
        Width = 577
        inherited pnlTop: TPanel
          Width = 575
          inherited pnlHeader: TPanel
            Width = 575
            Font.Height = -12
          end
          inherited pnlNameDescription: TPanel
            Width = 575
            inherited edtTemplateDescription: TEdit
              Width = 439
            end
          end
        end
        inherited pnlUpDownInsertDelete: TPanel
          Left = 542
        end
        inherited pnlListView: TPanel
          Width = 541
          inherited Panel1: TPanel
            Width = 539
            inherited Panel2: TPanel
              Width = 539
            end
            inherited Panel3: TPanel
              Width = 539
            end
            inherited lvVitals: TListView
              Left = 5
              Width = 524
            end
            inherited Panel4: TPanel
              Width = 5
            end
            inherited Panel5: TPanel
              Left = 529
              Width = 10
            end
          end
        end
      end
    end
  end
  object btnSaveTemplate: TButton
    Left = 535
    Top = 464
    Width = 80
    Height = 25
    Caption = '&Save'
    Enabled = False
    TabOrder = 3
    OnClick = btnSaveTemplateClick
  end
  object btnNewTemplate: TButton
    Left = 623
    Top = 465
    Width = 81
    Height = 25
    Caption = 'Ne&w Template'
    TabOrder = 4
    OnClick = btnNewTemplateClick
  end
  object btnClose: TButton
    Left = 709
    Top = 466
    Width = 82
    Height = 25
    Caption = '&Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object btnDelete: TButton
    Left = 451
    Top = 466
    Width = 75
    Height = 25
    Caption = '&Delete'
    TabOrder = 2
    OnClick = btnDeleteClick
  end
end
