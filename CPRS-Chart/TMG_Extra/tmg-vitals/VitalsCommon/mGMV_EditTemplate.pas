unit mGMV_EditTemplate;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/03/05 11:37a $
*       Developer:    dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Frame used to edit/save vitals templates
*
*       Notes:        Used on the Vitals User and Manager application
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/mGMV_EditTemplate.pas $
*
* $History: mGMV_EditTemplate.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:18p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/26/04    Time: 1:06p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/Common
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:14p
 * Created in $/Vitals503/Common
 * Version 5.0.3
 * 
 * *****************  Version 11  *****************
 * User: Vhaishandria Date: 5/02/03    Time: 9:33a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Sentillion CCOW Immersion updates
 * 
 * *****************  Version 10  *****************
 * User: Vhaishandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version 5.0.0.0
 * 
 * *****************  Version 9  *****************
 * User: Vhaishandria Date: 10/04/02   Time: 4:50p
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version T32 
 * 
 * *****************  Version 8  *****************
 * User: Vhaishandria Date: 9/06/02    Time: 3:58p
 * Updated in $/Vitals GUI Version 5.0/Common
 * Version T31
 *
 * *****************  Version 7  *****************
 * User: Vhaishandria Date: 7/12/02    Time: 5:01p
 * Updated in $/Vitals GUI Version 5.0/Common
 * GUI Version T28
 * 
 * *****************  Version 6  *****************
 * User: Vhaishandria Date: 6/13/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 5  *****************
 * User: Vhaishandria Date: 6/11/02    Time: 4:47p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 4  *****************
 * User: Vhaishpetitd Date: 6/06/02    Time: 11:08a
 * Updated in $/Vitals GUI Version 5.0/Common
 * Roll-up to 5.0.0.27
 * 
 * *****************  Version 3  *****************
 * User: Vhaishpetitd Date: 4/26/02    Time: 11:31a
 * Updated in $/Vitals GUI Version 5.0/Common
 *
 * *****************  Version 2  *****************
 * User: Vhaishpetitd Date: 4/15/02    Time: 12:16p
 * Updated in $/Vitals GUI Version 5.0/Common
 *
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 4:01p
 * Created in $/Vitals GUI Version 5.0/Common
 *
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
  Buttons,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  CheckLst,
//  TRPCB,
  uGMV_Common,
  fGMV_AddVCQ
  , uGMV_Template
  , ActnList;

