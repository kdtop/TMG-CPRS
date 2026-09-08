object frmPatientVitals: TfrmPatientVitals
  Left = 286
  Top = 153
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Patient Vitals'
  ClientHeight = 582
  ClientWidth = 698
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'Vitals.hlp'
  KeyPreview = True
  Menu = MainMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  TextHeight = 13
  inline TfraGMV_GridGraph1: TfraGMV_GridGraph
    Left = 0
    Top = 0
    Width = 698
    Height = 582
    Align = alClient
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    Visible = False
    ExplicitWidth = 698
    ExplicitHeight = 582
    inherited pnlMain: TPanel
      Width = 698
      Height = 582
      ExplicitWidth = 698
      ExplicitHeight = 582
      inherited pnlGridGraph: TPanel
        Top = 88
        Width = 698
        Height = 494
        ExplicitTop = 88
        ExplicitWidth = 698
        ExplicitHeight = 494
        inherited splGridGraph: TSplitter
          Top = 323
          Width = 698
          Height = 4
          ExplicitTop = 328
          ExplicitWidth = 706
          ExplicitHeight = 4
        end
        inherited pnlGraph: TPanel
          Width = 698
          Height = 323
          ExplicitWidth = 698
          ExplicitHeight = 323
          inherited pnlDateRange: TPanel
            Width = 119
            Height = 321
            ExplicitWidth = 119
            ExplicitHeight = 321
            inherited pnlGraphOptions: TPanel
              Top = 221
              Width = 119
              ExplicitTop = 226
              ExplicitWidth = 119
              inherited pnlZoom: TPanel
                Width = 119
                ExplicitWidth = 119
              end
            end
            inherited Panel5: TPanel
              Width = 119
              Height = 221
              ExplicitWidth = 119
              ExplicitHeight = 221
              inherited pnlPTop: TPanel
                Width = 119
                ExplicitWidth = 119
              end
              inherited pnlPRight: TPanel
                Left = 116
                Height = 215
                ExplicitLeft = 116
                ExplicitHeight = 220
              end
              inherited pnlPLeft: TPanel
                Height = 215
                ExplicitHeight = 220
              end
              inherited pnlPBot: TPanel
                Top = 218
                Width = 119
                ExplicitTop = 223
                ExplicitWidth = 119
              end
              inherited pnlDateRangeTop: TPanel
                Width = 113
                Height = 215
                ExplicitWidth = 113
                ExplicitHeight = 215
                inherited lbDateRange: TListBox
                  Width = 113
                  Height = 190
                  ItemHeight = 13
                  ExplicitWidth = 113
                  ExplicitHeight = 190
                end
                inherited Panel6: TPanel
                  Width = 113
                  ExplicitWidth = 113
                end
              end
            end
          end
          inherited pnlGraphBackground: TPanel
            Left = 120
            Width = 577
            Height = 321
            ExplicitLeft = 120
            ExplicitWidth = 585
            ExplicitHeight = 326
            inherited Bevel1: TBevel
              Width = 529
              Height = 326
              ExplicitWidth = 529
              ExplicitHeight = 326
            end
            inherited chrtVitals: TChart
              Width = 529
              Height = 326
              ExplicitWidth = 529
              ExplicitHeight = 326
            end
            inherited pnlRight: TPanel
              Left = 529
              Height = 326
              ExplicitLeft = 529
              ExplicitHeight = 326
            end
          end
        end
        inherited pnlGrid: TPanel
          Top = 327
          Width = 698
          Height = 167
          ExplicitTop = 327
          ExplicitWidth = 698
          ExplicitHeight = 167
          inherited grdVitals: TStringGrid
            Width = 690
            Height = 130
            Options = [goVertLine, goHorzLine]
            ExplicitWidth = 698
            ExplicitHeight = 130
          end
          inherited pnlGridTop: TPanel
            Width = 696
            ExplicitWidth = 696
            inherited Panel1: TPanel
              inherited cbxGraph: TComboBox
                Height = 21
                ExplicitHeight = 21
              end
            end
            inherited Panel4: TPanel
              Width = 575
              ExplicitWidth = 583
              inherited trbHGraph: TTrackBar
                Width = 547
                ExplicitWidth = 547
              end
            end
          end
          inherited pnlGBot: TPanel
            Top = 163
            Width = 696
            Height = 3
            ExplicitTop = 163
            ExplicitWidth = 704
            ExplicitHeight = 3
          end
          inherited pnlGTop: TPanel
            Width = 696
            ExplicitWidth = 704
          end
          inherited pnlGLeft: TPanel
            Height = 130
            ExplicitHeight = 130
          end
          inherited pnlGRight: TPanel
            Left = 694
            Width = 3
            Height = 130
            ExplicitLeft = 702
            ExplicitWidth = 3
            ExplicitHeight = 130
          end
        end
      end
      inherited pnlTitle: TPanel
        Width = 698
        Height = 47
        ExplicitWidth = 698
        ExplicitHeight = 47
        inherited pnlPtInfo: TPanel
          Height = 47
          ExplicitHeight = 47
          DesignSize = (
            233
            47)
          inherited Bevel2: TBevel
            Height = 47
            ExplicitHeight = 47
          end
        end
        inherited Panel9: TPanel
          Width = 235
          Height = 47
          ExplicitWidth = 235
          ExplicitHeight = 47
          DesignSize = (
            235
            47)
          inherited Bevel3: TBevel
            Left = 226
            Height = 47
            ExplicitLeft = 234
            ExplicitHeight = 47
          end
          inherited pnlDateRangeInfo: TPanel
            Top = 27
            Width = 232
            Height = 20
            ExplicitTop = 27
            ExplicitWidth = 240
            ExplicitHeight = 20
            inherited Label11: TLabel
              Left = 6
              Top = -1
              ExplicitLeft = 6
              ExplicitTop = -1
            end
            inherited lblDateFromTitle: TLabel
              Left = 82
              Top = -1
              ExplicitLeft = 82
              ExplicitTop = -1
            end
          end
        end
        inherited pnlActions: TPanel
          Left = 468
          Width = 230
          Height = 47
          ExplicitLeft = 476
          ExplicitWidth = 230
          ExplicitHeight = 47
          inherited sbtnAllergies: TSpeedButton
            Caption = 'Alle&rgies'
          end
        end
      end
      inherited pnlDebug: TPanel
        Top = 47
        Width = 698
        ExplicitTop = 47
        ExplicitWidth = 706
        inherited Panel2: TPanel
          Left = 472
          ExplicitLeft = 472
          inherited ed: TEdit
            Height = 19
            ExplicitHeight = 19
          end
        end
        inherited sbTest: TStatusBar
          Width = 471
          ExplicitWidth = 471
        end
      end
    end
    inherited ActionList1: TActionList
      inherited acEnterVitals: TAction
        OnExecute = TfraGMV_GridGraph1acEnterVitalsExecute
      end
      inherited acEnteredInError: TAction
        OnExecute = TfraGMV_GridGraph1acEnteredInErrorExecute
      end
      inherited acPatientAllergies: TAction
        OnExecute = TfraGMV_GridGraph1acPatientAllergiesExecute
      end
    end
    inherited PopupMenu1: TPopupMenu
      inherited SelectGraphColor1: TMenuItem
        Action = nil
        OnClick = TfraGMV_GridGraph1SelectGraphColor1Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 144
    object E1: TMenuItem
      Caption = '&File'
      object PatientInformation1: TMenuItem
        Action = TfraGMV_GridGraph1.acPatientInfo
      end
      object VitalsReport1: TMenuItem
        Action = TfraGMV_GridGraph1.acVitalsReport
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object EnteredinError1: TMenuItem
        Action = TfraGMV_GridGraph1.acEnteredInError
      end
      object EnterVitals1: TMenuItem
        Action = TfraGMV_GridGraph1.acEnterVitals
      end
      object Allergies1: TMenuItem
        Action = TfraGMV_GridGraph1.acPatientAllergies
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ShowHideGraphOptions1: TMenuItem
        Action = TfraGMV_GridGraph1.acGraphOptions
      end
      object SelectGraphColor1: TMenuItem
        Caption = 'Select Graph &Color...'
        Hint = 'Color Select'
        OnClick = SelectGraphColor1Click
      end
      object PrintGraph1: TMenuItem
        Action = TfraGMV_GridGraph1.acPrintGraph
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Index1: TMenuItem
        Caption = 'Quick Reference'
        OnClick = Index1Click
      end
      object VitalsWe1: TMenuItem
        Caption = 'Vitals Web Page'
        OnClick = VitalsWe1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object AppEv: TApplicationEvents
    Left = 40
    Top = 64
  end
end
