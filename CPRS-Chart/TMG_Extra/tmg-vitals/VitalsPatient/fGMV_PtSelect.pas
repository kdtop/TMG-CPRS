unit fGMV_PtSelect;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/11/05 12:28p $
*       Developer:
*       Site:         Hines OIFO
*
*       Description:  Allows for a calling appliction to obtain a patient
*                     DFN either by lookup or directly and display a form
*                     showing patient identifiers and any messages that may
*                     be needed to be displayed to the user prior to selection.
*
*       Notes:
*
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient/fGMV_PtSelect.pas $
*
* $History: fGMV_PtSelect.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 4:59p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:23p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSPATIENT
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
  StdCtrls,
  ExtCtrls
  , uGMV_Patient
  ;


type
  TfrmGMV_PtSelect = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    pnlPtInfo: TPanel;
    btnAgree: TButton;
    procedure btnAgreeClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fSelected:Boolean;
//    FBroker: TRPCBroker;
    PatientDFN: String;
    procedure LoadPatient(Patient: TPatient);
    procedure LoadMessages(Patient: TPatient);
  end;


function PatientSelectByDFN(DFN: string): Boolean;
function PatientCheckSelectByDFN(DFN: string;var Name,Info:String): Boolean;

function SelectPatientByDFN(DFN: string;IgnoreCheck:Boolean=False): TPatient;

implementation

uses
  uGMV_Common
  , uGMV_Utils
  , uGMV_Engine
  ;

{$R *.DFM}
{$R RGMV_PTSELECT.RES}
function SelectPatientByDFN(DFN: string;IgnoreCheck:Boolean=False): TPatient;
var
  Patient: TPatient;
begin
  try
    Patient := TPatient.CreatePatientByDFN(DFN);
    if IgnoreCheck then
      begin
        Result := Patient;
        Exit;
      end;
    with TfrmGMV_PtSelect.Create(Application) do
      begin
        LoadPatient(Patient);
        LoadMessages(Patient);
        Position := poDesktopCenter;
        showmodal;
        if fSelected then
          Result := Patient
        else
          begin
            FreeAndNil(Patient); //Patient.free;
            Result := nil;
          end;
      end;
  finally
  end;
end;

function PatientSelectByDFN(DFN: string): Boolean;
var
  Patient: TPatient;
begin
  {Create Patient Object}
  try
    Patient := TPatient.CreatePatientByDFN(DFN);
    with TfrmGMV_PtSelect.Create(Application) do
      begin
        LoadPatient(Patient);
        LoadMessages(Patient);
        Position := poDesktopCenter;
//        FBroker := nil;
        showmodal;
        if fSelected then
          PatientSelectByDFN := True
        else
          PatientSelectByDFN := False;
      end;
  finally
    FreeAndNil(Patient); //Patient.free;
  end;

end;

function PatientCheckSelectByDFN(DFN: string;var Name,Info:String): Boolean;
var
  Patient: TPatient;
begin
  {Create Patient Object}
  try
    Patient := TPatient.CreatePatientByDFN(DFN);
    Name := Patient.Name;
    Info := Patient.SSN+' '+Patient.Age;
//    Location := Patient.LocationName;
    if Patient.Sensitive then
      begin
        with TfrmGMV_PtSelect.Create(Application) do
          begin
            LoadPatient(Patient);
            LoadMessages(Patient);
            Position := poDesktopCenter;
//            FBroker := nil;
            showmodal;
            if fSelected then
              Result := True
            else
              Result := False;
          end;
      end
      else
        Result := True;
  finally
    FreeAndNil(Patient);//Patient.free;
  end;

