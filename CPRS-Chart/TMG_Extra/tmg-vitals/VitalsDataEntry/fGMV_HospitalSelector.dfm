object frmGMV_HospitalSelector: TfrmGMV_HospitalSelector
  Left = 571
  Top = 212
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Hospital Location Selector'
  ClientHeight = 354
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    77000770007700077000770007700000F7000F7000F7000F7000F7000F700000
    0000000000000000000000000000000000000000000000000000000000007708
    F8F8F8F8F8F8F8F8F8F8F8F8F8F8F70000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000770899F8F8F8F899F8F448F8F8F8F448F700
    99000000009900044F0000000440000000900000090090400400000040000000
    0009000090000400004000040000000000009009000040900004004000007708
    44F8F998F844F8F998F844F8F8F8F70044000990004400099000440000000000
    0040000004000000090000000000000000040000400000000090000000000000
    00004004000000000009000000007708F8F8F448F8F8F8F8F8F899F8F8F8F700
    0000044000000000000099000000000000000000000000000000009000000000
    0000000000000000000000090000000000000000000000000000000090007708
    F8F8F8F8F8F8F8F8F8F8F8F8F998F70000000000000000000000000009900000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000007708F8F8F8F8F8F8F8F8F8F8F8F8F8F8F700
    0000000000000000000000000000FFFFFFFFF39CE739F39CE739FFFFFFFFFFFF
    FFFF200000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2000000033FCE3F9FDFB
    5BF7FEF7BDEFFF6F5EDF20000000339CE73FFDFBFBFFFEF7FDFFFF6FFEFF2000
    00003F9FFF3FFFFFFFDFFFFFFFEFFFFFFFF7200000003FFFFFF9FFFFFFFFFFFF
    FFFFFFFFFFFF200000003FFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000007707707707707000F
    70F70F70F70F7700000000000000F70998F8F998F8F800099000099000047700
    090090090440F708F899F8F8944800000099000049007700000000440090F704
    48F8F844F8F900044000040000097700040040000000F708F844F8F8F8F80000
    0044000000007700000000000000F708F8F8F8F8F8F8E4920000E49200003FFF
    000020000000E79E00003B69000020000000FCF300003FCD000020000000E7BE
    00003B7F000020000000FCFF00003FFF000020000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  DesignSize = (
    311
    354)
  PixelsPerInch = 96
  TextHeight = 13
  object gbHospital: TGroupBox
    Left = 6
    Top = 8
    Width = 300
    Height = 301
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 177
      Height = 13
      Caption = ' &Hospital Location where vitals taken '
      FocusControl = cmbTarget
    end
    object lvH: TListView
      Left = 8
      Top = 44
      Width = 281
      Height = 249
      Columns = <
        item
          Caption = 'Name'
          Width = 275
        end
        item
          Caption = 'ID'
          Width = 0
        end>
      FlatScrollBars = True
      HideSelection = False
      ReadOnly = True
      ShowColumnHeaders = False
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = lvHChange
      OnDblClick = lvHDblClick
      OnEnter = lvHEnter
      OnExit = lvHExit
      OnKeyDown = lvHKeyDown
    end
    object cmbTarget: TComboBox
      Left = 8
      Top = 16
      Width = 281
      Height = 21
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbTargetChange
      OnEnter = cmbTargetEnter
      OnExit = cmbTargetExit
      OnKeyDown = cmbTargetKeyDown
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 313
    Width = 311
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblLeft: TLabel
      Left = 16
      Top = 16
      Width = 78
      Height = 13
      Caption = '                          '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object btnOK: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Select'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 232
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object tmSearch: TTimer
    Enabled = False
    OnTimer = tmSearchTimer
    Left = 256
    Top = 64
  end
end
