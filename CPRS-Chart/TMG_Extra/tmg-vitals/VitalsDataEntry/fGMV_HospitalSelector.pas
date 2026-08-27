unit fGMV_HospitalSelector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls
  , StdCtrls, ComCtrls;

type
  TfrmGMV_HospitalSelector = class(TForm)
    gbHospital: TGroupBox;
    Panel1: TPanel;
    tmSearch: TTimer;
    lblLeft: TLabel;
    lvH: TListView;
    btnOK: TButton;
    Button2: TButton;
    cmbTarget: TComboBox;
    Label1: TLabel;
    procedure tmSearchTimer(Sender: TObject);
    procedure lvHChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmbTargetChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cmbTargetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbTargetEnter(Sender: TObject);
    procedure cmbTargetExit(Sender: TObject);
    procedure lvHExit(Sender: TObject);
    procedure lvHEnter(Sender: TObject);
    procedure lvHKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvHDblClick(Sender: TObject);
  private
    { Private declarations }
    iCycle:Integer;
    fID,
    fName: String;
    procedure Search;
  public
    { Public declarations }
    property HospitalID:String read fID;
    property HospitalName:String read fName;
  end;

var
  frmGMV_HospitalSelector: TfrmGMV_HospitalSelector;

function SelectLocation(aDFN:String;var anID:String;var aName:String):Boolean;

implementation

uses uGMV_Engine, uGMV_Common;

{$R *.DFM}

function SelectLocation(aDFN:String;var anID:String;var aName:String):Boolean;
begin
  Result := False;
  if not Assigned(frmGMV_HospitalSelector) then
    Application.CreateForm(TfrmGMV_HospitalSelector, frmGMV_HospitalSelector);
  if  frmGMV_HospitalSelector = nil then exit;
{$IFDEF DEBUGVERSION}
    frmGMV_HospitalSelector.lblLeft.Visible := True;
{$ELSE}
    frmGMV_HospitalSelector.lblLeft.Visible := False;
{$ENDIF}
  if frmGMV_HospitalSelector.ShowModal = mrOK then
    begin
      frmGMV_HospitalSelector.tmSearch.Enabled := False;
      aName := frmGMV_HospitalSelector.HospitalName;
      anID := frmGMV_HospitalSelector.HospitalID;
      Result := True;
    end;
  try
    FreeAndNil(frmGMV_HospitalSelector);
  except
  end;
end;

procedure TfrmGMV_HospitalSelector.tmSearchTimer(Sender: TObject);
begin
  if iCycle > 1 then
    begin
      iCycle := iCycle - 1;
      lblLeft.Caption := IntToStr(iCycle);
    end
  else
    Search;
end;

procedure TfrmGMV_HospitalSelector.Search;
var
  tmpList: TStringList;
  i: integer;
  LI: TlistItem;

    function WardClinicFilter(aValue:String): Boolean;
      begin
        Result := True;
      end;

begin
  if (cmbTarget.Text='') then Exit;
  
  tmSearch.Enabled := False;
  lblLeft.Caption := '';
  btnOK.Enabled := False;

  // CHECK IF THE LISTS ARE READY....

    try
      tmpList := getLookupEntries('44',cmbTarget.Text);
      if tmpList.Count < 1 then
        begin
          MessageDlg('No entries found matching ''' + cmbTarget.Text + '''.', mtInformation, [mbok], 0);
          cmbTarget.SetFocus;
          cmbTarget.SelectAll;

          FreeAndNil(tmpList);
          Exit;
        end;

      if Piece(tmpList[0], '^', 1) = '-1' then
        begin
          MessageDlg(Piece(tmpList[0], '^', 2), mtError, [mbok], 0);
          cmbTarget.SelectAll;
          cmbTarget.SetFocus;
        end
      else if Piece(tmpList[0], '^', 1) = '0' then
        begin
          MessageDlg('No entries found matching ''' + cmbTarget.Text + '''.', mtInformation, [mbok], 0);
          cmbTarget.SetFocus;
          cmbTarget.SelectAll;
        end
      else
        begin
          tmpList.Delete(0); {Contains the header count record}
          lvH.Items.Clear;
          for i := 0 to tmpList.Count - 1 do
            begin
              /// SCREEN FOR wARDS AND CLINICS ONLY
              IF WardClinicFilter(tmpList[i]) THEN
                BEGIN
              li := lvH.Items.Add;
              li.Caption := Piece(tmpList[i], '^', 2);
              li.SubItems.Add(Piece(Piece(tmpList[i], '^', 1),';',2));
                END;
            end;
          lvH.SetFocus;
          lvH.ItemFocused := lvH.Items[0];
          lvH.ItemIndex := 0;
        end;
    finally
      FreeAndNil(tmpList);
    end;
  if (cmbTarget.Text<>'') and (cmbTarget.Items.IndexOf(cmbTarget.Text) = -1) then
   cmbTarget.Items.Add(cmbTarget.Text);

end;

procedure TfrmGMV_HospitalSelector.lvHChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  try
    fID := lvH.Selected.SubItems[0];
    fName := lvH.Selected.Caption;
    btnOK.Enabled := True;
    lblLeft.Caption := fName + '('+fID+')';
  except
  end;
end;

procedure TfrmGMV_HospitalSelector.cmbTargetChange(Sender: TObject);
begin
  if cmbTarget.Text = '' then Exit;
  tmSearch.Enabled := True;
  iCycle := 3;
  lblLeft.Caption := IntToStr(iCycle);
  tmSearch .Interval := 1000;
end;

procedure TfrmGMV_HospitalSelector.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = char(VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TfrmGMV_HospitalSelector.FormActivate(Sender: TObject);
begin
  try
    cmbTarget.SetFocus;
  except
  end;
end;

procedure TfrmGMV_HospitalSelector.cmbTargetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_Return then Search;
end;

procedure TfrmGMV_HospitalSelector.cmbTargetEnter(Sender: TObject);
begin
  cmbTarget.Color := clTabIn;
end;

procedure TfrmGMV_HospitalSelector.cmbTargetExit(Sender: TObject);
begin
  cmbTarget.Color := clTabOut;
end;

procedure TfrmGMV_HospitalSelector.lvHExit(Sender: TObject);
begin
  lvH.Color := clTabOut;
end;

procedure TfrmGMV_HospitalSelector.lvHEnter(Sender: TObject);
begin
  lvH.Color := clTabIn;
end;

procedure TfrmGMV_HospitalSelector.lvHKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
   VK_RETURN:
    if (lvH.ItemIndex > -1) then
      begin
        Key := 0;
        fID := lvH.Selected.SubItems[0];
        fName := lvH.Selected.Caption;
        ModalResult := mrOK;
      end;
   end;
end;

procedure TfrmGMV_HospitalSelector.lvHDblClick(Sender: TObject);
begin
  fID := lvH.Selected.SubItems[0];
  fName := lvH.Selected.Caption;
  ModalResult := mrOK;
end;

end.
