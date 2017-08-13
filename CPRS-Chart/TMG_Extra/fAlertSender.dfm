inherited frmAlertSender: TfrmAlertSender
  Left = 297
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Alert Sender'
  ClientHeight = 297
  ClientWidth = 395
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 401
  ExplicitHeight = 325
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 395
    Height = 297
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 387
    ExplicitHeight = 279
    DesignSize = (
      395
      297)
    object SrcLabel: TLabel
      Left = 12
      Top = 15
      Width = 144
      Height = 30
      AutoSize = False
      Caption = 'Select one or more names to receive alert'
      WordWrap = True
    end
    object DstLabel: TLabel
      Left = 231
      Top = 15
      Width = 145
      Height = 16
      AutoSize = False
      Caption = 'Currently selected recipients'
    end
    object cmdOK: TButton
      Left = 105
      Top = 264
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 5
      OnClick = cmdOKClick
      ExplicitTop = 246
    end
    object cmdCancel: TButton
      Left = 193
      Top = 264
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 6
      OnClick = cmdCancelClick
      ExplicitTop = 246
    end
    object cboSrcList: TORComboBox
      Left = 12
      Top = 53
      Width = 144
      Height = 176
      Anchors = [akLeft, akTop, akBottom]
      Style = orcsSimple
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      OnChange = cboSrcListChange
      OnKeyDown = cboSrcListKeyDown
      OnMouseClick = cboSrcListMouseClick
      OnNeedData = cboSrcListNeedData
      CharsNeedMatch = 1
      ExplicitHeight = 185
    end
    object DstList: TORListBox
      Left = 231
      Top = 52
      Width = 156
      Height = 176
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = DstListChange
      Caption = 'Currently selected recipients'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = DstListChange
      ExplicitWidth = 144
      ExplicitHeight = 185
    end
    object btnAddAlert: TButton
      Left = 162
      Top = 97
      Width = 63
      Height = 25
      Caption = '&Add'
      TabOrder = 1
      OnClick = btnAddAlertClick
    end
    object btnRemoveAlertFwrd: TButton
      Left = 162
      Top = 128
      Width = 63
      Height = 25
      Caption = '&Remove'
      Enabled = False
      TabOrder = 3
      OnClick = btnRemoveAlertFwrdClick
    end
    object btnRemoveAllAlertFwrd: TButton
      Left = 162
      Top = 159
      Width = 63
      Height = 25
      Caption = 'R&emove All'
      Enabled = False
      TabOrder = 4
      OnClick = btnRemoveAllAlertFwrdClick
    end
    object cboAlertLevel: TORComboBox
      Left = 72
      Top = 235
      Width = 241
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 8
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 72
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboSrcList'
        'Label = SrcLabel'
        'Status = stsOK')
      (
        'Component = DstList'
        'Status = stsDefault')
      (
        'Component = btnAddAlert'
        'Status = stsDefault')
      (
        'Component = btnRemoveAlertFwrd'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllAlertFwrd'
        'Status = stsDefault')
      (
        'Component = frmAlertSender'
        'Status = stsDefault')
      (
        'Component = cboAlertLevel'
        'Status = stsDefault'))
  end
end
