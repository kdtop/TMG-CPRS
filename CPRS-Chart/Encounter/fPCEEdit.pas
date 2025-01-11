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

//kt 5/16  function EditPCEData(NoteData: TPCEData): boolean;
function EditPCEData(NoteData: TPCEData; InitialPageIndex : byte = 0): boolean;
function EditPCEDataNonModal(NoteData: TPCEData; CallBackProcs : TNotifyPCEEventList; InitialPageIndex : byte = 0): boolean;


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

//kt var
  //kt moving into EditPCEData --> uPCETemp: TPCEData = nil;
  //kt moving into EditPCEData --> uPCETempOld: TPCEData = nil;
  //kt uPatient: string = '';


function AskWhichEncounter(NoteData: TPCEData) : integer;
//kt added, splitting out code from EditPCEData
//NOTE: for result
//   [Edit Current Encounter] --> mrYes
//   [Edit Note Encounter] --> mrNo
//   [Edit Other Encounter] --> mrNone
//   [Cancel] --> mrCancel
//
var
  Ans: integer;
  BtnTxt, NewTxt: string;
  frmPCEEdit: TfrmPCEEdit;

begin
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
  result := ans;
end;


//kt function EditPCEData(NoteData: TPCEData): boolean;   // Returns TRUE if NoteData is edited
function EditPCEData(NoteData: TPCEData; InitialPageIndex : byte = 0): boolean;   // Returns TRUE if NoteData is edited
var
  //frmPCEEdit: TfrmPCEEdit;
  //BtnTxt, NewTxt, txt: string;
  txt: string;
  Ans: integer;
  PCETemp: TPCEData;  //kt
  PCEToBeEdited: TPCEData;  //kt
