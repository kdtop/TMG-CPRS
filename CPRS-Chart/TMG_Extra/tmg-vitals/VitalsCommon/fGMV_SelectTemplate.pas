unit fGMV_SelectTemplate;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ImgList,
  uGMV_Common, Menus;

type
  TfrmGMV_SelectTemplate = class(TForm)
    imgTemplates: TImageList;
    tv: TTreeView;
    Image1: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Reports1: TMenuItem;
    Help1: TMenuItem;
    procedure tvChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tvDblClick(Sender: TObject);
    procedure tvClick(Sender: TObject);
    procedure tvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure Image1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure Reports1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
  private
//    aLeft,aWidth,aTop,aHeight: Integer;// AAN 07/01/2002
    FTmpltRoot: TTreeNode;
    FTmpltDomainRoot: TTreeNode;
    FTmpltInstitutionRoot: TTreeNode;
    FTmpltHopsitalLocationRoot: TTreeNode;
    FTmpltNewPersonRoot: TTreeNode;
    FNewTemplate: string;
    FNewTemplateDescription:String; // AAN 07/01/2002
    procedure LoadTreeView;
    procedure InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
    procedure UnLoadTreeView;

//    procedure CopyBackground(Aform: TForm);//AAN 07/25/2002
  public
    { Public declarations }
  end;

var
  frmGMV_SelectTemplate: TfrmGMV_SelectTemplate;

procedure SelectTemplate(var ATemplate: string; ACtrl: TControl);
procedure SelectTemplate2(var ATemplate: string;aCtrl:TControl; AForm: TForm);// AAN 07/01/2002

implementation

uses
 clipbrd;
{$R *.DFM}

procedure SelectTemplate(var ATemplate: string; ACtrl: TControl);
begin
  with TfrmGMV_SelectTemplate.Create(Application) do
    try
      LoadTreeView;

      Left := ACtrl.Parent.ClientToScreen(Point(ACtrl.Left, ACtrl.Top)).x;
      Width := ACtrl.Width;
      Top := ACtrl.Parent.ClientToScreen(Point(ACtrl.Left, ACtrl.Top)).y + ACtrl.Height;

      if ShowModal = mrOk then
        begin
//          ATemplate := FNewTemplate;
          ATemplate := FNewTemplate +'^'+FNewTemplateDescription;
        end;
      UnLoadTreeView;
    finally
      free;
    end;
end;

procedure SelectTemplate2(var ATemplate: string;aCtrl:TControl; AForm: TForm);
begin
  with TfrmGMV_SelectTemplate.Create(Application) do
    try
      LoadTreeView;

      tv.Left := ACtrl.Parent.ClientToScreen(Point(ACtrl.Left, ACtrl.Top)).x-
        AForm.Left - 4;
      tv.Top := ACtrl.Parent.ClientToScreen(Point(ACtrl.Left, ACtrl.Top)).y + ACtrl.Height-
        AForm.Top - 2*aCtrl.Height;
      Height := 250;
{
      Caption := AForm.Caption;

      tv.Left := ACtrl.ClientToScreen(Point(aCtrl.Left,aCtrl.Top)).x -
        AForm.Left -
          GetSystemMetrics(SM_CXBORDER);

      tv.Top := ACtrl.ClientToScreen(Point(ACtrl.Left, ACtrl.Top)).y -
        AForm.Top -
          GetSystemMetrics(SM_CYMENU)-
          GetSystemMetrics(SM_CYMENU);


      tv.Width := ACtrl.Width;

      aTop := aForm.Top;
      aLeft := aForm.Left;
      aWidth := aForm.Width;
      aHeight := aForm.Height;

      FormResize(nil);
      CopyBackground(AForm);
}
      if ShowModal = mrOk then
        begin
          ATemplate := FNewTemplate +'^'+FNewTemplateDescription;
        end;
      UnLoadTreeView;
    finally
      free;
    end;
end;

procedure TfrmGMV_SelectTemplate.LoadTreeView;
var
  tmpList: TStringList;
  i: integer;
begin
  tv.Enabled := False;
  tv.Items.BeginUpdate;
  tv.ShowRoot := True;
  with tv.items do
    begin
      Clear;
      FTmpltRoot := nil;
      FTmpltDomainRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teDomain]);
      FTmpltInstitutionRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teInstitution]);
      FTmpltHopsitalLocationRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teHospitalLocation]);
      if GMVAllowUserTemplates then
        FTmpltNewPersonRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teNewPerson]);
    end;

  tmpList := TStringList.Create;
  try
    CallServer(GMVBroker, RPC_MANAGER, ['GETTEMP'], nil, tmpList);
