unit fConsultants;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ORCtrls, ExtCtrls, ORNet, VAUtils;

type
  TfrmConsultants = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    Splitter1: TSplitter;
    pnlBottomLeft: TPanel;
    Splitter2: TSplitter;
    pnlBottomRight: TPanel;
    lstSpecialties: TORListBox;
    btnClose: TBitBtn;
    Splitter3: TSplitter;
    lstOffices: TORListBox;
    lstDoctors: TORListBox;
    edtNotes: TEdit;
    edtOfficeName: TEdit;
    Label1: TLabel;
    edtPhone: TEdit;
    Label2: TLabel;
    edtFax: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnDoctorAdd: TBitBtn;
    btnDoctorDelete: TBitBtn;
    btnSave: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtNotesChange(Sender: TObject);
    procedure edtFaxChange(Sender: TObject);
    procedure edtPhoneChange(Sender: TObject);
    procedure edtOfficeNameChange(Sender: TObject);
    procedure btnDoctorDeleteClick(Sender: TObject);
    procedure btnDoctorAddClick(Sender: TObject);
    procedure lstDoctorsClick(Sender: TObject);
    procedure lstOfficesClick(Sender: TObject);
    procedure lstSpecialtiesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    IsDirty:boolean;
    ChannelResults :TStringList;
    function CallConsultChannel(RPCCommand:string):boolean;
  public
    { Public declarations }
  end;

var
  frmConsultants: TfrmConsultants;
  procedure OpenConsultantList;

implementation

{$R *.dfm}
procedure OpenConsultantList;
var
  frmConsultants: TfrmConsultants;
begin
  frmConsultants := TfrmConsultants.create(nil);
  frmConsultants.ShowModal;
  frmConsultants.Free;
end;



procedure TfrmConsultants.btnDoctorAddClick(Sender: TObject);
//Ask user for name to add one physician
var PhysicianName:string;
    OneOffice:TStringList;
    OfficeData:string;
begin
  PhysicianName := inputbox('Add doctor to '+piece(lstOffices.Items[lstOffices.ItemIndex],'^',2),'Please enter the name of the doctor you would like to add.','');
  if PhysicianName='' then exit;

  if CallConsultChannel('ADDDOC'+'^'+piece(lstSpecialties.Items[lstSpecialties.ItemIndex],'^',1)+'^'+piece(lstOffices.Items[lstOffices.ItemIndex],'^',1)+'^'+PhysicianName)=True then
    lstOfficesClick(Sender);
end;

procedure TfrmConsultants.btnDoctorDeleteClick(Sender: TObject);
//Delete one physician
var
    OfficeData:string;
begin
  if CallConsultChannel('DELDOC'+'^'+piece(lstSpecialties.Items[lstSpecialties.ItemIndex],'^',1)+'^'+piece(lstOffices.Items[lstOffices.ItemIndex],'^',1)+'^'+piece(lstDoctors.Items[lstDoctors.ItemIndex],'^',1))=True then
    lstOfficesClick(Sender);
end;

procedure TfrmConsultants.btnSaveClick(Sender: TObject);
begin
  if CallConsultChannel('SAVEOFFICE'+'^'+piece(lstSpecialties.Items[lstSpecialties.ItemIndex],'^',1)+'^'+piece(lstOffices.Items[lstOffices.ItemIndex],'^',1)+'^'+edtOfficeName.Text+'^'+edtPhone.Text+'^'+edtFax.Text+'^'+edtNotes.text) = False then
    exit;
  IsDirty := False;
  btnSave.enabled := False;
end;

procedure TfrmConsultants.edtFaxChange(Sender: TObject);
begin
  IsDirty := True;
  btnSave.enabled := True;
end;

procedure TfrmConsultants.edtNotesChange(Sender: TObject);
begin
  IsDirty := True;
  btnSave.enabled := True;
end;

procedure TfrmConsultants.edtOfficeNameChange(Sender: TObject);
begin
  IsDirty := True;
  btnSave.enabled := True;
end;

procedure TfrmConsultants.edtPhoneChange(Sender: TObject);
begin
  IsDirty := True;
  btnSave.enabled := True;
end;

procedure TfrmConsultants.FormDestroy(Sender: TObject);
begin
  ChannelResults.Free;
end;

procedure TfrmConsultants.FormShow(Sender: TObject);
begin
  ChannelResults := TStringList.Create;
  if CallConsultChannel('GETSPECS')=True then
    self.modalresult := mrCancel;
  lstSpecialties.Items.Assign(ChannelResults);
end;

procedure TfrmConsultants.lstDoctorsClick(Sender: TObject);
begin
  btnDoctorDelete.Enabled := (lstDoctors.Itemindex>-1);
end;

procedure TfrmConsultants.lstOfficesClick(Sender: TObject);
var
    OfficeData:string;
begin
  if CallConsultChannel('ONEOFFICE'+'^'+piece(lstSpecialties.Items[lstSpecialties.ItemIndex],'^',1)+'^'+piece(lstOffices.Items[lstOffices.ItemIndex],'^',1))=False then
    exit;
  OfficeData:=ChannelResults[0];
  edtOfficeName.Text := piece(OfficeData,'^',1);
  edtPhone.Text := piece(OfficeData,'^',2);
  edtFax.Text := piece(OfficeData,'^',3);
  edtNotes.Text := piece(OfficeData,'^',4);
  ChannelResults.Delete(0);
  lstDoctors.Items.Assign(ChannelResults);
  btnDoctorAdd.Enabled := True;
  btnDoctorDelete.Enabled := (lstDoctors.Itemindex>-1);
end;

procedure TfrmConsultants.lstSpecialtiesClick(Sender: TObject);
begin
  if CallConsultChannel('GETOFFICES'+'^'+piece(lstSpecialties.Items[lstSpecialties.ItemIndex],'^',1)) = False then
    exit;
  lstOffices.Items.Assign(ChannelResults);
  btnDoctorAdd.Enabled := False;
  btnDoctorDelete.Enabled := False;
  btnSave.Enabled := False;
  edtOfficeName.Text := '';
  edtPhone.Text := '';
  edtFax.Text := '';
  edtNotes.Text := '';
end;

function TfrmConsultants.CallConsultChannel(RPCCommand:string):boolean;
begin
  ChannelResults.Clear;
  tCallV(ChannelResults,'TMG CPRS CONSULTANT CHANNEL',[RPCCommand]);
  if piece(ChannelResults[0],'^',1)='-1' then begin
    ShowMessage(piece(ChannelResults[0],'^',2));
    Result := False;
    exit;
  end;
  Result := True;
  ChannelResults.Delete(0);
end;

end.