end;
(*
function PatientSelect(Broker: TRPCBroker; DFN: string): Boolean;
var
  Patient: TPatient;
begin
  {Create Patient Object}
  try
//    Patient := TPatient.CreateByDFN(Broker,DFN);
    Patient := TPatient.CreatePatientByDFN(DFN);
    with TfrmGMV_PtSelect.Create(Application) do
      begin
        LoadPatient(Patient);
        LoadMessages(Patient);
        Position := poDesktopCenter;
        FBroker := Broker;
        showmodal;
        if fSelected then
          PatientSelect := True
        else
          PatientSelect := False;
      end;
  finally
    FreeAndNil(Patient); //Patient.free;
  end;

end;
*)
(*
function PatientCheckSelect(Broker: TRPCBroker; DFN: string;var Name,Info:String): Boolean;
var
  Patient: TPatient;
begin
  {Create Patient Object}
  try
    Patient := TPatient.CreateByDFN(Broker,DFN);
    Name := Patient.Name;
    Info := Patient.SSN+' '+Patient.Age;
    if Patient.Sensitive then
      begin
        with TfrmGMV_PtSelect.Create(Application) do
          begin
            LoadPatient(Patient);
            LoadMessages(Patient);
            Position := poDesktopCenter;
            FBroker := Broker;
            showmodal;
            if fSelected then
              Result := True
            else
              Result := False;
          end;
      end
      else
        Result := True;
  finally
    FreeAndNil(Patient);//Patient.free;
  end;

end;
*)
//* TfrmPtSelect *//

procedure TfrmGMV_PtSelect.LoadPatient(Patient: TPatient);
var
  i: Integer;
  PtId: TPtIdentifier;
begin
  PatientDFN := Patient.DFN;
  for i := 0 to Patient.Identifiers.Count - 1 do
    begin

      PtId := TPtIdentifier(Patient.Identifiers[i]);

      with TLabel.Create(pnlPtInfo) do
        begin
          Parent := pnlPtInfo;
          Left := 15;
          Top := i * (Canvas.TextHeight('X') + 5) + 10;
          Caption := PtId.Caption + ':';
        end;
      PtId.DisplayLabel := TLabel.Create(pnlPtInfo);

      with PtId.DisplayLabel do
        begin
          Parent := pnlPtInfo;
          Left := 170;
          Top := i * (Canvas.TextHeight('X') + 5) + 10;
          Font.Style := [fsBold];
          if Patient.Sensitive then
            Caption := PtId.DisplaySensitive
          else
            Caption := PtId.DisplayNonSensitive;
        end;

    end;

  pnlPtInfo.Height := Patient.Identifiers.Count * (Self.Canvas.TextHeight('X') + 8);

  Height := pnlPtInfo.Height + 70;
  Resize;
end;

procedure TfrmGMV_PtSelect.LoadMessages(Patient: TPatient);
var
  ErrorReturned: Boolean;
  msgBitMap: TBitMap;
  PtMsg: TPtMessage;
  i: Integer;
