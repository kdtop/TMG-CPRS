unit fLabPicker;

//kt added entire form and unit on 2/2017

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Buttons, CheckLst, fLabs, ORFn;

type
  TfrmLabPicker = class(TForm)
    cblData: TCheckListBox;   //cblData.Items should have 1:1 relationship to FSourceData
    btnCheckAll: TBitBtn;
    btnCheckNone: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnCheckAbns: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCheckAbnsClick(Sender: TObject);
    procedure btnCheckNoneClick(Sender: TObject);
    procedure btnCheckAllClick(Sender: TObject);
  private
    { Private declarations }
    FSourceData : TStringList;  //this should have 1:1 relationship to cblData.Items
    FSourceNotes : TStringList;
    FNotesIndex : integer;
  public
    { Public declarations }
    procedure Initialize(LabInfo : tLabsInfoRec);
    procedure GetResults(var LabInfo : tLabsInfoRec);
  end;

//var
//  frmLabPicker: TfrmLabPicker;  //NOT autocreated

implementation

{$R *.dfm}

const
  TAG_NOTES = '[Notes]: ';

procedure TfrmLabPicker.btnCheckAbnsClick(Sender: TObject);
var i : integer;
    SourceStr : string;
begin
  for i := 0 to FSourceData.Count-1 do begin
    SourceStr := FSourceData.Strings[i];  // 'LabName^LabValue^Flags^Units^ReferenceRange'
    if i = FNotesIndex then continue;
    //if Pos(TAG_NOTES, SourceStr) > 0 then continue;
    if piece(SourceStr,'^',3) = '' then continue;
    if i >= cblData.Items.Count then break;
    cblData.Checked[i] := true;
  end;
end;

procedure TfrmLabPicker.btnCheckAllClick(Sender: TObject);
var i : integer;
begin
  //check all
  for i := 0 to cblData.Items.Count-1 do begin
    cblData.Checked[i] := true;
  end;
end;

procedure TfrmLabPicker.btnCheckNoneClick(Sender: TObject);
var i : integer;
begin
  //uncheck all
  for i := 0 to cblData.Items.Count-1 do begin
    cblData.Checked[i] := false;
  end;
end;

procedure TfrmLabPicker.FormCreate(Sender: TObject);
begin
  FSourceData := TStringList.Create;
  FSourceNotes := TStringList.Create;
  FNotesIndex := -1;
end;

procedure TfrmLabPicker.FormDestroy(Sender: TObject);
begin
  FSourceData.Free;
  FSourceNotes.Free;
end;

procedure TfrmLabPicker.Initialize(LabInfo : tLabsInfoRec);
var i : integer;
    AddStr, s : string;
    ColW : array[1..4] of integer;

  function PadStr(s : string; Len : integer) : string;
  begin
    Result := s;
    while length(Result) < Len do Result := Result + ' ';
  end;

  function MaxWidth(PieceNum : integer; InitW : integer) : integer;
  var Len, i : integer;
      s : string;
  begin
    Result := InitW;
    for i := 0 to LabInfo.Data.Count - 1 do begin
      s := LabInfo.Data.Strings[i];
      Len := length(piece(s,'^',PieceNum));
      if Len > Result then Result := Len;
    end;
  end;

begin
  if assigned(LabInfo.Data) then begin
    FSourceData.Assign(LabInfo.Data);
    cblData.Items.Clear;
    if assigned(LabInfo.Data) then begin
      ColW[1] := 10; ColW[2] := 5; ColW[3] := 2; ColW[4] := 10;
      for i := 1 to 4 do ColW[i] := MaxWidth(i, ColW[i]);
      for i := 0 to LabInfo.Data.Count - 1 do begin
        s := LabInfo.Data.Strings[i];
        AddStr := PadStr(piece(s, '^', 1), ColW[1]+2)  +
                  PadStr(piece(s, '^', 2), ColW[2]+2)  +
                  PadStr(piece(s, '^', 3), ColW[3]+2)  +
                  PadStr(piece(s, '^', 4), ColW[4]+2);
        cblData.Items.Add(AddStr);
      end;
    end;
  end else begin
    FSourceData.Clear;
  end;
  if assigned(LabInfo.Notes) then begin
    FSourceNotes.Assign(LabInfo.Notes);
    AddStr := Trim(AnsiReplaceStr(LabInfo.Notes.Text, #13#10, ' '));
    AddStr := TAG_NOTES + LeftStr(AddStr, 40) + '...';
    FNotesIndex := cblData.Items.Add(AddStr);
  end else begin
    FSourceNotes.Clear;
  end;

end;


procedure TfrmLabPicker.GetResults(var LabInfo : tLabsInfoRec);
var i : integer;
begin
  if assigned(LabInfo.Data) then begin
    LabInfo.Data.Clear;
    for i := 0 to cblData.Items.Count - 1 do begin
      if not cblData.Checked[i] then continue;
      if i = FNotesIndex then continue;
      LabInfo.Data.Add(FSourceData.Strings[i]);
    end;
  end;
  if assigned(LabInfo.Notes) then begin
    if (FNotesIndex > -1) and cblData.Checked[FNotesIndex] then begin
      LabInfo.Notes.Assign(FSourceNotes);
    end else begin
      LabInfo.Notes.Clear;
    end;
  end;
end;


end.

