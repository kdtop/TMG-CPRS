unit fGMV_PtSelect;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 5/21/03 1:19p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
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
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_PtSelect.pas $
*
* $History: fGMV_PtSelect.pas $
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
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 12:02p
 * Created in $/Vitals GUI Version 5.0/Vitals User
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
  ExtCtrls,
  TRPCB;

function PatientSelect(Broker: TRPCBroker; DFN: string): Boolean;

type
  TMessageLevel = (mlError, mlInfo, mlWarning, mlSecurity);

type
  TPatient = class(TObject)
  private
    FDFN: string;
    FIdentifiers: TList;
    FMessages: TList;
    FSensitive: Boolean;
    procedure SetSensitive(NewVal: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property DFN: string
      read FDFN write FDFN;
    property Identifiers: TList
      read FIdentifiers write FIdentifiers;
    property Messages: TList
      read FMessages write FMessages;
    property Sensitive: Boolean
      read FSensitive write SetSensitive;
  end;

type
  TPtIdentifier = class(TObject)
  private
    FCaption: string;
    FDisplayNonSensitive: string;
    FDisplaySensitive: string;
    FDisplayLabel: TLabel;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Caption: string
      read FCaption write FCaption;
    property DisplayNonSensitive: string
      read FDisplayNonSensitive write FDisplayNonSensitive;
    property DisplaySensitive: string
      read FDisplaySensitive write FDisplaySensitive;
    property DisplayLabel: TLabel
      read FDisplayLabel write FDisplayLabel;
  end;

type
  TPtMessage = class(TObject)
  protected
    FLevel: TMessageLevel;
    FHeader: string;
    FText: TStringList;
    FPanel: TPanel;
  public
    constructor Create(Level: TMessageLevel; HeaderText: string);
    destructor Destroy; override;
    property MessageLevel: TMessageLevel
      read FLevel write FLevel;
    property Header: string
      read FHeader write FHeader;
    property Text: TStringList
      read FText write FText;
    property Panel: TPanel
      read FPanel write FPanel;
  end;

type
  TfrmGMV_PtSelect = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    pnlPtInfo: TPanel;
    btnAgree: TButton;
    procedure btnAgreeClick(Sender: TObject);
  private
    FBroker: TRPCBroker;
    procedure LoadPatient(Patient: TPatient);
    procedure LoadMessages(Patient: TPatient);
  end;

var
  CurrentPatient: TPatient;

implementation

uses
  uGMV_Common;

{$R *.DFM}
{$R RGMV_PTSELECT.RES}

function PatientSelect(Broker: TRPCBroker; DFN: string): Boolean;
var
  i: Integer;
  Patient: TPatient;
  PtID: TPtIdentifier;
  PtMsg: TPtMessage;
  PtResults: TStringList;
begin
  {Create Patient Object}
  Patient := TPatient.Create;
  Patient.DFN := DFN;
  Patient.Sensitive := False;
  CurrentPatient := Patient;

  PtResults := TStringList.Create;
  CallServer(Broker, 'GMV PTSELECT', ['SELECT', DFN], nil, PtResults);

  try
    {Build the Patient Identifiers}
    i := 0;
    while i < PtResults.Count do
      begin
        if Piece(PtResults[i], '^', 1) = '$$PTID' then
          begin
            PtId := TPtIdentifier.Create;
            PtId.Caption := TitleCase(Piece(PtResults[i], '^', 2));
            PtId.DisplayNonSensitive := Piece(PtResults[i], '^', 3);
            PtId.DisplaySensitive := Piece(PtResults[i], '^', 4);
            if PtId.DisplaySensitive = '' then
              PtId.DisplaySensitive := PtId.DisplayNonSensitive;
            Patient.Identifiers.Add(ptId);
          end;
        inc(i);
      end;

    {Load any messages}
    i := 0;
    while i < PtResults.Count - 1 do
      begin
        if Piece(PtResults[i], '^', 1) = '$$MSGHDR' then
          begin
            case StrToIntDef(Piece(PtResults[i], '^', 2), -1) of
              0: PtMsg := TPtMessage.Create(mlError, Piece(PtResults[i], '^', 3));
              1: PtMsg := TPtMessage.Create(mlInfo, Piece(PtResults[i], '^', 3));
              2: PtMsg := TPtMessage.Create(mlWarning, Piece(PtResults[i], '^', 3));
              3:
                begin
                  PtMsg := TPtMessage.Create(mlSecurity, Piece(PtResults[i], '^', 3));
                  Patient.Sensitive := True;
                end;
            else
              PtMsg := TPtMessage.Create(mlInfo, Piece(PtResults[i], '^', 3));
            end;

            inc(i);

            while (i < PtResults.Count - 1) and
              (Piece(PtResults[i], '^', 1) <> '$$MSGEND') do
              begin
                ptMsg.Text.Add(PtResults[i]);
                inc(i);
              end;
            Patient.Messages.Add(PtMsg);
          end;
        inc(i);
      end;

    with TfrmGMV_PtSelect.Create(Application) do
      begin
        LoadPatient(Patient);
        LoadMessages(Patient);
        Position := poDesktopCenter;
        FBroker := Broker;
        showmodal;
        if ModalResult = mrOk then
          PatientSelect := True
        else
          PatientSelect := False;
      end;
  finally
    Patient.free;
  end;

end;

//* TPtMessage *//

constructor TPtMessage.Create(Level: TMessageLevel; HeaderText: string);
begin
  FText := TStringList.Create;
  FLevel := Level;
  FHeader := HeaderText;
end;

destructor TPtMessage.Destroy;
begin
  FText.Clear;
  FText.free;
end;

//* TPtIdentifier *//

constructor TPtIdentifier.Create;
begin
  inherited Create;
end;

destructor TPtIdentifier.Destroy;
begin
  inherited Destroy;
end;

//* TPatient *//

constructor TPatient.Create;
begin
  inherited Create;
  FIdentifiers := TList.Create;
  FMessages := TList.Create;
end;

destructor TPatient.Destroy;
begin

  while FIdentifiers.Count > 0 do
    begin
      TPtIdentifier(FIdentifiers[0]).free;
      FIdentifiers.Delete(0);
    end;
  FIdentifiers.free;

  while FMessages.Count > 0 do
    begin
      TPtMessage(FMessages[0]).free;
      FMessages.Delete(0);
    end;
  FMessages.free;

  inherited Destroy;

end;

procedure TPatient.SetSensitive(NewVal: Boolean);
var
  i: Integer;
begin
  FSensitive := NewVal;
  for i := 0 to Self.FIdentifiers.Count - 1 do
    with TPtIdentifier(Self.FIdentifiers[i]) do
      case NewVal of
        True: DisplayLabel.Caption := DisplaySensitive;
        False: DisplayLabel.Caption := DisplayNonSensitive;
      end;
end;

//* TfrmPtSelect *//

procedure TfrmGMV_PtSelect.LoadPatient(Patient: TPatient);
var
  i: Integer;
  PtId: TPtIdentifier;
begin
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
  msgBitMap := TBitMap.Create;
  msgBitMap.Transparent := True;
  msgBitMap.TransparentMode := tmAuto;

  for i := 0 to Patient.Messages.Count - 1 do
    begin
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
            mlInfo: msgBitMap.LoadFromResourceName(HInstance, 'MLINFO');
            mlWarning: msgBitmap.LoadFromResourceName(HInstance, 'MLWARNING');
            mlSecurity:
              begin
                msgBitmap.LoadFromResourceName(HInstance, 'MLSECURITY');
                btnOk.Enabled := False;
                btnOk.TabStop := False;
                btnOk.Default := False;
                btnAgree.Visible := True;
                btnAgree.TabStop := True;
              end;
            mlError:
              begin
                msgBitmap.LoadFromResourceName(HInstance, 'MLERROR');
                btnOk.ModalResult := mrCancel;
                btnCancel.Visible := False;
                ErrorReturned := True;
              end;
          end;
          Picture.Bitmap := msgBitMap;
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
  CallServer(FBroker, 'GMV PTSELECT', ['LOGSECURITY', CurrentPatient.DFN, 'RPCCALL^Clinical Procedure GUI v1'], nil);
  btnOk.Enabled := True;
  btnOk.Default := True;
  btnOk.TabStop := True;
  btnAgree.Enabled := False;
  btnAgree.Default := False;
  btnAgree.TabStop := False;
  btnAgree.Caption := 'Access has been logged';
  CurrentPatient.Sensitive := False;
  btnOk.SetFocus;
end;

end.
