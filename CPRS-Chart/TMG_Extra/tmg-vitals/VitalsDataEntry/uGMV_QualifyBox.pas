unit uGMV_QualifyBox;

interface
uses
  CheckLst
  ,StdCtrls
  ,ExtCtrls
  ,Controls
  ,Classes
  ;

Type
  TGMV_TemplateQualifierBox = class(TPanel)
  private
    FDefaultQualifierName: string;
    FVitalIEN: string;
    FDefaultQualifierIEN: string;
    FCategoryIEN: string;
    FLabel: TLabel;
    FCheckListBox: TCheckListBox;
    procedure SetCategoryIEN(const Value: string);
    procedure SetDefaultQualifierIEN(const Value: string);
    procedure SetDefaultQualifierName(const Value: string);
    procedure SetVitalIEN(const Value: string);
//    procedure OnQualClick(Sender: TObject);
    procedure OnQualEnter(Sender: TObject);
    procedure OnQualExit(Sender: TObject);
  public
//    constructor CreateParented(Broker: TRPCBroker; Owner: TPanel; VitalIEN, CategoryIEN, DefaultIEN: string);
    constructor CreateParented(Owner: TPanel; VitalIEN, CategoryIEN, DefaultIEN: string);
//    destructor Destroy; override;
    function LabelCaption:String;
  published
    property CLB: TCheckListBox read fCheckListBox;
    procedure OnQualClick(Sender: TObject);

    property VitalIEN: string read FVitalIEN write SetVitalIEN;
    property CategoryIEN: string read FCategoryIEN write SetCategoryIEN;
    property DefaultQualifierIEN: string
      read FDefaultQualifierIEN write SetDefaultQualifierIEN;
    property DefaultQualifierName: string
      read FDefaultQualifierName write SetDefaultQualifierName;

    procedure setQualifierByName(aName:String);
    procedure setQualifierByID(anIDe:String);
  end;

implementation

uses
  uGMV_Utils
  , Graphics
  , SysUtils
  , uGMV_FileEntry
  , uGMV_Const, uGMV_Common, uGMV_Engine
  ;


{ TGMV_TemplateQualifierBox }

//constructor TGMV_TemplateQualifierBox.CreateParented(Broker: TRPCBroker; Owner: TPanel; VitalIEN, CategoryIEN, DefaultIEN: string);
constructor TGMV_TemplateQualifierBox.CreateParented(Owner: TPanel; VitalIEN, CategoryIEN, DefaultIEN: string);
var
  i: integer;
  SL: TStringList;
begin
  inherited Create(Owner);
  Visible := False;
  Parent := Owner;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BorderWidth := 2;
  FVitalIEN := VitalIEN;
  FCategoryIEN := CategoryIEN;
  FDefaultQualifierName := DefaultIEN;
  FLabel := TLabel.Create(Self);
  with FLabel do
    begin
      Parent := Self;
      Align := alTop;
      Alignment := taCenter;
      Caption := TitleCase(GMVCats.Entries[GMVCats.IndexOfIEN(CategoryIEN)]);
    end;
  FCheckListBox := TCheckListBox.Create(Self);
  with FCheckListBox do
    begin
      Parent := Self;
      Align := alClient;

{      CallRemoteProc(Broker, RPC_MANAGER, ['GETQUAL', VitalIEN + ';' + CategoryIEN], nil,[], nil);
      Items.Add('-None-');
      for i := 1 to Broker.Results.Count - 1 do
        Items.AddObject(TitleCase(Piece(Broker.Results[i], '^', 2)), Pointer(StrToIntDef(Piece(Broker.Results[i], '^', 1), 0)));
}
      SL := getQualifiers(VitalIEN,CategoryIEN);
      Items.Add('-None-');
      for i := 1 to SL.Count - 1 do
        Items.AddObject(TitleCase(Piece(SL[i], '^', 2)), Pointer(StrToIntDef(Piece(SL[i], '^', 1), 0)));
      SL.Free;

      ItemIndex := 0;
      Checked[0] := True;
      OnClickCheck := OnQualClick;
      OnEnter := OnQualEnter;
      OnExit := OnQualExit;
    end;
end;

//destructor TGMV_TemplateQualifierBox.Destroy;
//begin
//  inherited;
//end;

function TGMV_TemplateQualifierBox.LabelCaption:String;
begin
  try
    result := FLabel.Caption;
  except
    result := '';
  end;
end;

procedure TGMV_TemplateQualifierBox.OnQualEnter(Sender: TObject);
begin
  Flabel.Font.Style := [fsBold];
  FCheckListBox.Color := clInfoBk;
end;

procedure TGMV_TemplateQualifierBox.OnQualExit(Sender: TObject);
begin
  Flabel.Font.Style := [];
  FCheckListBox.Color := clWindow;
end;

procedure TGMV_TemplateQualifierBox.OnQualClick(Sender: TObject);
var
  k, i: integer;
begin
  with TCheckListBox(Sender) do
    begin
      k := 0;
      for i := 0 to Items.Count - 1 do
        begin
          if i <> ItemIndex then
            Checked[i] := False;
          if Checked[i] then k := i;
        end;
      ItemIndex := k;//AAn 07/22/2002
      Checked[k] := True; //AAN 07/22/2002 -- One line should always be selected
      FDefaultQualifierName := Items[ItemIndex];
      FDefaultQualifierIEN := IntToStr(integer(Items.Objects[ItemIndex]));
    end;
  Self.OnClick(Self);
end;

procedure TGMV_TemplateQualifierBox.SetCategoryIEN(const Value: string);
begin
  FCategoryIEN := Value;
end;

procedure TGMV_TemplateQualifierBox.SetDefaultQualifierIEN(const Value: string);
var
  i: integer;
begin
  for i := 0 to FCheckListBox.Items.Count - 1 do
    FCheckListBox.Checked[i] := False;
  FCheckListBox.ItemIndex := -1;
  FDefaultQualifierIEN := '-1';
  i := GMVQuals.IndexOfIEN(Value);
  if i > -1 then
    begin
      i := FCheckListBox.Items.IndexOf(GMVQuals.Entries[i]);
      if i > -1 then
        begin
          FCheckListBox.ItemIndex := i;
          FCheckListBox.Checked[i] := True;
          FDefaultQualifierIEN := Value;
          FDefaultQualifierName := FCheckListBox.Items[i];
        end;
    end;
end;

procedure TGMV_TemplateQualifierBox.SetDefaultQualifierName(const Value: string);
begin
  FDefaultQualifierName := Value;
end;

procedure TGMV_TemplateQualifierBox.SetVitalIEN(const Value: string);
begin
  FVitalIEN := Value;
end;

procedure TGMV_TemplateQualifierBox.setQualifierByName(aName:String);
begin
end;

procedure TGMV_TemplateQualifierBox.setQualifierByID(anIDe:String);
begin
end;

end.
