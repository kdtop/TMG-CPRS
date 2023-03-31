unit fPCEEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, uPCE, fBase508Form, VA508AccessibilityManager;

type
  TfrmPCEEdit = class(TfrmBase508Form)
    btnNew: TButton;
    btnNote: TButton;
    lblNew: TMemo;
    lblNote: TMemo;
    btnCancel: TButton;
    Label1: TStaticText;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//kt function EditPCEData(NoteData: TPCEData): boolean;
function EditPCEData(NoteData: TPCEData; InitialPageIndex : byte = 0): boolean;  //kt 5/16

implementation

uses uCore, rCore, fEncnt, fFrame, fEncounterFrame
     ,uTMGOptions;   //3/17/23;

{$R *.DFM}

const
  TX_NEED_VISIT2 = 'A visit is required before entering encounter information.';
  TX_NOPCE_TXT1  = 'the encounter date is in the future.';
  TX_NOPCE_TXT2  = 'encounter entry has been disabled.';
  TX_NOPCE_TXT   = 'You can not edit encounter information because ';
  TX_NOPCE_HDR   = 'Can not edit encounter';

var
  uPCETemp: TPCEData = nil;
  uPCETempOld: TPCEData = nil;
  uPatient: string = '';

//kt function EditPCEData(NoteData: TPCEData): boolean;   // Returns TRUE if NoteData is edited
function EditPCEData(NoteData: TPCEData; InitialPageIndex : byte = 0): boolean;   // Returns TRUE if NoteData is edited
var
  frmPCEEdit: TfrmPCEEdit;
  BtnTxt, NewTxt, txt: string;
  Ans: integer;

begin
  Result := FALSE;
  (* agp moved from FormCreate to addrss a problem with editing an encounter without a note displaying in CPRS*)
  if uPatient <> Patient.DFN then begin
    KillObj(@uPCETemp);
    KillObj(@uPCETempOld);
  end;
  uPatient := Patient.DFN;
  if (Encounter.VisitCategory = 'H') then begin
    if Assigned(NoteData) then begin
      Ans := mrNo
    end else begin
      InfoBox('Can not edit admission encounter', 'Error', MB_OK or MB_ICONERROR);
      Ans := mrCancel;
    end;
  end else if not Assigned(NoteData) then begin
    Ans := mrYes
  end else if (NoteData.VisitString = Encounter.VisitStr) then begin
    Ans := mrNo
  end else begin
    if uTMGOptions.ReadBool('AlwaysUseNoteEnc',False) then begin   //kt 3/17/23 added this if to force the form to always use note encounter by returning mrNo
      ans := mrNo;
    end else begin
      frmPCEEdit := TfrmPCEEdit.Create(Application);
      try
        if Encounter.NeedVisit then begin
          NewTxt := 'Create New Encounter';
          BtnTxt := 'New Encounter';
        end else begin
          NewTxt := 'Edit Encounter for ' + Encounter.LocationName + ' on ' +
                    FormatFMDateTime('mmm dd yyyy hh:nn', Encounter.DateTime);
          BtnTxt := 'Edit Current Encounter';
        end;
        frmPCEEdit.lblNew.Text := NewTxt;
        frmPCEEdit.btnNew.Caption := BtnTxt;
        frmPCEEdit.lblNote.Text := 'Edit Note Encounter for ' + ExternalName(NoteData.Location, 44) + ' on ' +
                    FormatFMDateTime('mmm dd yyyy hh:nn', NoteData.VisitDateTime);
        ans := frmPCEEdit.ShowModal;   //kt documentation: mrYes = btnNew, mrNo = btnNote, mrCancel = btnCancel
      finally
        frmPCEEdit.Free;
      end;
    end;
  end;
  if ans = mrYes then begin
    if Encounter.NeedVisit then begin
      UpdateVisit(8);
      frmFrame.DisplayEncounterText;
    end;
    if Encounter.NeedVisit then begin
      InfoBox(TX_NEED_VISIT2, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    if not assigned(uPCETemp) then begin
      uPCETemp := TPCEData.Create;
    end;
    uPCETemp.UseEncounter := True;
    if not CanEditPCE(uPCETemp) then begin
      if FutureEncounter(uPCETemp) then begin
        txt := TX_NOPCE_TXT1
      end else begin
        txt := TX_NOPCE_TXT2;
      end;
      InfoBox(TX_NOPCE_TXT + txt, TX_NOPCE_HDR, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    uPCETemp.PCEForNote(USE_CURRENT_VISITSTR, uPCETempOld);
    UpdatePCE(uPCETemp);
    if not assigned(uPCETempOld) then begin
      uPCETempOld := TPCEData.Create;
    end;
    uPCETemp.CopyPCEData(uPCETempOld);
  end else if ans = mrNo then begin
    //kt UpdatePCE(NoteData);
    UpdatePCE(NoteData, True, InitialPageIndex);  //kt 5/16
    Result := TRUE;
  {end else if ans = mrAll then begin  //TMG added 6/6/22
    uPCETemp := TPCEData.Create;
    uPCETemp.UseEncounter := True;
    if not CanEditPCE(uPCETemp) then begin
      if FutureEncounter(uPCETemp) then begin
        txt := TX_NOPCE_TXT1
      end else begin
        txt := TX_NOPCE_TXT2;
      end;
      InfoBox(TX_NOPCE_TXT + txt, TX_NOPCE_HDR, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    uPCETemp.PCEForNote(USE_OTHER_VISITSTR, uPCETempOld);
    UpdatePCE(uPCETemp);
    if not assigned(uPCETempOld) then begin
      uPCETempOld := TPCEData.Create;
    end;
    uPCETemp.CopyPCEData(uPCETempOld);  }
  end;
end;

procedure TfrmPCEEdit.Button1Click(Sender: TObject);
begin
  inherited;
  //Allow user to select from all visits

  //Set visit string
  //uPCE.OtherVisitStr := '6;3210122.131657;A';
  //Set ModalResult
  //modalresult := mrAll;
end;

procedure TfrmPCEEdit.FormCreate(Sender: TObject);
begin
  (* agp moved to EditPCEData procedure to addrss a problem
  with editing an encounter without a note displaying in CPRS
  if uPatient <> Patient.DFN then
    begin
      KillObj(@uPCETemp);
      KillObj(@uPCETempOld);
    end;
  uPatient := Patient.DFN;   *)
end;

initialization

finalization
  KillObj(@uPCETemp);
  KillObj(@uPCETempOld);
  uPatient := '';

end.
