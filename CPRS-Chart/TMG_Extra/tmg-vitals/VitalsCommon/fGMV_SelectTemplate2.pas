unit fGMV_SelectTemplate2;

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
  uGMV_Common, Menus, Buttons, ImgList, ExtCtrls;

type
  TfrmGMV_SelectTemplate2 = class(TForm)
    imgTemplates: TImageList;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    tv: TTreeView;
    pnlTemplate: TPanel;
    lblTemplateInfo: TLabel;
    Panel4: TPanel;
    procedure tvChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tvDblClick(Sender: TObject);
    procedure tvClick(Sender: TObject);
    procedure tvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FTmpltRoot: TTreeNode;
    FTmpltDomainRoot: TTreeNode;
    FTmpltInstitutionRoot: TTreeNode;
    FTmpltHopsitalLocationRoot: TTreeNode;
    FTmpltNewPersonRoot: TTreeNode;
    FNewTemplate: string;
    FNewTemplateDescription:String;
    procedure LoadTreeView;
    procedure InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
    procedure UnLoadTreeView;

  public
    { Public declarations }
  end;

var
  frmGMV_SelectTemplate2: TfrmGMV_SelectTemplate2;

procedure SelectTemplate3(var ATemplate: String);// AAN 08/23/2002

implementation

{$R *.DFM}


procedure SelectTemplate3(var ATemplate: String);
var
  ST2: TfrmGMV_SelectTemplate2;
  i: Integer;

function Template:String;
begin
  try
    result :=  TGMV_Template(ST2.tv.Items[i].Data).Entity + '|' +
               TGMV_Template(ST2.tv.Items[i].Data).TemplateName + '^' +
               Piece(TGMV_Template(ST2.tv.Items[i].Data).XPARValue,'|',1);
  except
    result := '';
  end;
end;

begin
  ST2 := TfrmGMV_SelectTemplate2.Create(Application);
  with ST2 do
    try
      LoadTreeView;//AAN 10/30/2002
      if aTemplate <> '' then
        begin
          for i := 0 to tv.Items.Count-1 do
            begin
              if (tv.Items[i].Level > 1) and  (aTemplate=Template)
              then Break;
            end;
          if i < tv. Items.Count then
            tv.Selected := tv.Items[i];
        end;

      if ShowModal = mrOk then
        ATemplate := FNewTemplate +'^'+FNewTemplateDescription
      else
        aTemplate := '';
      UnLoadTreeView;
    finally
      free;
    end;
end;

procedure TfrmGMV_SelectTemplate2.LoadTreeView;
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
    for i := 1 to tmpList.Count - 1 do
      // AAN 10/30/2002 -- Exception handling for the "no template" cases
      try                        // AAN 10/30/2002
        InsertTemplate(TGMV_Template.CreateFromXPAR(GMVBroker, tmpList[i]));
      except                     // AAN 10/30/2002
        on E: Exception do       // AAN 10/30/2002
          begin                  // AAN 10/30/2002
            ShowMessage('Template Creatioin Error:'+#13+#13+
              E.Message + #13+#13+
              'Template: <'+tmpList[i]+'>');
          end;                   // AAN 10/30/2002
      end;                       // AAN 10/30/2002
  finally
    FreeAndNil(tmpList);
  end;

  tv.Ctl3D := False;
  tv.AlphaSort;
  tv.Enabled := True;
  tv.TopItem := tv.Items.GetFirstNode;
  tv.Items.EndUpdate;
  Refresh;
end;

procedure TfrmGMV_SelectTemplate2.InsertTemplate(
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

procedure TfrmGMV_SelectTemplate2.UnLoadTreeView;
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

procedure TfrmGMV_SelectTemplate2.tvChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  try
    if Node.Level > 1 then
      begin
        FNewTemplate := TGMV_Template(Node.Data).Entity + '|' +
          TGMV_Template(Node.Data).TemplateName;
        FNewTemplateDescription := Piece(TGMV_Template(Node.Data).XPARValue,'|',1);
        lblTemplateInfo.Caption := Piece(TGMV_Template(Node.Data).XPARValue,'|',1);
        if lblTemplateInfo.Caption = '' then
          lblTemplateInfo.Caption := 'No description found for template';
      end
    else
        lblTemplateInfo.Caption := '';

  except
  end;
end;

procedure TfrmGMV_SelectTemplate2.tvDblClick(Sender: TObject);
begin
  if tv.Selected.Level > 1 then
    ModalResult := mrOk;
end;

procedure TfrmGMV_SelectTemplate2.tvClick(Sender: TObject);
begin
//  if tv.Selected.Level > 1 then
//    ModalResult := mrOK;
end;

procedure TfrmGMV_SelectTemplate2.tvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (tv.Selected.Level > 1) then
    begin
      Key := 0;
      tvClick(Sender);
    end
//  else if Key = VK_ESCAPE then
//    ModalResult := mrCancel;
end;

procedure TfrmGMV_SelectTemplate2.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmGMV_SelectTemplate2.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

