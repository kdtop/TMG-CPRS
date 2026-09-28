object frmTopicTablePicker: TfrmTopicTablePicker
  BorderStyle = bsDialog
  Caption = 'Add Related Data Table'
  ClientHeight = 340
  ClientWidth = 370
  KeyPreview = True
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearch: TLabel
    Left = 8
    Top = 10
    Width = 100
    Height = 13
    Caption = 'Search table names:'
  end
  object edtSearch: TEdit
    Left = 8
    Top = 28
    Width = 354
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = edtSearchChange
    OnKeyDown = edtSearchKeyDown
  end
  object lbTables: TListBox
    Left = 8
    Top = 58
    Width = 354
    Height = 230
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = lbTablesClick
    OnDblClick = lbTablesDblClick
    OnKeyDown = lbTablesKeyDown
  end
  object btnOK: TButton
    Left = 198
    Top = 300
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 287
    Top = 300
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
