object frmPatientInformation: TfrmPatientInformation
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Edit Patient Information'
  ClientHeight = 388
  ClientWidth = 598
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    598
    388)
  PixelsPerInch = 96
  TextHeight = 13
  object gbxUpdate: TGroupBox
    Left = 11
    Top = 8
    Width = 579
    Height = 341
    Caption = 'Update Patient Information'
    TabOrder = 0
    object lblRisks: TLabel
      Left = 10
      Top = 203
      Width = 60
      Height = 39
      Alignment = taRightJustify
      Caption = 'Secondary Indication(s) / Risks:'
      Constraints.MaxWidth = 65
      WordWrap = True
    end
    object lblDuration: TLabel
      Left = 247
      Top = 281
      Width = 45
      Height = 13
      Caption = 'Duration:'
    end
    object lblStartDate: TLabel
      Left = 77
      Top = 253
      Width = 54
      Height = 13
      Caption = 'Start Date:'
    end
    object lblOrientationDate: TLabel
      Left = 46
      Top = 282
      Width = 84
      Height = 13
      Caption = 'Orientation Date:'
    end
    object lblSpecialInstructions: TLabel
      Left = 9
      Top = 149
      Width = 61
      Height = 26
      Alignment = taRightJustify
      Caption = 'Special  Instructions:'
      WordWrap = True
    end
    object lblStop: TLabel
      Left = 236
      Top = 253
      Width = 52
      Height = 13
      Caption = 'Stop Date:'
      Enabled = False
    end
    object lblAllowedPersons: TLabel
      Left = 24
      Top = 98
      Width = 46
      Height = 31
      AutoSize = False
      Caption = 'Allowed Persons:'
      WordWrap = True
    end
    object ckbBridging: TCheckBox
      Left = 32
      Top = 35
      Width = 160
      Height = 17
      Hint = 
        'Patient is eligible for perioperative Low Molecular Weight Hepar' +
        'in Bridging'
      Caption = 'Eligible for LMWH Bridging'
      TabOrder = 3
      OnClick = ckbBridgingClick
    end
    object ckbMsg: TCheckBox
      Left = 32
      Top = 53
      Width = 341
      Height = 17
      Caption = 'Pt has given permission to leave anticoag msg on msg machine'
      TabOrder = 4
      OnClick = ckbMsgClick
    end
    object ckbPmsg: TCheckBox
      Left = 32
      Top = 70
      Width = 337
      Height = 17
      Caption = 
        'Pt has given permission to leave msg with person(s) listed below' +
        ':'
      TabOrder = 5
      OnClick = ckbPmsgClick
    end
    object memPeople: TMemo
      Left = 76
      Top = 96
      Width = 410
      Height = 37
      Color = clMenu
      Enabled = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 6
      OnChange = memPeopleChange
      OnExit = memPeopleExit
    end
    object ckbAMmeds: TCheckBox
      Left = 32
      Top = 17
      Width = 117
      Height = 17
      Caption = 'Takes meds in A.M.'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = ckbAMmedsClick
    end
    object memRisk: TMemo
      Left = 76
      Top = 205
      Width = 410
      Height = 37
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 8
      OnChange = memRiskChange
      OnExit = memRiskExit
    end
    object memSpecialInstructions: TMemo
      Left = 76
      Top = 135
      Width = 410
      Height = 65
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 7
      OnChange = memSpecialInstructionsChange
      OnExit = memSpecialInstructionsExit
    end
    object pnlLevelOfComplexity: TPanel
      Left = 116
      Top = 305
      Width = 261
      Height = 21
      Caption = ':'
      TabOrder = 15
      object lblLevelOfComplexity: TLabel
        Left = 4
        Top = 4
        Width = 96
        Height = 13
        Caption = 'Level of complexity:'
      end
      object rbComplex: TRadioButton
        Left = 185
        Top = 3
        Width = 71
        Height = 17
        Hint = 'Complex Patient'
        Caption = 'Complex'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        OnClick = rbComplexClick
      end
      object rbStand: TRadioButton
        Left = 108
        Top = 3
        Width = 72
        Height = 17
        Hint = 'Standard Complexity'
        Caption = 'Standard'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbStandClick
      end
    end
    object ckbSA: TCheckBox
      Left = 196
      Top = 17
      Width = 110
      Height = 17
      Caption = 'Signed Agreement'
      TabOrder = 1
      OnClick = ckbSAClick
    end
    object ckbNoStop: TCheckBox
      Left = 392
      Top = 280
      Width = 97
      Height = 17
      Caption = 'Undetermined'
      TabOrder = 14
      Visible = False
      OnClick = ckbNoStopClick
    end
    object btnSExit: TButton
      Left = 410
      Top = 303
      Width = 75
      Height = 25
      Hint = 'Save changes and close the program.  No flowsheet entry is made.'
      Caption = '&Save/Exit'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Visible = False
      OnClick = btnSExitClick
    end
    object pnlRestrict: TPanel
      Left = 375
      Top = 17
      Width = 193
      Height = 47
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object lblRstrctDrawDays: TLabel
        Left = 4
        Top = 1
        Width = 63
        Height = 13
        Caption = 'No draws on:'
      end
      object ckbRM: TCheckBox
        Left = 16
        Top = 18
        Width = 33
        Height = 17
        Hint = 'Monday'
        Caption = 'M'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckbRestrictDayClick
      end
      object ckbRF: TCheckBox
        Left = 152
        Top = 18
        Width = 33
        Height = 17
        Hint = 'Friday'
        Caption = 'F'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = ckbRestrictDayClick
      end
      object ckbRT: TCheckBox
        Left = 48
        Top = 18
        Width = 33
        Height = 17
        Hint = 'Tuesday'
        Caption = 'T'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = ckbRestrictDayClick
      end
      object ckbRTh: TCheckBox
        Left = 114
        Top = 18
        Width = 33
        Height = 17
        Hint = 'Thursday'
        Caption = 'Th'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ckbRestrictDayClick
      end
      object ckbRW: TCheckBox
        Left = 80
        Top = 18
        Width = 33
        Height = 17
        Hint = 'Wednesday'
        Caption = 'W'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = ckbRestrictDayClick
      end
    end
    object edtDur: TEdit
      Left = 296
      Top = 276
      Width = 84
      Height = 21
      Hint = 'Enter the expected duration of treatment in days'
      MaxLength = 12
      TabOrder = 13
      OnChange = edtDurChange
      OnEnter = edtDurEnter
      OnExit = edtDurExit
      OnKeyPress = edtDurKeyPress
    end
    object edtStop: TEdit
      Left = 296
      Top = 248
      Width = 84
      Height = 21
      Hint = 'Enter the date of discharge from the Anticoagulation Clinic'
      Color = cl3DLight
      Enabled = False
      MaxLength = 8
      TabOrder = 12
      OnChange = edtStopChange
    end
    object edtSDate: TEdit
      Left = 136
      Top = 248
      Width = 84
      Height = 21
      Hint = 'Enter the date of enrollment in the Anticoagulation Clinic'
      MaxLength = 8
      TabOrder = 10
      OnChange = edtSDateChange
      OnExit = edtSDateExit
    end
    object edtODate: TEdit
      Left = 136
      Top = 276
      Width = 84
      Height = 21
      Hint = 'Enter the Orientation date'
      MaxLength = 8
      TabOrder = 11
      OnChange = edtODateChange
      OnEnter = edtODateEnter
      OnExit = edtODateExit
    end
    object ckbIncludeRisksInNote: TCheckBox
      Left = 500
      Top = 207
      Width = 63
      Height = 33
      Caption = 'Include in Note?'
      Checked = True
      State = cbChecked
      TabOrder = 9
      WordWrap = True
      OnClick = ckbIncludeRisksInNoteClick
    end
    object btnEditBridgingComments: TButton
      Left = 195
      Top = 35
      Width = 162
      Height = 20
      Caption = '&View / Edit Bridging Comments'
      TabOrder = 17
      Visible = False
      OnClick = btnEditBridgingCommentsClick
    end
  end
  object btnOK: TBitBtn
    Left = 477
    Top = 355
    Width = 113
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF299D49FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF30A2502DCC622AA84EFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF32A4522ACC5F20D25F28
      D05F2DA14EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF35A55529D16120D25FFFFFFF1FD15E27BF594FB16BFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF38A65729D16520D25F2EDA6B29AB512E
      DA6B21D3602AAE53FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF37A656
      2AD2651FD15E43E17B2FAD537BCA932CAB502EDA6B22D05F2BA24DFF00FFFF00
      FFFF00FFFF00FFFF00FF32A6562EDA6B21D15F7CF2A631B353FF00FFFF00FF38
      B25A2CAD502EDA6B21C4573FAD5EFF00FFFF00FFFF00FFFF00FFFF00FF32A656
      8EF8B633B658FF00FFFF00FFFF00FFFF00FFFF00FF2DAD511FCB5C2AB75538B2
      5AFF00FFFF00FFFF00FFFF00FFFF00FF32A656FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF2FB1541FC9572DAE51FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF32B35620C2
      5538B25AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF34B75625B75238B25AFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF37B65B25AD4838B25AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38B75C2EB04FFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FF3EB961FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  object btnCancel: TBitBtn
    Left = 348
    Top = 355
    Width = 123
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FF808080000000000000000000000000000000808080FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000800000FF00
      00FF0000FF0000FF0000FF000080000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
      FF000000FF00FFFF00FFFF00FFFF00FF0000000000FF0000FF0000FF0000FF00
      00FF0000FF0000FF0000FF0000FF0000FF0000FF000000FF00FFFF00FF808080
      0000800000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
      FF0000FF000080808080FF00FF0000000000FF0000FF0000FFFFFFFFFFFFFF00
      00FF0000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FF000000FF00FF000000
      0000FF0000FF0000FF0000FFFFFFFFFFFFFF0000FFFFFFFFFFFFFF0000FF0000
      FF0000FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FF0000FFFF
      FFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FF000000FF00FF000000
      0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000
      FF0000FF0000FF000000FF00FF0000000000FF0000FF0000FF0000FFFFFFFFFF
      FFFF0000FFFFFFFFFFFFFF0000FF0000FF0000FF0000FF000000FF00FF808080
      0000800000FF0000FFFFFFFFFFFFFF0000FF0000FF0000FFFFFFFFFFFFFF0000
      FF0000FF000080808080FF00FFFF00FF0000000000FF0000FF0000FF0000FF00
      00FF0000FF0000FF0000FF0000FF0000FF0000FF000000FF00FFFF00FFFF00FF
      FF00FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
      FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000800000FF00
      00FF0000FF0000FF0000FF000080000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF808080000000000000000000000000000000808080FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  object btnDischargeFromClinic: TBitBtn
    Left = 8
    Top = 355
    Width = 177
    Height = 25
    Anchors = [akBottom]
    Caption = '&Discharge From Clinic'
    TabOrder = 3
    OnClick = btnDischargeFromClinicClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFDAE0FAD8DFFAFFFFFFFFFFFFFFFFFFD9DFFAE9ECFCFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBAC7F7143CE25875E9FFFFFFFFFFFFFFFFFF
      1B43E1294EE3D9E0FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEBDF6123D
      E44465E9EDF0FDFFFFFFFFFFFFFFFFFF4363E60833DE1A42E2E5E9FCFFFFFFFF
      FFFFFFFFFFFFFFFFAFBDF70633E5244CE6EDF1FDFFFFFFFFFFFFFFFFFFFFFFFF
      F3F5FD728AED0632E1234AE7CED7FAFFFFFFFFFFFF92A6F5153FE8244DE8E7EB
      FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFCFF8399F10C38E7274FEBD3
      DBFBACBCF90D3AEB2B51EBE6EAFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFACBBF70C39EB0735EC0534EC103CEBE2E7FCFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5C7AF405
      34EE0434EFADBDF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFCFDFF8BA1F90434F01C47F12952F41E49F5DAE2FEFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6A87F80636F31C47F1E1
      E6FDF2F5FE4065F82650FAF3F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      F9FAFF7C95FB0434F41844F4CBD5FCFFFFFFFFFFFFF3F5FF6785FC2C56FBE9ED
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5E7EFB0335F7133FF5DAE1FDFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFF7F98FD1442FBEBEFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0637F91241F7C8D2FDFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFFBFCC
      FEDEE5FEFFFFFFFFFFFFFFFFFFFFFFFF6A87FBB2C1FDFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  end
end
