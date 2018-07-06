object frmOutsideLab: TfrmOutsideLab
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enter Data from Outside Lab'
  ClientHeight = 270
  ClientWidth = 588
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
  PixelsPerInch = 96
  TextHeight = 13
  object gbxINREnter: TGroupBox
    Left = 0
    Top = 0
    Width = 588
    Height = 270
    Align = alClient
    Caption = 'Outside Lab'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      588
      270)
    object lblNewINR: TLabel
      Left = 28
      Top = 89
      Width = 22
      Height = 13
      Caption = 'INR:'
    end
    object lblLabLoc: TLabel
      Left = 240
      Top = 41
      Width = 93
      Height = 13
      Caption = 'Location of lab test:'
    end
    object lblStandingOrderExp: TLabel
      Left = 24
      Top = 201
      Width = 140
      Height = 13
      Caption = 'Standing lab order expires on:'
      Visible = False
    end
    object lblLabPhone: TLabel
      Left = 278
      Top = 65
      Width = 55
      Height = 13
      Caption = 'Lab Phone:'
    end
    object lblLabFax: TLabel
      Left = 292
      Top = 92
      Width = 41
      Height = 13
      Caption = 'Lab Fax:'
    end
    object lblNewHCT: TLabel
      Left = 27
      Top = 118
      Width = 23
      Height = 13
      Caption = 'Hgb:'
    end
    object lblOptionalLabPhone: TLabel
      Left = 466
      Top = 65
      Width = 43
      Height = 13
      Caption = '(optional)'
    end
    object lblOptionalLabFax: TLabel
      Left = 466
      Top = 92
      Width = 43
      Height = 13
      Caption = '(optional)'
    end
    object Label2: TLabel
      Left = 107
      Top = 118
      Width = 43
      Height = 13
      Caption = '(optional)'
    end
    object edtNewInr: TEdit
      Left = 56
      Top = 89
      Width = 45
      Height = 21
      Hint = 'Enter the value of the INR.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = edtNewInrChange
    end
    object edtLoc: TEdit
      Left = 339
      Top = 38
      Width = 195
      Height = 21
      Hint = 'Enter the name of the location where the test was drawn.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'Family Physicians of Greeneville'
      OnChange = edtLocChange
    end
    object btnClearOutsideLab: TButton
      Left = 56
      Top = 153
      Width = 65
      Height = 25
      Hint = 'Click to Cancel Outside Lab Entry.'
      Caption = '&Clear'
      TabOrder = 5
      OnClick = btnClearOutsideLabClick
    end
    object dtpLabOrderExpiration: TDateTimePicker
      Left = 170
      Top = 198
      Width = 84
      Height = 21
      Date = 37798.525762766200000000
      Time = 37798.525762766200000000
      TabOrder = 7
      Visible = False
      OnChange = dtpLabOrderExpirationChange
    end
    object edtLFax: TEdit
      Left = 339
      Top = 89
      Width = 121
      Height = 21
      Hint = 'Enter the FAX number of the lab where the test was taken.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnChange = edtLFaxChange
    end
    object edtLPhone: TEdit
      Left = 339
      Top = 62
      Width = 121
      Height = 21
      Hint = 'Enter the phone number of the lab where the test was taken.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = edtLPhoneChange
    end
    object edtNewHctOrHgb: TEdit
      Left = 56
      Top = 116
      Width = 45
      Height = 21
      Hint = 'Enter the Hematocrit value.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = edtNewHctOrHgbChange
    end
    object pnlFee: TPanel
      Left = 339
      Top = 131
      Width = 231
      Height = 83
      BevelKind = bkSoft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 6
      Visible = False
      object lblFeeBasis: TLabel
        Left = 8
        Top = 2
        Width = 52
        Height = 13
        Caption = 'Fee Basis?'
      end
      object lblexp: TLabel
        Left = 49
        Top = 55
        Width = 75
        Height = 13
        Caption = 'Expiration Date:'
        Visible = False
      end
      object rbFeeNo: TRadioButton
        Left = 30
        Top = 24
        Width = 37
        Height = 17
        Hint = 'Click to indicate that this is NOT a Fee Basis Lab Test.'
        Caption = 'No'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbFeeNoClick
      end
      object rbFeePrim: TRadioButton
        Left = 78
        Top = 24
        Width = 57
        Height = 17
        Hint = 'Click to indicate a primary Fee Basis Lab Test.'
        Caption = 'Primary'
        TabOrder = 1
        OnClick = rbFeePrimClick
      end
      object rbFeeSec: TRadioButton
        Left = 147
        Top = 24
        Width = 77
        Height = 17
        Hint = 'Click to indicate a Secondary Fee Basis Lab test.'
        Caption = 'Secondary'
        TabOrder = 2
        OnClick = rbFeeSecClick
      end
      object dtpExp: TDateTimePicker
        Left = 133
        Top = 52
        Width = 85
        Height = 21
        Date = 36526.619590671300000000
        Time = 36526.619590671300000000
        TabOrder = 3
        Visible = False
        OnChange = dtpExpChange
      end
    end
    object btnOK: TBitBtn
      Left = 476
      Top = 229
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = False
      TabOrder = 8
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
    object ckbHistorical: TCheckBox
      Left = 28
      Top = 65
      Width = 189
      Height = 17
      Caption = 'Use Lab Date for Flowsheet Date?'
      TabOrder = 10
      Visible = False
      OnClick = ckbHistoricalClick
    end
    object btnCancel: TBitBtn
      Left = 370
      Top = 229
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 9
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
    object pnlDatePanel: TPanel
      Left = 28
      Top = 21
      Width = 157
      Height = 32
      BevelOuter = bvNone
      Color = clYellow
      ParentBackground = False
      TabOrder = 11
      object lblINRDate: TLabel
        Left = 5
        Top = 9
        Width = 26
        Height = 13
        Caption = 'Date:'
      end
      object dtpINR: TDateTimePicker
        Left = 32
        Top = 6
        Width = 109
        Height = 21
        Hint = 'Specify the date when the outside lab was drawn.'
        Date = 37797.554351250000000000
        Time = 37797.554351250000000000
        TabOrder = 0
        OnChange = dtpChange
      end
    end
  end
end
