unit fTopicSyncReview;
//kt //codex added entire unit 11/3/26

interface

uses
  System.Classes, Vcl.Forms;

// Names and previews have matching indices. Selected receives the checked indices.
function ReviewTopicSyncChanges(AOwner: TComponent; const Names, Previews: TStrings;
  Selected: TStrings; const UncheckedRows: TStrings = nil): Boolean; //kt //codex 11/24/26

implementation

uses
  System.SysUtils, System.UITypes, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls,
//kt //codex original -->   Vcl.ExtCtrls;
  Vcl.ExtCtrls, Vcl.Graphics; //kt //codex 11/24/26

type
  TTopicSyncSelection = class(TComponent) //kt //codex 11/24/26
    List: TListView; //kt //codex 11/24/26
    Button: TButton; //kt //codex 11/24/26
    procedure UpdateButton; //kt //codex 11/24/26
    procedure ListChange(Sender: TObject; Item: TListItem; Change: TItemChange); //kt //codex 11/24/26
    procedure DrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean); //kt //codex 11/24/26
  end; //kt //codex 11/24/26

procedure TTopicSyncSelection.UpdateButton;
//kt //codex added entire procedure 11/24/26
var
  Index: Integer;
begin
  Button.Enabled := False;
  for Index := 0 to List.Items.Count - 1 do begin
    if List.Items[Index].Checked then begin
      Button.Enabled := True;
      Break;
    end;
  end;
end;

procedure TTopicSyncSelection.ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
//kt //codex added entire procedure 11/24/26
begin
  UpdateButton;
end;

procedure TTopicSyncSelection.DrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
//kt //codex added entire procedure 11/24/26
begin
  if SubItem = 1 then begin
    Sender.Canvas.Font.Color := clRed;
  end else if cdsSelected in State then begin
    Sender.Canvas.Font.Color := clHighlightText;
  end else begin
    Sender.Canvas.Font.Color := clWindowText;
  end;
end;

function ReviewTopicSyncChanges(AOwner: TComponent; const Names, Previews: TStrings;
  Selected: TStrings; const UncheckedRows: TStrings): Boolean; //kt //codex 11/24/26
//kt //codex added entire function 11/3/26
var
  Dialog: TForm;
  List: TListView;
  Buttons: TPanel;
  ConfirmButton, CancelButton: TButton;
  SavedLegend, SavedMarker: TLabel; //kt //codex 11/24/26
  Selection: TTopicSyncSelection; //kt //codex 11/24/26
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
  List := nil; //kt //codex 11/24/26
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
//kt //codex original -->     Buttons.Height := 52;
    Buttons.Height := 76; //kt //codex 11/24/26
    Buttons.BevelOuter := bvNone;
    SavedLegend := TLabel.Create(Dialog); //kt //codex 11/24/26
    SavedLegend.Parent := Buttons; //kt //codex 11/24/26
//kt //codex original -->     SavedLegend.Left := 12; //kt //codex 11/24/26
    SavedLegend.Left := 24; //kt //codex 11/24/26
    SavedLegend.Top := 8; //kt //codex 11/24/26
//kt //codex original -->     SavedLegend.Caption := #$2020 + ' Change already saved; may already be in note'; //kt //codex 11/24/26
    SavedLegend.Caption := 'Change already saved; may already be in note'; //kt //codex 11/24/26
    SavedLegend.Visible := Assigned(UncheckedRows) and (UncheckedRows.Count > 0); //kt //codex 11/24/26
    SavedMarker := TLabel.Create(Dialog); //kt //codex 11/24/26
    SavedMarker.Parent := Buttons; //kt //codex 11/24/26
    SavedMarker.Left := 12; //kt //codex 11/24/26
    SavedMarker.Top := 8; //kt //codex 11/24/26
    SavedMarker.Caption := '*'; //kt //codex 11/24/26
    SavedMarker.Font.Color := clRed; //kt //codex 11/24/26
    SavedMarker.Visible := SavedLegend.Visible; //kt //codex 11/24/26

    ConfirmButton := TButton.Create(Dialog);
    ConfirmButton.Parent := Buttons;
    ConfirmButton.Caption := 'Push selected';
    ConfirmButton.Width := 112;
    ConfirmButton.Height := 28;
    ConfirmButton.Left := Buttons.ClientWidth - 226;
//kt //codex original -->     ConfirmButton.Top := 12;
    ConfirmButton.Top := 38; //kt //codex 11/24/26
    ConfirmButton.Anchors := [akTop, akRight];
    ConfirmButton.Default := True;
    ConfirmButton.ModalResult := mrOk;

    CancelButton := TButton.Create(Dialog);
    CancelButton.Parent := Buttons;
    CancelButton.Caption := 'Cancel';
    CancelButton.Width := 90;
    CancelButton.Height := 28;
    CancelButton.Left := Buttons.ClientWidth - 102;
//kt //codex original -->     CancelButton.Top := 12;
    CancelButton.Top := 38; //kt //codex 11/24/26
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
    with List.Columns.Add do begin //kt //codex 11/24/26
      Caption := ''; //kt //codex 11/24/26
      Width := 20; //kt //codex 11/24/26
    end; //kt //codex 11/24/26
    with List.Columns.Add do begin
      Caption := 'Change';
//kt //codex original -->       Width := 520;
      Width := 500; //kt //codex 11/24/26
    end;
    List.Items.BeginUpdate;
    try
      for Index := 0 to Names.Count - 1 do begin
        Item := List.Items.Add;
        Item.Caption := Names[Index];
//kt //codex original -->         Item.SubItems.Add(Previews[Index]);
        if Assigned(UncheckedRows) and (UncheckedRows.IndexOf(IntToStr(Index)) >= 0) then begin //kt //codex 11/24/26
//kt //codex original -->           Item.SubItems.Add(#$2020 + ' ' + Previews[Index]); //kt //codex 11/24/26
          Item.SubItems.Add('*'); //kt //codex 11/24/26
        end else begin //kt //codex 11/24/26
//kt //codex original -->           Item.SubItems.Add(Previews[Index]); //kt //codex 11/24/26
          Item.SubItems.Add(''); //kt //codex 11/24/26
        end; //kt //codex 11/24/26
        Item.SubItems.Add(Previews[Index]); //kt //codex 11/24/26
//kt //codex original -->         Item.Checked := True;
        Item.Checked := not Assigned(UncheckedRows) or (UncheckedRows.IndexOf(IntToStr(Index)) < 0); //kt //codex 11/24/26
      end;
    finally
      List.Items.EndUpdate;
    end;
    Selection := TTopicSyncSelection.Create(Dialog); //kt //codex 11/24/26
    Selection.List := List; //kt //codex 11/24/26
    Selection.Button := ConfirmButton; //kt //codex 11/24/26
    List.OnChange := Selection.ListChange; //kt //codex 11/24/26
    List.OnCustomDrawSubItem := Selection.DrawSubItem; //kt //codex 11/24/26
    Selection.UpdateButton; //kt //codex 11/24/26
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
    if Assigned(List) then begin //kt //codex 11/24/26
      List.OnChange := nil; //kt //codex 11/24/26
      List.OnCustomDrawSubItem := nil; //kt //codex 11/24/26
    end; //kt //codex 11/24/26
    Dialog.Free;
  end;
end;

end.
