unit fTopicTableEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmTopicTableEdit = class(TForm)
    memoTableData: TMemo;
    pnlButtons: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  public
    constructor Create(AOwner: TComponent; const TableName: string; TableLines: TStrings); reintroduce;
    procedure CopyEditedLines(Destination: TStrings);
  end;

implementation

{$R *.dfm}

uses
  uHTMLTools;

constructor TfrmTopicTableEdit.Create(AOwner: TComponent; const TableName: string; TableLines: TStrings);
//kt //codex added entire constructor 10/9/26
var
  Index: Integer;
begin
  inherited Create(AOwner);
  Caption := 'Edit Related Data Table: ' + TableName;
  for Index := 0 to TableLines.Count - 1 do begin
    memoTableData.Lines.Add(HTMLDecode(TableLines[Index]));
  end;
end;

procedure TfrmTopicTableEdit.CopyEditedLines(Destination: TStrings);
//kt //codex added entire procedure 10/9/26
var
  Index: Integer;
  Modified: Boolean;
begin
  Destination.BeginUpdate;
  try
    Destination.Clear;
    for Index := 0 to memoTableData.Lines.Count - 1 do begin
      Modified := False;
      Destination.Add(HTMLEncode(memoTableData.Lines[Index], Modified));
    end;
  finally
    Destination.EndUpdate;
  end;
end;

end.
