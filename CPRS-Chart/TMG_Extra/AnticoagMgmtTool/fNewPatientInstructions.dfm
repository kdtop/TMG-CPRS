object frmNewPatientInstructions: TfrmNewPatientInstructions
  Left = 0
  Top = 0
  Caption = 'Instructions'
  ClientHeight = 374
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    532
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlNewPt: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 336
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 590
    ExplicitHeight = 281
    DesignSize = (
      532
      336)
    object memNewPtInst: TMemo
      Left = 12
      Top = 47
      Width = 515
      Height = 279
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = []
      Lines.Strings = (
        
          'Items in Yellow & tagged with an asterisk (*) on should be addre' +
          'ssed.'
        ''
        
          'Click [Pt Preferences] button to enter background information an' +
          'd Special  '
        'Instructions/Risks.'
        ''
        
          'Use [Enter Information] tab to enter flow sheet data for this vi' +
          'sit. Edit '
        
          'warfarin pill strength/daily dosing.  Then proceed to [Exit] tab' +
          '.'
        ''
        
          'From [Exit tab], generate documentation.  Then exit the applicat' +
          'ion by '
        
          'choosing either '#39'Temp Save'#39'  or '#39'Complete Visit'#39'.  Temp Save wil' +
          'l allow for the '
        
          'information to be completed/changed at a later time; Complete Vi' +
          'sits are '
        'finished flowsheet entries.'
        ''
        'Note that lab orders must then be signed in CPRS.')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object lblNewPtInst: TStaticText
      Left = 28
      Top = 14
      Width = 205
      Height = 13
      AutoSize = False
      Caption = 'New Patient Entry Instructions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Transparent = False
    end
  end
  object btnClose: TBitBtn
    Left = 402
    Top = 343
    Width = 124
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnCloseClick
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
    ExplicitLeft = 448
    ExplicitTop = 287
  end
end