type
  TfraGMV_EditTemplate = class(TFrame)
    pnlQualifiers: TPanel;
    pnlUsMetric: TPanel;
    lblQualifiers: TLabel;
    pnlVitals: TPanel;
    rgMetric: TRadioGroup;
    pnlTop: TPanel;
    pnlUpDownInsertDelete: TPanel;
    sbtnMoveUp: TSpeedButton;
    sbtnMoveDown: TSpeedButton;
    sbtnAddVital: TSpeedButton;
    sbtnDeleteVital: TSpeedButton;
    Splitter1: TSplitter;
    pnlHeader: TPanel;
    pnlNameDescription: TPanel;
    edtTemplateDescription: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    edtTemplateName: TEdit;
    pnlListView: TPanel;
    ActionList1: TActionList;
    acUp: TAction;
    acDown: TAction;
    acAdd: TAction;
    acDelete: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    lvVitals: TListView;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure QBCheck(Sender: TObject);
    procedure lvVitalsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure pnlQualifiersResize(Sender: TObject);
    procedure sbtnMoveUpClick(Sender: TObject);
    procedure sbtnAddVitalClick(Sender: TObject);
    procedure sbtnDeleteVitalClick(Sender: TObject);
    procedure sbtnMoveDownClick(Sender: TObject);
    procedure rgMetricClick(Sender: TObject);
    procedure pnlListViewResize(Sender: TObject);
    procedure lvVitalsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChangeMade(Sender: TObject);
    procedure edtTemplateNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acUpExecute(Sender: TObject);
    procedure acDownExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure edtTemplateNameEnter(Sender: TObject);
    procedure edtTemplateNameExit(Sender: TObject);
    procedure edtTemplateDescriptionEnter(Sender: TObject);
    procedure edtTemplateDescriptionExit(Sender: TObject);
    procedure lvVitalsExit(Sender: TObject);
    procedure lvVitalsEnter(Sender: TObject);
    procedure rgMetricEnter(Sender: TObject);
    procedure rgMetricExit(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  private
    FQualBoxes: TList;
    FEditTemplate: TGMV_Template;
    FChangingOrder: Boolean;
//    FBroker: TRPCBroker;
    FChangesMade: Boolean;
    procedure AddVital(Vital: TGMV_TemplateVital);
    procedure ClearAllQualBoxes;
    procedure LoadQualifiers(VitalIEN: string);
    procedure AddQualifierBox(QBVitalIEN: string; QBCatIEN: string; DefaultQualIEN: string = '');
    function GetEditTemplate: TGMV_Template;
    procedure SetEditTemplate(const Value: TGMV_Template);
  public
    procedure SaveTemplate;
    procedure SaveTemplateIfChanged;
  published
//    property Broker: TRPCBroker   read FBroker write FBroker;
    property EditTemplate: TGMV_Template
      read GetEditTemplate write SetEditTemplate;
    property ChangesMade: Boolean
      read FChangesMade;
  end;

implementation

uses uGMV_GlobalVars, uGMV_Const, uGMV_FileEntry
  , uGMV_QualifyBox, uGMV_Engine;


{$R *.DFM}

//AAN 06/11/02------------------------------------------------------------Begin
function MetricCaption(sVitalName:String;bVitalMetric:Boolean):String;
begin
  if pos(UpperCase(sVitalName),upperCase(MetricList)) <>0 then
    result :=BOOLEANUM[bVitalMetric]
  else
    result := 'N/A';
end;
//AAN 06/11/02--------------------------------------------------------------End

procedure TfraGMV_EditTemplate.AddVital(Vital: TGMV_TemplateVital);
begin
  try
    with lvVitals.Items.Add do
      begin
        Caption := Vital.VitalName;
        SubItems.Add(MetricCaption(Caption,Vital.Metric));//AAN 06/11/02
        try
          SubItems.Add(Vital.DisplayQualifiers);
          Data := Vital;
        except
          Data := nil;
        end;
      end;
  except
  end;
end;

procedure TfraGMV_EditTemplate.LoadQualifiers(VitalIEN: string);
var
  i: integer;
  retList: TStrings;
begin
  lblQualifiers.Caption := 'Qualifiers: (Loading...)';
  Application.ProcessMessages;
  ClearAllQualBoxes;
  Application.ProcessMessages;

//  RetList := TStringList.Create;
//  CallRemoteProc(FBroker, RPC_MANAGER, ['GETCATS', VitalIEN], nil,[rpcSilent,rpcNoResChk], RetList);
  RetList := getCategoryQualifiers(VitalIEN);
  for i := 1 to RetList.Count - 1 do
    AddQualifierBox(VitalIEN, Piece(RetList[i], '^', 1));
  RetList.Free;

  if FQualBoxes.Count > 0 then
    TGMV_TemplateQualifierBox(FQualBoxes[FQualBoxes.Count - 1]).Align := alClient;
  for i := 0 to FQualBoxes.Count - 1 do
    begin
      TGMV_TemplateQualifierBox(FQualBoxes[i]).Visible := True;
//      TGMV_TemplateQualifierBox(FQualBoxes[i]).TabOrder := i+1;
    end;
  lblQualifiers.Caption := 'Qualifiers:';

  if not FChangesMade then  //AAN 06/12/02
    GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.AddQualifierBox(QBVitalIEN: string; QBCatIEN: string; DefaultQualIEN: string = '');
var
  i: integer;
begin
  if FQualBoxes = nil then
    FQualBoxes := TList.Create;
//  FQualBoxes.Add(TGMV_TemplateQualifierBox.CreateParented(FBroker, pnlQualifiers, QBVitalIEN, QBCatIEN, ''));
  FQualBoxes.Add(TGMV_TemplateQualifierBox.CreateParented(pnlQualifiers, QBVitalIEN, QBCatIEN, ''));
  for i := 0 to FQualBoxes.Count - 1 do
    begin
    with TGMV_TemplateQualifierBox(FQualBoxes[i]) do
      begin
//        Left := i * 5;
        tabOrder := FQualBoxes.Count - i;
        Align := alRight;
        Width := (pnlQualifiers.Width div FQualBoxes.Count);
        OnClick := QBCheck;
      end;
    end;
end;

procedure TfraGMV_EditTemplate.ClearAllQualBoxes;
var
  pnlQB: TPanel;
begin
  if FQualBoxes <> nil then
    while FQualBoxes.Count > 0 do
      begin
        pnlQB := TPanel(FQualBoxes[0]);
        FQualBoxes.Delete(0);
        FreeAndNil(pnlQB);
      end
  else
    FQualBoxes := TList.Create;
  rgMetric.ItemIndex := -1;
end;

procedure TfraGMV_EditTemplate.QBCheck(Sender: TObject);
var
  i, j: integer;
  s, defQuals: string;
  defQualsText: string;
begin
  for i := 0 to FQualBoxes.Count - 1 do
    with TGMV_TemplateQualifierBox(FQualBoxes[i]) do
      begin
        s := DefaultQualifierIEN;
        if StrToIntDef(s, -1) > 0 then
          begin
            j := GMVQuals.IndexOfIEN(DefaultQualifierIEN);
            if j > -1 then
              begin
                if defQuals <> '' then
                  defQuals := defQuals + '~';
                if defQualsText <> '' then
                  defQualsText := defQualsText + ',';
                defQuals := defQuals + CategoryIEN + ',' + DefaultQualifierIEN;
                defQualsText := defQualsText +
                  GMVQuals.Entries[GMVQuals.IndexOfIEN(DefaultQualifierIEN)];
              end;
          end
      end;
  TGMV_TemplateVital(lvVitals.Selected.Data).Qualifiers := defQuals;
  lvVitals.Selected.SubItems[1] := TGMV_TemplateVital(lvVitals.Selected.Data).DisplayQualifiers;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
end;

function TfraGMV_EditTemplate.GetEditTemplate: TGMV_Template;
begin
  Result := FEditTemplate;
end;

procedure TfraGMV_EditTemplate.SetEditTemplate(const Value: TGMV_Template);
var
  XPAR: string;
  i: integer;
begin
  if FChangesMade then
    if MessageDlg('Save template ' + FEditTemplate.TemplateName + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      SaveTemplate;
  ClearAllQualBoxes;
  lvVitals.Items.Clear;
  rgMetric.ItemIndex := -1;
  rgMetric.Enabled := False;
  sbtnMoveUp.Enabled := False;
  sbtnMoveDown.Enabled := False;
  sbtnDeleteVital.Enabled := False;
  if Value <> nil then
    begin
      FEditTemplate := Value;
      FChangingOrder := False;
      XPAR := FEditTemplate.XPARValue;
      edtTemplateName.Text := FEditTemplate.TemplateName;
      edtTemplateDescription.Text := Piece(XPAR, '|', 1);
      XPAR := Piece(XPAR, '|', 2);
      i := 1;
      while Piece(XPAR, ';', i) <> '' do
        begin
          AddVital(TGMV_TemplateVital.CreateFromXPAR(Piece(XPAR, ';', i)));
          inc(i);
        end;
      if lvVitals.Items.Count > 0 then
        lvVitals.Items[0].Selected := True;
    end
  else
    begin
      edtTemplateName.Text := '';
      edtTemplateDescription.Text := '';
    end;
  Enabled := (Value <> nil);
  FChangesMade := False;
  GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.SaveTemplate;
var
  x: string;
  i: integer;
begin
  {Is it renamed?}
  if edtTemplateName.Text <> FEditTemplate.TemplateName then
    if not FEditTemplate.Rename(edtTemplateName.Text) then
      begin
        MessageDlg('Sorry, ' + edtTemplateName.Text + ' is not a valid template name.', mtError, [mbok], 0);
        edtTemplateName.Text := FEditTemplate.TemplateName;
        Exit;
      end;

  x := edtTemplateDescription.Text + '|';
  for i := 0 to lvVitals.Items.Count - 1 do
    with TGMV_TemplateVital(lvVitals.Items[i].Data) do
      begin
        if i > 0 then
          x := x + ';';
        x := x + IEN + ':' + IntToStr(BOOLEAN01[Metric]);
        if Qualifiers <> '' then
          x := x + ':' + Qualifiers;
      end;
  FEditTemplate.XPARValue := x;
  FChangesMade := False;
  GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
end;

procedure TfraGMV_EditTemplate.lvVitalsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  CatIEN: string;
  QualIEN: string;
  i, j: integer;
  bTmp: Boolean; //AAN 06/12/02
begin
  if not FChangingOrder then
    if Selected then
      begin
        with TGMV_TemplateVital(Item.Data) do
          begin
            LoadQualifiers(IEN);
            i := 1;
            while Piece(Qualifiers, '~', i) <> '' do
              begin
                CatIEN := Piece(Piece(Qualifiers, '~', i), ',', 1);
                QualIEN := Piece(Piece(Qualifiers, '~', i), ',', 2);
                for j := 0 to FQualBoxes.Count - 1 do
                  with TGMV_TemplateQualifierBox(FQualBoxes[j]) do
                    if CategoryIEN = CatIEN then
                      DefaultQualifierIEN := QualIEN;
                inc(i);
              end;
            bTmp := FChangesMade;       //AAN 06/12/02
            rgMetric.ItemIndex := BOOLEAN01[Metric];
            rgMetric.Enabled := True;
            FChangesMade := bTmp;       //AAN 06/12/02
          end;
      end
    else
      ClearAllQualBoxes;
  sbtnMoveUp.Enabled := Selected;
  sbtnMoveDown.Enabled := Selected;
  sbtnDeleteVital.Enabled := Selected;
  rgMetric.Enabled := Selected;
//AAN 06/11/02 -----------------------------------------------------------Begin
  try
    with TGMV_TemplateVital(Item.Data) do
      rgMetric.Enabled := (pos(VitalName,MetricList) <> 0);
  except
  end;

  if not FChangesMade then
    GetParentForm(Self).Perform(CM_TEMPLATEREFRESHED, 0, 0)    //AAN 06/11/02
//AAN 06/11/02 -------------------------------------------------------------End
end;

procedure TfraGMV_EditTemplate.pnlQualifiersResize(Sender: TObject);
var
  i: integer;
begin
  if FQualBoxes <> nil then
    for i := 0 to FQualBoxes.Count - 1 do
      TGMV_TemplateQualifierBox(FQualBoxes[i]).Width := (pnlQualifiers.Width div FQualBoxes.Count);
end;

procedure TfraGMV_EditTemplate.sbtnMoveUpClick(Sender: TObject);
var
  tmpItem: TGMV_TemplateVital;
  i: integer;
begin
  lvVitals.Items.BeginUpdate;
  FChangingOrder := True;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
  if lvVitals.Selected.Index > 0 then
    begin
      i := lvVitals.Items.IndexOf(lvVitals.Selected);
      tmpItem := lvVitals.Items[i].Data;
      lvVitals.Items[i].Data := lvVitals.Items[i - 1].Data;
      lvVitals.Items[i - 1].Data := tmpItem;

      with TGMV_TemplateVital(lvVitals.Items[i].Data) do
        begin
          lvVitals.Items[i].Caption := VitalName;
          lvVitals.Items[i].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      with TGMV_TemplateVital(lvVitals.Items[i - 1].Data) do
        begin
          lvVitals.Items[i - 1].Caption := VitalName;
          lvVitals.Items[i - 1].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i - 1].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      lvVitals.Items[i].Selected := False;
      lvVitals.Items[i - 1].Selected := True;
      lvVitals.UpdateItems(i - 1, i);
      lvVitals.ItemFocused := lvVitals.Items[i - 1];
    end;
  FChangingOrder := False;
  lvVitals.Items.EndUpdate;
end;

procedure TfraGMV_EditTemplate.sbtnMoveDownClick(Sender: TObject);
var
  tmpItem: TGMV_TemplateVital;
  i: integer;
begin
  lvVitals.Items.BeginUpdate;
  FChangingOrder := True;
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
  if lvVitals.Selected.Index < lvVitals.Items.Count - 1 then
    begin
      i := lvVitals.Items.IndexOf(lvVitals.Selected);
      tmpItem := lvVitals.Items[i].Data;
      lvVitals.Items[i].Data := lvVitals.Items[i + 1].Data;
      lvVitals.Items[i + 1].Data := tmpItem;

      with TGMV_TemplateVital(lvVitals.Items[i].Data) do
        begin
          lvVitals.Items[i].Caption := VitalName;
          lvVitals.Items[i].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      with TGMV_TemplateVital(lvVitals.Items[i + 1].Data) do
        begin
          lvVitals.Items[i + 1].Caption := VitalName;
          lvVitals.Items[i + 1].SubItems[1] := DisplayQualifiers;
          lvVitals.Items[i + 1].SubItems[0] := MetricCaption(           //AAN 06/11/02
              VitalName, //AAN 06/11/02
              Metric);   //AAN 06/11/02
        end;

      lvVitals.Items[i].Selected := False;
      lvVitals.Items[i + 1].Selected := True;
      lvVitals.UpdateItems(i, i + 1);
      lvVitals.ItemFocused := lvVitals.Items[i + 1];
    end;
  FChangingOrder := False;
  lvVitals.Items.EndUpdate;
end;

procedure TfraGMV_EditTemplate.sbtnAddVitalClick(Sender: TObject);
var
  i: integer;
begin
  with TfrmGMV_AddVCQ.Create(Self) do
    try
      LoadVitals;
      ShowModal;
      if ModalResult = mrOk then
        for i := 0 to lbxVitals.Items.Count - 1 do
          if lbxVitals.Selected[i] then
            AddVital(TGMV_TemplateVital.CreateFromXPAR(
              TGMV_FileEntry(lbxVitals.Items.Objects[i]).IEN +
              ':' + lbxVitals.Items[i] + '::')
              );
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
    finally
      free;
    end;
end;

procedure TfraGMV_EditTemplate.sbtnDeleteVitalClick(Sender: TObject);
var
  i: integer;
begin
  i := lvVitals.Items.IndexOf(lvVitals.Selected); {Where are we now}

  if lvVitals.Selected <> nil then
    begin
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
      if lvVitals.Selected.Data <> nil then
        TGMV_TemplateVital(lvVitals.Selected.Data).Free;
      lvVitals.Selected.Delete;
      if i > lvVitals.Items.Count - 1 then
        i := lvVitals.Items.Count - 1; {Deleted last one, get new last item}
      if i > -1 then
        lvVitals.Items[i].Selected := True;
    end;
end;

procedure TfraGMV_EditTemplate.rgMetricClick(Sender: TObject);
begin
  if lvVitals.Selected <> nil then
    begin
      FChangesMade := True;
      GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0);    //AAN 06/11/02