//    CallServer(GMVBroker, RPC_MANAGER, ['GETTEMP','^U'], nil, tmpList);
    for i := 1 to tmpList.Count - 1 do
      InsertTemplate(TGMV_Template.CreateFromXPAR(GMVBroker, tmpList[i]));
  finally
    FreeAndNil(tmpList);
  end;

  tv.Ctl3D := False;
  tv.AlphaSort;
  tv.Enabled := True;
//  tv.FullExpand;
  tv.TopItem := tv.Items.GetFirstNode;
  tv.Items.EndUpdate;
  Refresh;
end;

procedure TfrmGMV_SelectTemplate.InsertTemplate(
  Template: TGMV_Template; GoToTemplate: Boolean = False);
var
  TypeRoot: TTreeNode;
  oRoot: TTreeNode;
  NewNode: TTreeNode;

  function OwnerRoot: TTreeNode;
  begin
    Result := nil;
    oRoot := TypeRoot.getFirstChild;
    while oRoot <> nil do
      begin
        if TGMV_TemplateOwner(oRoot.Data).Entity = Template.Entity then
          begin
            Result := oRoot;
            exit;
          end
        else
          oRoot := TypeRoot.GetNextChild(oRoot);
      end;

    if oRoot = nil then
      begin
        if Template.EntityType = teNewPerson then
          begin
            if GMVAllowUserTemplates then
              Result := tv.Items.AddChildObject(TypeRoot, TitleCase(Template.Owner.OwnerName), Template.Owner);
          end
        else
          Result := tv.Items.AddChildObject(TypeRoot, Template.Owner.OwnerName, Template.Owner);
      end;
  end;

begin
  case Template.EntityType of
    teUnknown: TypeRoot := nil;
    teDomain: TypeRoot := FTmpltDomainRoot;
    teInstitution: TypeRoot := FTmpltInstitutionRoot;
    teHospitalLocation: TypeRoot := FTmpltHopsitalLocationRoot;
    teNewPerson: TypeRoot := FTmpltNewPersonRoot;
  end;

  NewNode := tv.Items.AddChildObject(OwnerRoot, Template.TemplateName, Template);

  if GMVDefaultTemplates.IsDefault(Template.Entity, Template.TemplateName) then
    begin
      NewNode.ImageIndex := GMVIMAGES[iiDefaultTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiDefaultTemplate];
    end
  else
    begin
      NewNode.ImageIndex := GMVIMAGES[iiTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiTemplate];
    end;

  if GoToTemplate then
    begin
      NewNode.Selected := True;
      tv.SetFocus;
    end;
end;

procedure TfrmGMV_SelectTemplate.UnLoadTreeView;
begin
  tv.Items.BeginUpdate;
  while tv.Items.Count > 0 do
    begin
      if tv.Items[0].Data <> nil then
        TGMV_Template(tv.Items[0].Data).Free;
      tv.Items.Delete(tv.Items[0]);
    end;
  tv.Items.EndUpdate;
end;

procedure TfrmGMV_SelectTemplate.tvChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  try
  if Node.Level > 1 then
    begin
      FNewTemplate := TGMV_Template(Node.Data).Entity + '|' +
        TGMV_Template(Node.Data).TemplateName;
      FNewTemplateDescription := Piece(TGMV_Template(Node.Data).XPARValue,'|',1);
    end;
  except

  end;
end;

procedure TfrmGMV_SelectTemplate.tvDblClick(Sender: TObject);
begin
  if tv.Selected.Level > 1 then
    ModalResult := mrOk;
end;

procedure TfrmGMV_SelectTemplate.tvClick(Sender: TObject);
begin
  if tv.Selected.Level > 1 then
    ModalResult := mrOK;
end;

procedure TfrmGMV_SelectTemplate.tvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (tv.Selected.Level > 1) then
    begin
      Key := 0;
      tvClick(Sender);
    end
  else if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmGMV_SelectTemplate.tvCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
//AAN 07/31/2002  AllowCollapse := False;
end;

{AAN 07/25/2002 --------------------------------------------------------- Begin}
{
procedure TfrmGMV_SelectTemplate.CopyBackground(AForm: TForm);
var
  FormImage: TBitmap;
begin
  FormImage := aForm.GetFormImage;
  try
    Image1.Picture.Assign(FormImage);
  finally
    FormImage.Free;
  end;
end;
}
procedure TfrmGMV_SelectTemplate.Image1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmGMV_SelectTemplate.File1Click(Sender: TObject);
begin
  MessageDlgS('Select Template first!',mtError);
end;

procedure TfrmGMV_SelectTemplate.Reports1Click(Sender: TObject);
begin
  MessageDlgS('Select Template first!',mtError);
end;

procedure TfrmGMV_SelectTemplate.Help1Click(Sender: TObject);
begin
  MessageDlgS('Select Template first!',mtError);
end;
{AAN 07/25/2002 ----------------------------------------------------------- End}
end.