begin
  Result := FALSE;
  (* agp moved from FormCreate to addrss a problem with editing an encounter without a note displaying in CPRS*)
  {//kt
  if uPatient <> Patient.DFN then begin
    KillObj(@uPCETemp);
    KillObj(@uPCETempOld);
  end;
  uPatient := Patient.DFN;
  }
  PCEToBeEdited := nil; //kt

  ans := AskWhichEncounter(NoteData); //kt
  {//kt moved to separate function
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
  }
  PCETemp := TPCEData.Create;  //kt
  //   [Edit Current Encounter] --> mrYes
  //   [Edit Note Encounter] --> mrNo
  //   [Edit Other Encounter] --> mrNone
  //   [Cancel] --> mrCancel
  try
    if ans = mrYes then begin //[Edit Current Encounter] --> mrYes
      if Encounter.NeedVisit then begin
        UpdateVisit(8);
        frmFrame.DisplayEncounterText;
      end;
      if Encounter.NeedVisit then begin
        InfoBox(TX_NEED_VISIT2, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
        Exit;
      end;
      //kt if not assigned(uPCETemp) then begin
      //kt  uPCETemp := TPCEData.Create;
      //kt end;
      PCETemp.UseEncounter := True;  //kt was uPCETemp
      if not CanEditPCE(PCETemp) then begin //kt was uPCETemp
        if FutureEncounter(PCETemp) then begin //kt was uPCETemp
          txt := TX_NOPCE_TXT1
        end else begin
          txt := TX_NOPCE_TXT2;
        end;
        InfoBox(TX_NOPCE_TXT + txt, TX_NOPCE_HDR, MB_OK or MB_ICONWARNING);
        Exit;
      end;
      //kt uPCETemp.PCEForNote(USE_CURRENT_VISITSTR, uPCETempOld);
      PCETemp.PCEForNote(USE_CURRENT_VISITSTR, nil);  //kt was uPCETemp, and removing reuse of prior PCE
      PCEToBeEdited := PCETemp;
      //kt --> moving UpdatePCE() to common part below.
      //kt UpdatePCE(PCETemp, True, InitialPageIndex);  //kt was uPCETemp
      {//kt  -- If PCE is edited more than once, then saving off last edit will reduce
                server load by using locally saved data.  However, it requires the
                use of globally scoped variables, making state more complex.
                So will removed.
      if not assigned(uPCETempOld) then begin
        uPCETempOld := TPCEData.Create;
      end;
      //kt PCETemp.CopyPCEData(uPCETempOld);   //kt was uPCETemp
      uPCETempOld.Assign(PCETemp);
      }
    end else if ans = mrNo then begin    //   [Edit Note Encounter] --> mrNo
      //kt UpdatePCE(NoteData);
      PCEToBeEdited := NoteData; //kt
      //kt --> moving UpdatePCE() to common part below.
      //kt UpdatePCE(NoteData, True, InitialPageIndex);  //kt 5/16
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
    if assigned(PCEToBeEdited) then begin
      UpdatePCE(PCEToBeEdited, True, InitialPageIndex);  //kt 5/16
    end;
  finally
    PCETemp.Free;  //kt
  end;
end;

procedure HandleUpdatePCEDone(PCEData: TPCEData; CallBackProcs : TNotifyPCEEventList);  //kt added
//callback handler for EditPCEDataNonModal() which calls UpdatePCENonModal()
var
  i : integer;
  TempPCEObj: TPCEData;
begin
  //i := CallBackProcs.Count - 1;  if i<0 then exit;
  TempPCEObj := TPCEData(CallBackProcs.GetAndRemoveData('EditPCEData.TempPCE'));
  if Assigned(TempPCEObj) then begin
    //uPCEEdit.Assign(TempPCEObj);
    TempPCEObj.Free;
  end;
  CallBackProcs.PopAndCall(PCEData);
end;

function EditPCEDataNonModal(NoteData: TPCEData; CallBackProcs : TNotifyPCEEventList; InitialPageIndex : byte = 0): boolean;   // Returns TRUE if NoteData is edited
var
  //frmPCEEdit: TfrmPCEEdit;
  txt: string;
  Ans: integer;
  PCEToBeEdited: TPCEData;  //kt
  TempPCE : TPCEData;

begin
  Result := FALSE;
  CallBackProcs.AddObject('CALLER=EditPCEDataNonModal', @HandleUpdatePCEdone);
  PCEToBeEdited := nil; //kt
  ans := AskWhichEncounter(NoteData); //kt
  if ans = mrYes then begin
    if Encounter.NeedVisit then begin
      UpdateVisit(8);
      frmFrame.DisplayEncounterText;
    end;
    if Encounter.NeedVisit then begin
      InfoBox(TX_NEED_VISIT2, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
      CallBackProcs.PopAndCall(nil);
      Exit;
    end;
    TempPCE := TPCEData.Create;  //owned by CallBackProcs
    CallBackProcs.AddObject('DATA=EditPCEData.TempPCE',TempPCE);
    TempPCE.UseEncounter := True;
    if not CanEditPCE(TempPCE) then begin
      if FutureEncounter(TempPCE) then begin
        txt := TX_NOPCE_TXT1
      end else begin
        txt := TX_NOPCE_TXT2;
      end;
      InfoBox(TX_NOPCE_TXT + txt, TX_NOPCE_HDR, MB_OK or MB_ICONWARNING);
      CallBackProcs.PopAndCall(nil);
      Exit;
    end;
    TempPCE.PCEForNote(USE_CURRENT_VISITSTR, nil);
    PCEToBeEdited := TempPCE;
  end else if ans = mrNo then begin
    PCEToBeEdited := NoteData; //kt
    Result := TRUE;
  end;
  if assigned(PCEToBeEdited) then begin
    UpdatePCENonModal(PCEToBeEdited, CallBackProcs, True, InitialPageIndex);  //kt 5/16
  end else begin
    CallBackProcs.PopAndCall(nil);
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
  {//kt
  KillObj(@uPCETemp);
  KillObj(@uPCETempOld);
  uPatient := '';
  }

end.
