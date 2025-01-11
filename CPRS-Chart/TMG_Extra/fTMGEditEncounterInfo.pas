unit fTMGEditEncounterInfo;
//kt ADDED 4/30/23

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ORFn;

type
  TfrmTMGEditEncounterInfo = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblICDCodeLabel: TLabel;
    lblICDCodeValue: TLabel;
    lblICDCodeSysLabel: TLabel;
    lblICDCodeSysValue: TLabel;
    lblDisplayNameLabel: TLabel;
    edtDisplayName: TEdit;
    lblICDCodeNameLabel: TLabel;
    lblICDCodeNameValue: TLabel;
    procedure edtDisplayNameChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    InitData : string;
    procedure DataToDisplay();
  public
    { Public declarations }
    ResultDataStr : TDataStr;
    procedure Initialize(DataStr : TDataStr);
    function Modified : boolean;
  end;

//var
  //frmTMGEditEncounterDx: TfrmTMGEditEncounterDx;  //not automatically instantiated

implementation

{$R *.dfm}

uses
  fTMGEncounterICDPicker
  //fTopicICDLinkerU
  ;

procedure TfrmTMGEditEncounterInfo.FormCreate(Sender: TObject);
begin
  ResultDataStr := TDataStr.Create(ENCOUNTER_ICD_FORMAT);
end;

procedure TfrmTMGEditEncounterInfo.FormDestroy(Sender: TObject);
begin
  ResultDataStr.Free;
end;

function TfrmTMGEditEncounterInfo.Modified : boolean;
begin
  Result := (ResultDataStr.DataStr <> InitData);
end;

procedure TfrmTMGEditEncounterInfo.edtDisplayNameChange(Sender: TObject);
//DisplayToData
begin
  ResultDataStr.Value['DisplayName'] := edtDisplayName.Text;
end;

procedure TfrmTMGEditEncounterInfo.DataToDisplay();
//NOTE: ResultDataStr format is expected to be: ENCOUNTER_ICD_FORMAT = 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys' //e.g. 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
begin
  lblICDCodeValue.Caption     := ResultDataStr.Value['ICDCode'];
  lblICDCodeNameValue.Caption := ResultDataStr.Value['ICDLongName'];
  lblICDCodeSysValue.Caption  := ResultDataStr.Value['ICDCodeSys'];
  edtDisplayName.Text         := ResultDataStr.Value['DisplayName'];
end;

procedure TfrmTMGEditEncounterInfo.Initialize(DataStr : TDataStr);
//NOTE: TDataStr format is expected to be: ENCOUNTER_ICD_FORMAT = 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys' //e.g. 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"

begin
  ResultDataStr.Assign(DataStr);
  InitData := ResultDataStr.DataStr;
  DataToDisplay();
end;


end.
