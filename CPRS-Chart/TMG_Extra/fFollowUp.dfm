inherited frmFollowUp: TfrmFollowUp
  Caption = 'FollowUp'
  ClientHeight = 588
  ClientWidth = 1004
  ExplicitWidth = 1020
  ExplicitHeight = 626
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOK: TBitBtn
    Left = 846
    Top = 564
    ExplicitLeft = 846
    ExplicitTop = 564
  end
  inherited btnCancel: TBitBtn
    Left = 927
    Top = 564
    ExplicitLeft = 927
    ExplicitTop = 564
  end
  object Panel1: TPanel [2]
    Left = 8
    Top = 8
    Width = 457
    Height = 457
    Color = clSkyBlue
    TabOrder = 2
    object lblFreeTxtFU: TLabel
      Left = 8
      Top = 123
      Width = 90
      Height = 13
      Caption = 'Free Text Followup'
    end
    object Shape1: TShape
      Left = 8
      Top = 150
      Width = 432
      Height = 4
      Brush.Color = clSkyBlue
      Pen.Color = clGray
    end
    object lblGroup: TLabel
      Left = 10
      Top = 176
      Width = 29
      Height = 13
      Caption = 'Group'
    end
    object lblFor: TLabel
      Left = 255
      Top = 213
      Width = 15
      Height = 13
      Caption = 'For'
    end
    object lblWith: TLabel
      Left = 25
      Top = 250
      Width = 22
      Height = 13
      Caption = 'With'
    end
    object btnGroupA: TSpeedButton
      Left = 60
      Top = 171
      Width = 25
      Height = 25
      Caption = 'A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnGroupABCClick
    end
    object btnGroupB: TSpeedButton
      Left = 100
      Top = 171
      Width = 25
      Height = 25
      Caption = 'B'
      OnClick = btnGroupABCClick
    end
    object btnGroupC: TSpeedButton
      Left = 135
      Top = 171
      Width = 25
      Height = 25
      Caption = 'C'
      OnClick = btnGroupABCClick
    end
    object btnCPE: TSpeedButton
      Left = 10
      Top = 208
      Width = 50
      Height = 25
      Caption = 'CPE'
      OnClick = btnReasonClick
    end
    object btnAWV: TSpeedButton
      Left = 70
      Top = 208
      Width = 50
      Height = 25
      Caption = 'AWV'
      OnClick = btnReasonClick
    end
    object btnNoPap: TSpeedButton
      Left = 130
      Top = 208
      Width = 50
      Height = 25
      Caption = 'No Pap'
      OnClick = btnReasonClick
    end
    object btnRecheck: TSpeedButton
      Left = 190
      Top = 208
      Width = 60
      Height = 25
      Caption = 'Recheck'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnReasonClick
    end
    object btnDrKT: TSpeedButton
      Left = 60
      Top = 243
      Width = 75
      Height = 25
      Caption = 'Dr. Kevin'
      OnClick = btnProviderClick
    end
    object btnDrDT: TSpeedButton
      Left = 150
      Top = 243
      Width = 75
      Height = 25
      Caption = 'Dr. Dee'
      OnClick = btnProviderClick
    end
    object btn1Week: TSpeedButton
      Left = 10
      Top = 10
      Width = 100
      Height = 25
      Caption = '1 Week'
      OnClick = btnIntervalClick
    end
    object btn2Weeks: TSpeedButton
      Left = 120
      Top = 10
      Width = 100
      Height = 25
      Caption = '2 Weeks'
      OnClick = btnIntervalClick
    end
    object btn3Weeks: TSpeedButton
      Left = 230
      Top = 10
      Width = 100
      Height = 25
      Caption = '3 Weeks'
      OnClick = btnIntervalClick
    end
    object btn1Month: TSpeedButton
      Left = 340
      Top = 10
      Width = 100
      Height = 25
      Caption = '1 Month'
      OnClick = btnIntervalClick
    end
    object btn2Months: TSpeedButton
      Left = 10
      Top = 45
      Width = 100
      Height = 25
      Caption = '2 Months'
      OnClick = btnIntervalClick
    end
    object btn3Months: TSpeedButton
      Left = 120
      Top = 45
      Width = 100
      Height = 25
      Caption = '3 Months'
      OnClick = btnIntervalClick
    end
    object btn4Months: TSpeedButton
      Left = 230
      Top = 45
      Width = 100
      Height = 25
      Caption = '4 Months'
      OnClick = btnIntervalClick
    end
    object btn6Months: TSpeedButton
      Left = 340
      Top = 45
      Width = 100
      Height = 25
      Caption = '6 Months'
      OnClick = btnIntervalClick
    end
    object btn1Yr: TSpeedButton
      Left = 10
      Top = 80
      Width = 100
      Height = 25
      Caption = '1 Year'
      OnClick = btnIntervalClick
    end
    object btn2Yrs: TSpeedButton
      Left = 120
      Top = 80
      Width = 100
      Height = 25
      Caption = '2 Years'
      OnClick = btnIntervalClick
    end
    object btnAsPrev: TSpeedButton
      Left = 230
      Top = 80
      Width = 100
      Height = 25
      Caption = 'As Previous Sched'
      OnClick = btnIntervalClick
    end
    object edtFreeTxtFU: TEdit
      Left = 120
      Top = 120
      Width = 320
      Height = 21
      TabOrder = 0
      OnChange = edtFreeTxtFUChange
    end
    object DateTimePicker: TDateTimePicker
      Left = 336
      Top = 78
      Width = 100
      Height = 25
      Date = 44947.549459062500000000
      Time = 44947.549459062500000000
      TabOrder = 1
      OnChange = DateTimePickerChange
    end
    object edtGroupFreeTxt: TEdit
      Left = 176
      Top = 173
      Width = 264
      Height = 21
      TabOrder = 2
      OnChange = edtGroupFreeTxtChange
    end
    object edtFUReason: TEdit
      Left = 280
      Top = 210
      Width = 158
      Height = 21
      TabOrder = 3
      OnChange = edtFUReasonChange
    end
    object edtApptWith: TEdit
      Left = 240
      Top = 244
      Width = 198
      Height = 21
      TabOrder = 4
      OnChange = edtApptWithChange
    end
    object rgTelemed: TRadioButton
      Left = 8
      Top = 274
      Width = 144
      Height = 17
      Caption = 'For Telemedicine Visit'
      TabOrder = 5
      OnClick = rgLocationClick
    end
    object rgInOffice: TRadioButton
      Left = 201
      Top = 274
      Width = 113
      Height = 17
      Caption = 'For In Office Visit'
      TabOrder = 6
      OnClick = rgLocationClick
    end
    object memOutput: TMemo
      Left = 10
      Top = 297
      Width = 428
      Height = 64
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 7
    end
  end
  object btnNext: TBitBtn [3]
    Left = 8
    Top = 548
    Width = 129
    Height = 32
    Anchors = [akLeft, akBottom]
    Caption = '&Next'
    TabOrder = 3
    OnClick = btnNextClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD17778D23833D5241CD81B13D91D
      13D5261DD43D36D27B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCF4544D51710E03A1FE96A37
      EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4CFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD08C8FD01511E23B20ED
      7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502E
      D6231BD29193FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCE6D6FD613
      0CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7
      C570F4BA69F3A95DEB6F3EDE2618D27576FF00FFFF00FFFF00FFFF00FFFF00FF
      D08C8ED6110BE6572EEF914CF1A85AF2B363F6C26FF9D27AFAE083FAE88BFCE9
      8CF9DE86F9D580F8C677F5B86EF3AE65F19D59EA7240DC2417D29294FF00FFFF
      00FFFF00FFFF00FFCF100DE24223ED8244F09550F2A75EF5B66AF5C375F8D180
      FADD8AFAE28EFBE38FF9DE8EF9D587F7C97EF6BD75F4B06BF29F5DF09254E85F
      37D6211AFF00FFFF00FFFF00FFCB3F40D92112EB713AEE8748EF9554F2A962F6
      B76FF6C37BF8CF84FADA8EF9DC92F9DD95FADB93F8D38DF7C983F7BF7BF4B270
      F2A163F09357EE844DE23D25D14F4DFF00FFFF00FFCF0907E24324EC7740ED85
      4AF09457F4A866F5B672F6C37CF9CE89FAD691FADB97F8D895DFC082F3CE8DF8
      CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14FF00FFCF7274D6140C
      E6572EEC7540EE814BF19458F2A567F5B473F6C07EF8CB8AFAD493FAD898EBCC
      94D7CEBFCFC0A7CCA16DF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD3
      7B7CCD2A2ADB2313E55B31EA6F3FED7F4AE88B55E79A62ECA96EF0B679F3C386
      F6CD91FAD79CDAB47EECE7DEFFFFF9E3DFD5C0A587CC915FF29F68F1905DED80
      50EA6F43E33F27D53B38CC100EDD2B18E75830EA693DA86445B6947FCCAF99D0
      B49DD3BA9FD7C0A4DEC8AEE2CDB1DFCEB7F7F3ECFFFFFAFFFEF8FCF8EFD3C9BB
      B48566CE794EED7D4FE96A42E5462BD5211DCF0605DC2C18E5532EE16138A37B
      66F5ECDFFFFCEFFFF8EDFFF8EDFEF9F0FFFBF5FEFCF6FFFEFBFFFFFCFEFCF7FD
      FAF3FEFAF1FFFFF6F7EEE1B39A8AC96742E8653FE4462BD61411CD0505DA2716
      E44B2BE15A35A67B67F7EDE0FFFBEEFFF7ECFFF7ECFEF8EFFFFBF4FDFBF5FFFD
      FAFFFEFAFEFBF5FDF9F0FEFCF3FFF9EDE5DBCEB28872CD613FE85F3BE43F28D5
      1310CD100FD91F12E24326E85633A55941B7907ECBA792CDAC96D1B099D5B69D
      DBBEA6DDBFA6DBC6B0F5F0E8FFFEF8FFFDF4EEE7DBC5A893B76947EA724BEB66
      42E65535E23623D51E1ACC2A2BD8140DDF3A21E44C2DE75936E2633FE27249E8
      7F55ED9266F1A476F4B07FF8B889E6A87DF0EAE4FCF8F3D3C0AEC17F5DE07C55
      EE774FEC6A46E95E3CE64E31DE281BD33938D07576D10906DB2D1AE34126E54C
      2FE75A38EE744CF48C61F59A6CF7A377F8AB7EF8B082F1AD84DDC2B4D7A98FEE
      9B71F5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D47F80FF00FFCD0604
      D9180FDE3720E34128EA5B39F37A52F4845CF58F64F7996CF79D71F7A378F8A6
      7AF7A175F8A176F79A6EF79369F4855DEB6041E75135E4472EE02C1DD71917FF
      00FFFF00FFCE4344D10906DD2617E03B23F1593AF46E49F47650F5815BF68A62
      F78F66F7926AF7956BF7946AF79167F78C64F5835DF57E59F06345E5452DE137
      24D91F19D86363FF00FFFF00FFFF00FFCE0B0BD40F0AE12D1DF24F31F35A3BF2
      6442F46F4BF67954F67D58F6815CF6845EF6835CF6815AF67A57F6714FF56C4C
      F2593DDF3422DB1C14DB3838FF00FFFF00FFFF00FFFF00FFD49394CF0403DA13
      0CF13924F34C31F25237F55E3EF76747F66C4BF7704FF77150F7704FF76D4BF6
      6949F65F44F65D40ED452DD91C14DE2C2ADBA5A6FF00FFFF00FFFF00FFFF00FF
      FF00FFD27577CF0605E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F
      40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB9192FF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFD69A9CD31D1DE51714F41D15F83423F93E29
      F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFDA6466DD
      2425E72323EE1713F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFD98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA
      9091FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 440
    Top = 368
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmFollowUp'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = edtFreeTxtFU'
        'Status = stsDefault')
      (
        'Component = DateTimePicker'
        'Status = stsDefault')
      (
        'Component = edtGroupFreeTxt'
        'Status = stsDefault')
      (
        'Component = edtFUReason'
        'Status = stsDefault')
      (
        'Component = edtApptWith'
        'Status = stsDefault')
      (
        'Component = rgTelemed'
        'Status = stsDefault')
      (
        'Component = rgInOffice'
        'Status = stsDefault')
      (
        'Component = memOutput'
        'Status = stsDefault')
      (
        'Component = btnNext'
        'Status = stsDefault'))
  end
end