//AAN 06/11/02      lvVitals.Selected.SubItems[0] := rgMetric.Items[rgMetric.ItemIndex];
      TGMV_TemplateVital(lvVitals.Selected.Data).Metric := (rgMetric.ItemIndex = 1);
      lvVitals.Selected.SubItems[0] := MetricCaption(           //AAN 06/11/02
          TGMV_TemplateVital(lvVitals.Selected.Data).VitalName, //AAN 06/11/02
          TGMV_TemplateVital(lvVitals.Selected.Data).Metric);   //AAN 06/11/02
    end;
end;

procedure TfraGMV_EditTemplate.pnlListViewResize(Sender: TObject);
begin
  lvVitals.Width := pnlListView.Width - (lvVitals.Left * 2);
  lvVitals.Height := pnlListView.Height - (lvVitals.Top * 2);
end;

procedure TfraGMV_EditTemplate.lvVitalsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_UP) and (ssCtrl in Shift) then
    begin
      //ShowMessage('Move vital up');
      Key := 0;
      sbtnMoveUpClick(Sender);
    end
  else if (KEY = VK_DOWN) and (ssCtrl in Shift) then
    begin
      //ShowMessage('Move vital down');
      Key := 0;
      sbtnMoveDownClick(Sender);
    end
  else if KEY = VK_INSERT then
    begin
      //ShowMessage('New Vital');
      Key := 0;
      sbtnAddVitalClick(Sender);
    end
  else if KEY = VK_DELETE then
    begin
      //ShowMessage('Delete vital');
      Key := 0;
      sbtnDeleteVitalClick(Sender);
    end;
