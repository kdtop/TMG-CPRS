unit fTopicSyncReview;
//kt //codex added entire unit 11/3/26

interface

uses
  System.Classes, Vcl.Forms;

// Names and previews have matching indices. Selected receives the checked indices.
function ReviewTopicSyncChanges(AOwner: TComponent; const Names, Previews: TStrings;
  Selected: TStrings): Boolean;

implementation

uses
  System.SysUtils, System.UITypes, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls;

function ReviewTopicSyncChanges(AOwner: TComponent; const Names, Previews: TStrings;
  Selected: TStrings): Boolean;
//kt //codex added entire function 11/3/26
var
  Dialog: TForm;
  List: TListView;
  Buttons: TPanel;
  ConfirmButton, CancelButton: TButton;
  Item: TListItem;
  Index: Integer;
begin
  Result := False;
  if not Assigned(Selected) then begin
    Exit;
  end;
  Selected.Clear;
  if not Assigned(Names) or not Assigned(Previews) or
     (Names.Count <> Previews.Count) or (Names.Count = 0) then begin
    Exit;
  end;
  Dialog := TForm.CreateNew(AOwner);
  try
    Dialog.Caption := 'Review changes to push';
    Dialog.Position := poScreenCenter;
    Dialog.BorderStyle := bsSizeable;
    Dialog.ClientWidth := 800;
    Dialog.ClientHeight := 400;
    Dialog.Constraints.MinWidth := 520;
    Dialog.Constraints.MinHeight := 260;

    Buttons := TPanel.Create(Dialog);
    Buttons.Parent := Dialog;
    Buttons.Align := alBottom;
    Buttons.Height := 52;
    Buttons.BevelOuter := bvNone;

    ConfirmButton := TButton.Create(Dialog);
    ConfirmButton.Parent := Buttons;
    ConfirmButton.Caption := 'Push selected';
    ConfirmButton.Width := 112;
    ConfirmButton.Height := 28;
    ConfirmButton.Left := Buttons.ClientWidth - 226;
    ConfirmButton.Top := 12;
    ConfirmButton.Anchors := [akTop, akRight];
    ConfirmButton.Default := True;
    ConfirmButton.ModalResult := mrOk;

    CancelButton := TButton.Create(Dialog);
    CancelButton.Parent := Buttons;
    CancelButton.Caption := 'Cancel';
    CancelButton.Width := 90;
    CancelButton.Height := 28;
    CancelButton.Left := Buttons.ClientWidth - 102;
    CancelButton.Top := 12;
    CancelButton.Anchors := [akTop, akRight];
    CancelButton.Cancel := True;
    CancelButton.ModalResult := mrCancel;

    List := TListView.Create(Dialog);
    List.Parent := Dialog;
    List.Align := alClient;
    List.ViewStyle := vsReport;
    List.ReadOnly := True;
    List.RowSelect := True;
    List.Checkboxes := True;
    List.HideSelection := False;
    with List.Columns.Add do begin
      Caption := 'Topic or table';
      Width := 240;
    end;
    with List.Columns.Add do begin
      Caption := 'Change';
      Width := 520;
    end;
    List.Items.BeginUpdate;
    try
      for Index := 0 to Names.Count - 1 do begin
        Item := List.Items.Add;
        Item.Caption := Names[Index];
        Item.SubItems.Add(Previews[Index]);
        Item.Checked := True;
      end;
    finally
      List.Items.EndUpdate;
    end;
    if Dialog.ShowModal <> mrOk then begin
      Exit;
    end;
    for Index := 0 to List.Items.Count - 1 do begin
      if List.Items[Index].Checked then begin
        Selected.Add(IntToStr(Index));
      end;
    end;
    Result := Selected.Count > 0;
  finally
    Dialog.Free;
  end;
end;

end.
