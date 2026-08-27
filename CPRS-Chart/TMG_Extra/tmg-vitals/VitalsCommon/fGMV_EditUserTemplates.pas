unit fGMV_EditUserTemplates;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/27/05 11:59a $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Interface to the template editor for general users.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_EditUserTemplates.pas $
*
* $History: fGMV_EditUserTemplates.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Vhaishandria Date: 10/04/02   Time: 4:50p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version T32 
 * 
 * *****************  Version 5  *****************
 * User: Vhaishandria Date: 6/11/02    Time: 4:48p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Vhaishpetitd Date: 6/06/02    Time: 11:14a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 3  *****************
 * User: Vhaishpetitd Date: 4/26/02    Time: 11:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 2  *****************
 * User: Vhaishpetitd Date: 4/12/02    Time: 3:39p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Done for the week
 *
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 11:56a
 * Created in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
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
  ExtCtrls,
  StdCtrls,
  uGMV_Common,
  uGMV_Const,
  mGMV_EditTemplate;

type
  TfrmGMV_EditUserTemplates = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    btnSaveTemplate: TButton;
    btnNewTemplate: TButton;
    btnClose: TButton;
    btnDelete: TButton;
    fraGMV_EditTemplate1: TfraGMV_EditTemplate;
    lbxTemplates: TListBox;
    procedure lbxTemplatesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveTemplateClick(Sender: TObject);
    procedure btnNewTemplateClick(Sender: TObject);
    procedure GetTemplates;
    procedure btnDeleteClick(Sender: TObject);
    procedure lbxTemplatesEnter(Sender: TObject);
    procedure lbxTemplatesExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CleanUp;
    procedure CMTemplateUpdated(var Message:TMessage); message CM_TemplateUpdated;  //AAN 06/11/02
    procedure CMTemplateRefreshed(var Message:TMessage); message CM_TemplateRefreshed;  //AAN 06/11/02
  end;

procedure EditUserTemplates;

implementation

uses uGMV_Template
, uGMV_Engine;


{$R *.DFM}

procedure EditUserTemplates;
begin
  with TfrmGMV_EditUserTemplates.Create(Application) do
    try
      GetTemplates;
      ShowModal;
    finally
      free;
    end;
end;

procedure TfrmGMV_EditUserTemplates.lbxTemplatesClick(Sender: TObject);
begin
  if lbxTemplates.ItemIndex > -1 then
    if lbxTemplates.Items.Objects[lbxTemplates.ItemIndex] <> nil then
      begin
        fraGMV_EditTemplate1.Enabled := True;
//AAN 06/11/02        btnSaveTemplate.Enabled := True;
        btnDelete.Enabled := True;
//        fraGMV_EditTemplate1.Broker := RPCBroker;
        fraGMV_EditTemplate1.EditTemplate := TGMV_Template(lbxTemplates.Items.Objects[lbxTemplates.ItemIndex]);
      end
    else
      begin
        fraGMV_EditTemplate1.Enabled := False;
//AAN 06/11/02        btnSaveTemplate.Enabled := False;
        btnDelete.Enabled := False;
        fraGMV_EditTemplate1.EditTemplate := nil; //TGMV_Template(lbxTemplates.Items.Objects[lbxTemplates.ItemIndex]);
      end;
end;

procedure TfrmGMV_EditUserTemplates.CleanUp;
var
  aTemplate:TGMV_Template;
begin
    while lbxTemplates.Items.Count > 0 do
      begin
        aTemplate := TGMV_Template(LbxTemplates.Items.Objects[0]);
        FreeAndNil(aTemplate);
        lbxTemplates.Items.Delete(0);
      end;
end;

procedure TfrmGMV_EditUserTemplates.GetTemplates;
var
  i: Integer;
  Templates: TStringList;
begin
//  Templates := TStringList.Create;
  try
//    GetTemplateList('USR', Templates);
    Templates := GetTemplateListByID('USR');
//    Templates := GetTemplateList; // attempt of vhaishandria 050126
//    lbxTemplates.Items.Assign(Templates);
    CleanUp;

    for i := 1 to Templates.Count - 1 do
      LbxTemplates.Items.AddObject(Piece(Templates[i], '^', 4), TGMV_Template.CreateFromXPAR(Templates[i]));
  finally
    FreeAndNil(Templates);
  end;
end;

procedure TfrmGMV_EditUserTemplates.btnCloseClick(Sender: TObject);
begin
  fraGMV_EditTemplate1.SaveTemplateIfChanged;//AAN 06/11/02
  CleanUp;
  Close;
end;

procedure TfrmGMV_EditUserTemplates.btnSaveTemplateClick(Sender: TObject);
begin
  fraGMV_EditTemplate1.SaveTemplate;
  GetTemplates;
end;

procedure TfrmGMV_EditUserTemplates.btnNewTemplateClick(Sender: TObject);
begin
//  CreateNewUserTemplate(RPCBroker);
  CreateNewUserTemplate;
  GetTemplates;
end;

procedure TfrmGMV_EditUserTemplates.btnDeleteClick(Sender: TObject);
var
  s: String;
begin
  if MessageDlg('Delete Template ' + lbxTemplates.Items[lbxTemplates.ItemIndex] + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
//      CallRemoteProc(RPCBroker, RPC_MANAGER, ['DELTEMP', 'USR^' + lbxTemplates.Items[lbxTemplates.ItemIndex]], nil);
//      if Piece(RPCBroker.Results[0], '^', 1) <> '-1' then
      s := deleteUserTemplate(lbxTemplates.Items[lbxTemplates.ItemIndex]);
      if Piece(s, '^', 1) <> '-1' then
        begin
          fraGMV_EditTemplate1.EditTemplate := nil;
          TGMV_Template(lbxTemplates.Items.Objects[lbxTemplates.ItemIndex]).Free;
          lbxTemplates.Items.Delete(lbxTemplates.ItemIndex);
        end
      else
        MessageDlg('Unable to delete template ' + Piece(s, '^', 2, 3), mtError, [mbOk], 0);
    end;

end;

//AAN 06/11/02 ---------------------------------------------------------- Begin
procedure TfrmGMV_EditUserTemplates.CMTemplateUpdated(var Message: TMessage);
begin
  btnSaveTemplate.Enabled := True;
end;

procedure TfrmGMV_EditUserTemplates.CMTemplateRefreshed(var Message: TMessage);
begin
  btnSaveTemplate.Enabled := False;
end;
//AAN 06/11/02 ------------------------------------------------------------ End
procedure TfrmGMV_EditUserTemplates.lbxTemplatesEnter(Sender: TObject);
begin
  GroupBox1.Font.Style := [fsBold];
end;

procedure TfrmGMV_EditUserTemplates.lbxTemplatesExit(Sender: TObject);
begin
  GroupBox1.Font.Style := [];
end;

procedure TfrmGMV_EditUserTemplates.FormActivate(Sender: TObject);
begin
  if lbxTemplates.Items.Count > 0 then
    try
     lbxTemplates.ItemIndex := 0;
     lbxTemplatesClick(Sender);
    except
    end;
end;

end.

