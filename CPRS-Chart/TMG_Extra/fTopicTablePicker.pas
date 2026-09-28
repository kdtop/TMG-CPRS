unit fTopicTablePicker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls;

type
  TfrmTopicTablePicker = class(TForm)
    lblSearch: TLabel;
    edtSearch: TEdit;
    lbTables: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lbTablesClick(Sender: TObject);
    procedure lbTablesDblClick(Sender: TObject);
    procedure lbTablesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FAllTables: TStringList;
    procedure FilterTables;
    procedure UpdateOKButton;
  public
    constructor Create(AOwner: TComponent; TableNames: TStrings); reintroduce;
    destructor Destroy; override;
    function SelectedTable: string;
  end;

implementation

{$R *.dfm}

constructor TfrmTopicTablePicker.Create(AOwner: TComponent; TableNames: TStrings);
begin
  inherited Create(AOwner);
  FAllTables := TStringList.Create;
  FAllTables.Assign(TableNames);
  FilterTables;
end;

destructor TfrmTopicTablePicker.Destroy;
begin
  FAllTables.Free;
  inherited;
end;

procedure TfrmTopicTablePicker.FilterTables;
var
  Index: Integer;
  SearchTermIndex: Integer;
  SearchText: string;
  SearchTerms: TStringList;
  TableName: string;
  TableMatches: Boolean;
begin
  SearchText := UpperCase(Trim(edtSearch.Text));
  SearchTerms := TStringList.Create;
  try
    ExtractStrings([' ', #9], [], PChar(SearchText), SearchTerms);
    lbTables.Items.BeginUpdate;
    try
      lbTables.Items.Clear;
      for Index := 0 to FAllTables.Count - 1 do begin
        TableName := UpperCase(FAllTables[Index]);
        TableMatches := Pos('INLINE', TableName) = 0;
        for SearchTermIndex := 0 to SearchTerms.Count - 1 do begin
          if Pos(SearchTerms[SearchTermIndex], TableName) = 0 then begin
            TableMatches := False;
            Break;
          end;
        end;
        if TableMatches then begin
          lbTables.Items.Add(FAllTables[Index]);
        end;
      end;
      if lbTables.Items.Count = 1 then begin
        lbTables.ItemIndex := 0;
      end;
    finally
      lbTables.Items.EndUpdate;
    end;
  finally
    SearchTerms.Free;
  end;
  UpdateOKButton;
end;

procedure TfrmTopicTablePicker.UpdateOKButton;
begin
  btnOK.Enabled := lbTables.ItemIndex >= 0;
end;

procedure TfrmTopicTablePicker.edtSearchChange(Sender: TObject);
begin
  FilterTables;
end;

procedure TfrmTopicTablePicker.edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DOWN then begin
    if lbTables.Items.Count > 0 then begin
      if lbTables.ItemIndex < 0 then begin
        lbTables.ItemIndex := 0;
      end;
      UpdateOKButton;
      lbTables.SetFocus;
    end;
    Key := 0;
  end else if (Key = VK_RETURN) and (lbTables.ItemIndex >= 0) then begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TfrmTopicTablePicker.FormShow(Sender: TObject);
begin
  edtSearch.SetFocus;
end;

procedure TfrmTopicTablePicker.lbTablesClick(Sender: TObject);
begin
  UpdateOKButton;
end;

procedure TfrmTopicTablePicker.lbTablesDblClick(Sender: TObject);
begin
  if lbTables.ItemIndex >= 0 then begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmTopicTablePicker.lbTablesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (lbTables.ItemIndex >= 0) then begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

function TfrmTopicTablePicker.SelectedTable: string;
begin
  Result := '';
  if lbTables.ItemIndex >= 0 then begin
    Result := lbTables.Items[lbTables.ItemIndex];
  end;
end;

end.
