unit fGMV_Qualifiers;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 2 $  $Modtime: 7/14/05 10:49a $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Pop-up form for qualifiers when entering vitals.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry/fGMV_Qualifiers.pas $
*
* $History: fGMV_Qualifiers.pas $
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 1/30/04    Time: 4:32p
 * Updated in $/VitalsLite/VitalsLiteDLL
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 7/16/03    Time: 5:40p
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 6/05/03    Time: 2:01p
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 7/18/02    Time: 5:57p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 7/12/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * GUI Version T28
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/01/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 12:04p
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
  StdCtrls,
  CheckLst,
  ExtCtrls
  , uGMV_FileEntry
  , uGMV_Const
  , uGMV_GlobalVars
, uGMV_VitalTypes
  ;

type
  TfrmGMV_Qualifiers = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    edtQuals: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlBottomResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);// AAN 07/01/2002
  private
    FPanelList: TList;
  protected
  public
    { Public declarations }
    FQIENS: string;
    function QualifierNames: string;
    function QualifierIENS: string;
    procedure QualifierClicked(Sender: TObject);
    procedure SetDefaultQualifier(aCategoryIEN,aQualifierIEN:String;aVType: TVitalType);
  end;

function SelectQualifiers(VType: TVitalType; var Quals, QualsDisplay: string; Ctrl: TControl;aValue:String): Boolean;


implementation

uses uGMV_QualifyBox, uGMV_Common, uGMV_Engine
  ;

{$R *.DFM}
                                                 //IDs  //String
function SelectQualifiers(VType: TVitalType; var Quals, QualsDisplay: string; Ctrl: TControl;aValue:String): Boolean;
var
  s: String;//AAN 07/11/02 for Debugging only
  QForm: TfrmGMV_Qualifiers;
  TQB,
  QPanel: TGMV_TemplateQualifierBox;
  i, j: integer;
  ii: Integer;
  pt: TPoint;
  RetList: TStrings;
begin
  Result := False;
  QForm := TfrmGMV_Qualifiers.Create(Application);
  with QForm do
  try
    pt := Ctrl.Parent.ClientToScreen(Point(Ctrl.Left, Ctrl.Top));
    Left := pt.x;
    Top := pt.y + Ctrl.Height;

//    RetList := TStringList.Create;
//    CallRemoteProc(RPCBroker, 'GMV VITALS/CAT/QUAL', [GMVVitalTypeAbbv[VType]], nil,[], RetList);
    RetList := getVitalQualifierList(GMVVitalTypeAbbv[VType]);
    for i := 0 to RetList.Count - 1 do
      begin
        S := RetList[i];
        if Piece(RetList[i], '^', 1) = 'C' then
          begin
            QPanel := TGMV_TemplateQualifierBox.CreateParented(
              QForm.pnlMain,
              GMVVitalTypeIEN[VType],
              piece(RetList[i], '^', 2),
              '');
            FPanelList.Add(QPanel);
            QForm.Width := FPanelList.Count * 100;
          end;
      end;
    RetList.Free;

    if FPanelList.Count < 2 then
      QForm.Width := 150;
    for i := 0 to FPanelList.Count - 1 do
      with TGMV_TemplateQualifierBox(FPanelList[i]) do
        begin
          Left := i * (QForm.Width div FPanelList.Count);
          Width := QForm.Width div FPanelList.Count;
          if i < (FPanelList.Count - 1) then
            Align := alLeft
          else
            Align := alClient;
          Visible := True;
          OnClick := QualifierClicked;
        end;

    i := 1;
    for j := 0 to FPanelList.Count - 1 do
      begin
        TQB := TGMV_TemplateQualifierBox(FPanelList[j]);
        s := TQB.DefaultQualifierIEN;
        ii := StrToIntDef(s,0);
        if ii < 1 then
          begin
            s := piece(Quals, ':', i);// assigning qualifiers as DEFAULT (!?)
            try