begin
  ErrorReturned := False;
{
  msgBitMap := TBitMap.Create;
  msgBitMap.Transparent := True;
  msgBitMap.TransparentMode := tmAuto;
}
  for i := 0 to Patient.Messages.Count - 1 do
    begin

  msgBitMap := TBitMap.Create;
  msgBitMap.Transparent := True;
  msgBitMap.TransparentMode := tmAuto;

      PtMsg := TPtMessage(Patient.Messages[i]);

      PtMsg.Panel := TPanel.Create(Self);

      with PtMsg.Panel do
        begin
          Caption := '';
          BevelInner := bvNone;
          BevelOuter := bvNone;
          Parent := Self;

          if i > 0 then
            begin
              Top := TPtMessage(Patient.Messages[i - 1]).Panel.Top +
                TPtMessage(Patient.Messages[i - 1]).Panel.Height;
            end
          else
            Top := pnlPtInfo.Top + pnlPtInfo.Height + 5;

          Left := 5;
          Width := Self.Width - (self.BorderWidth * 2) - 5;
          Height := PtMsg.Text.Count * (Canvas.TextHeight('X') + 4);
          if Height < 40 then
            Height := 40;
        end;

      with TLabel.Create(PtMsg.Panel) do
        begin
          Parent := PtMsg.Panel;
          AutoSize := False;
          Top := 5;
          Left := 45;
          Width := PtMsg.Panel.Width - 5;
          WordWrap := True;
          Caption := PtMsg.Header;
          Font.Style := [fsBold];
          AutoSize := True;
        end;

      with TLabel.Create(PtMsg.Panel) do
        begin
          Parent := PtMsg.Panel;
          AutoSize := False;
          Top := 10 + Self.Canvas.TextHeight('X');
          Left := 45;
          Width := PtMsg.Panel.Width - 50;
          WordWrap := True;
          Caption := PtMsg.Text.Text;
          AutoSize := True;
          PtMsg.Panel.Height := Height + 15;
          self.Height := PtMsg.Panel.Top + PtMsg.Panel.Height + 70;
          self.Resize;
        end;

      with TImage.Create(Self) do
        begin
          Transparent := True;
          Parent := PtMsg.Panel;
          Left := 5;
          Top := 5;
          Height := 32;
          Width := 32;
          case PtMsg.MessageLevel of
            mlInfo:
              try
                msgBitMap.LoadFromResourceName(HInstance, 'MLINFO');
              except
                on E: Exception do
                  SHOWMESSAGE('Info Error:'+E.Message);
              end;
            mlWarning:
              try
                msgBitmap.LoadFromResourceName(HInstance, 'MLWARNING');
              except
                on E: Exception do
                  SHOWMESSAGE('Warning Error:'+E.Message);
              end;
            mlSecurity:
              try
                msgBitmap.LoadFromResourceName(HInstance, 'MLSECURITY');
                btnOk.Enabled := False;
                btnOk.TabStop := False;
                btnOk.Default := False;
                btnAgree.Visible := True;
                btnAgree.TabStop := True;
              except
                on E: Exception do
                  SHOWMESSAGE('Info Security:'+E.Message);
              end;
            mlError:
              try
                msgBitmap.LoadFromResourceName(HInstance, 'MLERROR');
                btnOk.ModalResult := mrCancel;
                btnCancel.Visible := False;
                ErrorReturned := True;
              except
                on E: Exception do
                  SHOWMESSAGE('Error Error:'+E.Message);
              end;
          end;
          Picture.Bitmap := msgBitMap;
        end;

          try
            msgBitMap.Free; //AAN Feb 25, 04
          except
          end;
    end;

  if ErrorReturned then
    begin
      btnOk.ModalResult := mrCancel;
      btnOk.Visible := True;
      btnCancel.Visible := False;
      btnAgree.Visible := False;
    end;

  Caption := 'Confirm Patient Selection';
  if (Patient.Messages.Count > 0) and (ErrorReturned = False) then
    Caption := Caption + ' - Please read notifications carefully';
  if (Patient.Messages.Count > 0) and (ErrorReturned = True) then
    Caption := Caption + ' - Unable to select this record';

end;

procedure TfrmGMV_PtSelect.btnAgreeClick(Sender: TObject);
begin
{
  CallRemoteProc(FBroker, 'GMV PTSELECT', ['LOGSECURITY', PatientDFN, 'RPCCALL^Clinical Procedure GUI v1'],
    nil,
    [rpcSilent,rpcNoResChk]
    );
}
  logPatientAccess(PatientDFN);

  btnOk.Enabled := True;
  btnOk.Default := True;
  btnOk.TabStop := True;
  btnAgree.Enabled := False;
  btnAgree.Default := False;
  btnAgree.TabStop := False;
  btnAgree.Caption := 'Access has been logged';
  btnOk.SetFocus;
end;

procedure TfrmGMV_PtSelect.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOK;
  fSelected := True;
  Close;
end;

procedure TfrmGMV_PtSelect.FormCreate(Sender: TObject);
begin
  fSelected := False;
end;

end.
