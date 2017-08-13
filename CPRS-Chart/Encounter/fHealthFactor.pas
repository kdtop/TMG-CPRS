unit fHealthFactor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPtDiscreteData, uCore, fNotes,//kt 6/16
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmHealthFactors = class(TfrmPCEBaseMain)
    lblHealthLevel: TLabel;
    cboHealthLevel: TORComboBox;
    btnEditDiscreteData: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnEditDiscreteDataClick(Sender: TObject);

    procedure cboHealthLevelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function HasDiscreteData: boolean;  //kt added 6/16
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

var
  frmHealthFactors: TfrmHealthFactors;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter
  , rTemplates  //kt added 6/16
  ;

procedure TfrmHealthFactors.btnEditDiscreteDataClick(Sender: TObject);
//kt added entire function 6/16
var
  frmPtDiscreteData: TfrmPtDiscreteData;
  AVisitStr,IEN8925 : string;
begin
  inherited;
  frmPtDiscreteData := TfrmPtDiscreteData.Create(Self);
  AVisitStr := fEncounterFrame.uEncPCEData.VisitString;
  IEN8925 := frmNotes.GetCurrentNoteIEN;

  frmPtDiscreteData.Initialize(Patient.DFN, AVisitStr, IEN8925);
  frmPtDiscreteData.ShowModal;
  frmPtDiscreteData.Free;
end;

procedure tfrmHealthFactors.cboHealthLevelChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboHealthLevel.Text <> '') then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      if(lbGrid.Selected[i]) then
        TPCEPat(lbGrid.Items.Objects[i]).Level := cboHealthLevel.ItemID;
    GridChanged;
  end;
end;

procedure TfrmHealthFactors.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_HlthNm;
  FPCEListCodesProc := ListHealthCodes;
  FPCEItemClass := TPCEHealth;
  FPCECode := 'HF';
  PCELoadORCombo(cboHealthLevel);
end;

function TfrmHealthFactors.HasDiscreteData: boolean;
//kt added entire function 6/16
begin
  Result := rTemplates.HasDBFieldsData(Patient.DFN, fEncounterFrame.uEncPCEData.VisitString);
end;

procedure TfrmHealthFactors.FormShow(Sender: TObject);
//kt added
begin
  inherited;
  btnEditDiscreteData.Enabled := HasDiscreteData;  //kt added 6/16
end;

procedure TfrmHealthFactors.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumHFLevel, NoPCEValue);
end;

procedure TfrmHealthFactors.UpdateControls;
var
  ok, First: boolean;
  SameHL: boolean;
  i: integer;
  HL: string;
  Obj: TPCEHealth;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lbGrid.SelCount > 0);
      lblHealthLevel.Enabled := ok;
      cboHealthLevel.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameHL := TRUE;
        HL := NoPCEValue;
        for i := 0 to lbGrid.Items.Count-1 do
        begin
          if lbGrid.Selected[i] then
          begin
            Obj := TPCEHealth(lbGrid.Items.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              HL := Obj.Level;
            end
            else
            begin
              if(SameHL) then
                SameHL := (HL = Obj.Level);
            end;
          end;
        end;
        if(SameHL) then
          cboHealthLevel.SelectByID(HL)
        else
          cboHealthLevel.Text := '';
      end
      else
      begin
        cboHealthLevel.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmHealthFactors);

end.