//              if s <> '' then //AAN 07/15/2002
//                  TGMV_TemplateQualifierBox(FPanelList[j]).DefaultQualifierIEN := s; // piece(Quals, ':', i);
//              TGMV_TemplateQualifierBox(FPanelList[j]).OnClick(nil);

              if s <> '' then // changed on 050708 by vhaishandria
                begin
                  TGMV_TemplateQualifierBox(FPanelList[j]).DefaultQualifierIEN := s; // piece(Quals, ':', i);
                  TGMV_TemplateQualifierBox(FPanelList[j]).OnQualClick(TGMV_TemplateQualifierBox(FPanelList[j]).CLB);
                end
              else
                TGMV_TemplateQualifierBox(FPanelList[j]).OnQualClick(TGMV_TemplateQualifierBox(FPanelList[j]).CLB);
            except
              on E: Exception do
                ShowMessage('Error assigning <'+s+'> as the default qualifier'+#13#10+
                  E.Message);
            end;
          end;
        inc(i);
      end;
// --------------------------------Set Default Method for BP if value is like nnn/
//    if (VType = vtBP) and (pos('/',aValue) = Length(aValue)) then
//      QForm.SetDefaultQualifier('2','45',vtBP);

    edtQuals.Text := QualifierNames;

    PositionForm(QForm);
    ShowModal;
    if ModalResult = mrOk then
      begin
        Quals := QForm.FQIENS;
        QualsDisplay := QForm.edtQuals.Text;
        Result := True;
      end;
  finally
    free;
  end;
end;

function TfrmGMV_Qualifiers.QualifierNames: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FPanelList.Count - 1 do
    with TGMV_TemplateQualifierBox(FPanelList[i]) do
      if StrToIntDef(DefaultQualifierIEN, 0) > 0 then
        begin
          if Result <> '' then
            Result := Result + ', ';
          Result := Result + DefaultQualifierName;
        end;
end;

function TfrmGMV_Qualifiers.QualifierIENS: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FPanelList.Count - 1 do
    with TGMV_TemplateQualifierBox(FPanelList[i]) do
//      if StrToIntDef(DefaultQualifierIEN, 0) > 0 then//AAN 07/11/2002
        begin
            if Result = '' then
              begin
                if DefaultQualifierIEN <> '' then Result := DefaultQualifierIEN;
              end
            else
                if DefaultQualifierIEN <> '' then Result := Result + ':' +DefaultQualifierIEN;
//          if Result <> '' then
//            Result := Result + ':';
//          Result := Result + DefaultQualifierIEN;
        end;
end;

procedure TfrmGMV_Qualifiers.QualifierClicked(Sender: TObject);
begin
  edtQuals.Text := QualifierNames;
  FQIENS := QualifierIENS;
end;

procedure TfrmGMV_Qualifiers.FormCreate(Sender: TObject);
begin
  FPanelList := TList.Create;
end;

procedure TfrmGMV_Qualifiers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FPanelList);
end;

procedure TfrmGMV_Qualifiers.pnlBottomResize(Sender: TObject);
begin
  edtQuals.Width := pnlBottom.Width - (edtQuals.left * 2);
  btnCancel.Left := pnlBottom.Width - btnCancel.Width - edtQuals.Left;
  btnOK.Left := btnCancel.Left - btnOk.Width - edtQuals.Left;
end;

// AAN 07/01/2002 -------------------------------------------------------- Begin
procedure TfrmGMV_Qualifiers.FormActivate(Sender: TObject);
begin
  if (Left + Width) > Forms.Screen.Width then
    Left := Forms.Screen.Width - Width;
  if (Top + Height) > Forms.Screen.Height then
    Top := Forms.Screen.Height - Height - pnlBottom.Height div 2;
end;
// AAN 07/01/2002 ---------------------------------------------------------- End

procedure TfrmGMV_Qualifiers.SetDefaultQualifier(aCategoryIEN,aQualifierIEN:String;aVType: TVitalType);
var
  TQB: TGMV_TemplateQualifierBox;
  i: Integer;
begin
  for i := 0 to FPanelList.Count - 1 do
    begin
        TQB := TGMV_TemplateQualifierBox(FPanelList[i]);
        if TQB.CategoryIEN = aCategoryIEN then
          TQB.DefaultQualifierIEN := aQualifierIEN;
    end;

end;

end.