end;

procedure TfraGMV_EditTemplate.ChangeMade(Sender: TObject);
begin
  FChangesMade := True;
  GetParentForm(Self).Perform(CM_TEMPLATEUPDATED, 0, 0)    //AAN 06/11/02
end;

//AAN 06/11/02 ---------------------------------------------------------- Begin
procedure TfraGMV_EditTemplate.edtTemplateNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_Escape then
    begin
      ChangeMade(Sender);
    end;
end;

procedure TfraGMV_EditTemplate.SaveTemplateIfChanged;
begin
  if FChangesMade then
    if MessageDlg('The template <' + FEditTemplate.TemplateName + '> has been changed.'+
      #13#10+ 'Save changes?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      SaveTemplate;
end;
//AAN 06/11/02 ------------------------------------------------------------ End

procedure TfraGMV_EditTemplate.acUpExecute(Sender: TObject);
begin
  sbtnMoveUpClick(Sender);
end;

procedure TfraGMV_EditTemplate.acDownExecute(Sender: TObject);
begin
  sbtnMoveDownClick(Sender);
end;

procedure TfraGMV_EditTemplate.acAddExecute(Sender: TObject);
begin
  sbtnAddVitalClick(Sender);
end;

procedure TfraGMV_EditTemplate.acDeleteExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete'+#13+
     '<'+lvVitals.Selected.Caption+'>?' ,
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  sbtnDeleteVitalClick(Sender);
end;

procedure TfraGMV_EditTemplate.edtTemplateNameEnter(Sender: TObject);
begin
   label1.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.edtTemplateNameExit(Sender: TObject);
begin
   label1.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.edtTemplateDescriptionEnter(
  Sender: TObject);
begin
   label2.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.edtTemplateDescriptionExit(Sender: TObject);
begin
   label2.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.lvVitalsExit(Sender: TObject);
begin
  label3.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.lvVitalsEnter(Sender: TObject);
begin
  label3.Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.rgMetricEnter(Sender: TObject);
begin
  rgMetric.font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.rgMetricExit(Sender: TObject);
begin
  rgMetric.Font.Style := [];
end;

procedure TfraGMV_EditTemplate.FrameEnter(Sender: TObject);
begin
//  Font.Style := [fsBold];
end;

procedure TfraGMV_EditTemplate.FrameExit(Sender: TObject);
begin
//  Font.Style := [];
end;

end.

