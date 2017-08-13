unit fLetterWriter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Menus, fDrawers,
  Dialogs, ExtCtrls, StdCtrls, ORCtrls, Buttons, ORNet, ORFn, StrUtils, uCore, TRPCB, uConst, rTIU, uTIU, ComCtrls,
  fBase508Form, VA508AccessibilityManager;

type
  TfrmLetterWriter = class(TfrmBase508Form)
    pnlLeft: TPanel;
    pnlRight: TPanel;
    memoLetterText: TMemo;
    Splitter1: TSplitter;
    btnPrint: TBitBtn;
    btnEditForm: TBitBtn;
    Label1: TLabel;
    cbFormLetters: TORComboBox;
    pnlLeftTop: TPanel;
    pnlLeftBottom: TPanel;
    Splitter2: TSplitter;
    Label2: TLabel;
    cboSelPatientList: TORComboBox;
    pnlPtSelDisplay: TPanel;
    lblNumSelected: TLabel;
    btnNew: TBitBtn;
    lblSelList: TLabel;
    pnlRightBottom: TPanel;
    pnlRightTop: TPanel;
    FontDialog: TFontDialog;
    btnFont: TBitBtn;
    lblPreviewFor: TLabel;
    lblPtName: TLabel;
    btnPrevPt: TBitBtn;
    btnNextPt: TBitBtn;
    btnCancel: TBitBtn;
    btnShowPrintingList: TSpeedButton;
    cboPatientListType: TORComboBox;
    procedure btnPrintClick(Sender: TObject);
    procedure btnShowPrintingListClick(Sender: TObject);
    procedure btnNextPtClick(Sender: TObject);
    procedure btnPrevPtClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure cboSelPatientListChange(Sender: TObject);
    procedure cbFormLettersChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboPatientListTypeChange(Sender: TObject);
    procedure btnEditFormClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FLetterList : TStringList;
    FListOfPatientLists : TStringList;
    FPatientList : TStringList;
    FPreviewPtIndex : integer;
    FCurrentBoilerplate : TStringList;
    FCurrentBoilerplateIEN : string;
    //dlgWinPrinter: TPrintDialog;
    procedure DisplayCurrentPreview;
    procedure SetPreviewIndex(Value : integer);
    //procedure InitORComboBox(ORComboBox : TORComboBox; initValue : string);
    procedure InitcbFormLetters(InitValue : string);
    function OrderIndexOf(Value : string; SL : TStringList; Pce : integer = 1) : integer;
    procedure LoadCBListType;
    procedure PrintList(PatientList: TStringList);
    procedure DisplayPatientListChange;
    //procedure PrintOneNote(NoteIEN : integer);
  public
    { Public declarations }
  end;

var
  frmLetterWriter: TfrmLetterWriter;
  mnuPrintFormLetters : TMenuItem;  //will be inserted into FFrame main menu.

implementation

uses
  fLetterEditor,rTemplates, uCarePlan, rLetters, rCarePlans, fFrame, fNoteProps,
  fTemplateEditor, uTemplates, fNotes, fLetterShowPatientList, fSignItem, fNotePrt, rReports, uReports;
{$R *.dfm}

const
TX_ERR_CAP = 'Print Error';
  PAGE_BREAK = '**PAGE BREAK**';

  //-------------------------------------------------------------------------

  procedure TfrmLetterWriter.FormCreate(Sender: TObject);
  begin
    FLetterList := TStringList.Create;
    FListOfPatientLists := TStringList.Create;
    FPatientList := TStringList.Create;
    FCurrentBoilerplate := TStringList.Create;
  end;

  procedure TfrmLetterWriter.FormDestroy(Sender: TObject);
  begin
    ClearBackup;
    FLetterList.Free;
    FListOfPatientLists.Free;
    FPatientList.Free;
    FCurrentBoilerplate.Free;
  end;

  procedure TfrmLetterWriter.FormShow(Sender: TObject);
  begin
    InitcbFormLetters('A');
    LoadCBListType;
  end;

  procedure TfrmLetterWriter.LoadCBListType;
  var ListTypes : TStrings;
  begin
    cboPatientListType.clear;
    cboPatientListType.Pieces := '2';
    ListTypes := GetListTypes;
    FastAssign(ListTypes, cboPatientListType.Items);
    cboPatientListType.ItemIndex := 0;
   cboPatientListTypeChange(Self);
  end;

  procedure TfrmLetterWriter.InitcbFormLetters(InitValue : string);
  var i : integer;
  begin
    FLetterList.Clear;
    GetLetterList(FLetterList);
    cbFormLetters.Clear;
    FastAssign(FLetterList, cbFormLetters.Items);
    i := OrderIndexOf(InitValue, FLetterList, 2);
    if i = -1 then i := cbFormLetters.Items.Count - 1;
    if i>=0 then begin
      //cbFormLetters.SelectByIEN(StrToIntDef(Piece(FLetterList.Strings[i],'^',1),0));
      cbFormLetters.ItemIndex := i;
      cbFormLetters.Text := Piece(FLetterList.Strings[i],'^',2);
      cbFormLetters.OnChange(Self);
    end else begin
      cbFormLetters.ItemIndex := -1;
      cbFormLetters.Text := '';
    end;

  end;

  function TfrmLetterWriter.OrderIndexOf(Value : string; SL : TStringList; Pce : integer = 1) : integer;
  //Purpose: return the index of the first matching value, or if no exact match found then
  //         return the index value in list that would sort AFTER Value
  //Assumes that SL List is in alphabetical order
  //Pce is the piece to check each entry for.  E.g. if each line is '1234^DOE,JOHN' and Pce=2, then comparison is on name, not number
  //Result will be index (as desribed above), or -1 if Value would come at the END of the list.
  //E.g.    List--> alfa                 with Value = 'dapsone'
  //                bravo
  //                charley
  //                delta    <-- return index of this entry
  //                echo
  //                foxtrot
  var Comp,i : integer;
      OneVal : string;

  begin
    Result := -1;
    for i := 0 to SL.Count - 1 do begin
      OneVal := SL.Strings[i];
      OneVal := Piece(OneVal,'^',Pce);
      if Length(OneVal) > Length (Value) then begin
        OneVal := LeftStr(OneVal,Length(Value));
      end;
      Comp := CompareText(Value,OneVal);
      if (Comp<=0) then begin  //Value <= OneVal
        Result := i;
        break;
      end else if (Comp>0) then begin  //Value > OneVal
        Result := i-1;
        break;
      end;
    end;
  end;

  procedure TfrmLetterWriter.btnAddClick(Sender: TObject);
  var NewName : string;
      ExpandStr, SelectStr : string;
  begin
    NewName := InputBox('New Name','Please enter name for new letter template','');
    if NewName = '' then exit;
    ExpandStr := '';  SelectStr := '';
    EditTemplates(Self, false, NewName, false, ExpandStr,SelectStr, cptemLetter, nil);
    if assigned(frmNotes.Drawers) then frmNotes.Drawers.ExternalReloadTemplates;

    InitcbFormLetters(NewName);
  end;

  procedure TfrmLetterWriter.btnEditFormClick(Sender: TObject);
  var ExpandStr, SelectStr : string;
      FormLetterName : string;
  begin
    GetLetterPath(FCurrentBoilerplateIEN, ExpandStr, SelectStr);
    FormLetterName := cbFormLetters.Text;

    EditTemplates(Self, false, '', false, ExpandStr,SelectStr, cptemLetter, nil);
    if assigned(frmNotes.Drawers) then frmNotes.Drawers.ExternalReloadTemplates;
    InitcbFormLetters(FormLetterName);
  end;

  procedure TfrmLetterWriter.btnFontClick(Sender: TObject);
  begin
    if FontDialog.Execute then begin
      memoLetterText.Font.Assign(FontDialog.Font);
    end;
  end;

  procedure TfrmLetterWriter.btnNextPtClick(Sender: TObject);
  begin
    SetPreviewIndex(FPreviewPtIndex+1);
  end;


  procedure TfrmLetterWriter.btnPrevPtClick(Sender: TObject);
  begin
    SetPreviewIndex(FPreviewPtIndex-1);
  end;


procedure TfrmLetterWriter.btnPrintClick(Sender: TObject);
//This procedure will use FPatientList to create a new note, save the letter text to it, sign each note, and print them.
//It will not run unless a note type is picked, a valid signature code is entered, and a printer is selected.
begin
  PrintList(FPatientList);
end;

procedure TfrmLetterWriter.PrintList(PatientList: TStringList);
var
  i: integer;
  NoteTypeIEN: string;
  NewNoteIEN: string;
  ESCode : string;
  SignSts: TActionRec;
  ErrorMsg: string;
  FReportText : TRichEdit;
  ADevice : string;
  boolWinPrinter : boolean;
  NoteText : TstringList;
  DFN,PatName : string;
begin
  NoteTypeIEN := GetNoteTypeOnly;
  if NoteTypeIEN = '-1' then exit;
  SignatureForItem(Font.Size, 'Please enter your signature code.'+#13#10+'This will sign all letters and cannot be undone.', 'Sign Letters', ESCode);
  if Length(ESCode) = 0 then exit;
  ADevice := GetPrinter;
  if ADevice = '' then exit;

  NoteText := TStringlist.Create;
  boolWinPrinter := Piece(ADevice, ';', 1) = 'WIN';

  for i:= 0 to PatientList.Count - 1 do begin
    //Create note with text
    DFN := Piece(PatientList.Strings[i],'^',1);
    PatName := Piece(PatientList.Strings[i],'^',2);
    rLetters.GetLetterText(FCurrentBoilerplate, Notetext, DFN);
    if Notetext.Text = '' then begin
      messagedlg('Note text for ' + PatName + ' is blank.'+#13#10+'No note will be created.',mtError,[mbOK],0);
      Continue;
    end;
    NewNoteIEN := CreateTIUDocument(DFN,NoteTypeIEN,'',NoteText);
    if Piece(NewNoteIEN,'^',1) = '0' then begin
      messagedlg('Note for ' + PatName + ' cannot be created.'+ #13#10+#13#10 + Piece(NewNoteIEN,'^',2),mtError,[mbOK],0);
    end else begin
      //Sign note
      SignDocument(SignSts, strtoint(NewNoteIEN), ESCode);
      if SignSts.Success = True then begin
        //Print note
        if boolWinPrinter then begin
          FReportText := CreateReportTextComponent(Self);
          FastAssign(GetFormattedNote(strtoint(NewNoteIEN), True), FReportText.Lines);
          PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrorMsg);
          if Length(ErrorMsg) > 0 then InfoBox(ErrorMsg, TX_ERR_CAP, MB_OK);
        end else begin
          PrintNoteToDevice(strtoint(NewNoteIEN), Piece(ADevice, ';', 2), True, ErrorMsg);
          if Length(ErrorMsg) > 0 then begin
            InfoBox(ErrorMsg, TX_ERR_CAP, MB_OK);
          end;
        end;
      end else begin
        messagedlg('Letter for ' + PatName + ' cannot be printed.'+#13#10+#13#10+ SignSts.Reason,mtError,[mbOK],0);
      end;
    end;
  end;
  NoteText.Free;
end;

procedure TfrmLetterWriter.SetPreviewIndex(Value : integer);
  begin
    if ( Value >= 0 ) and ( Value <= FPatientList.Count-1 ) then begin
      FPreviewPtIndex := Value;
    end;
    DisplayCurrentPreview;
  end;


  procedure TfrmLetterWriter.btnShowPrintingListClick(Sender: TObject);
  begin
    frmLetterShowPatientList := TfrmLetterShowPatientList.Create(Self);
    frmLetterShowPatientList.Initialize(FPatientList);
    frmLetterShowPatientList.ShowModal;   // NOTE: procedure can alter FPatientList
    frmLetterShowPatientList.Free;
    DisplayPatientListChange;
  end;

  procedure TfrmLetterWriter.cbFormLettersChange(Sender: TObject);
  var
    Name : string;
    i : integer;
  begin
    i := cbFormLetters.ItemIndex;
    if (i < 0) or (i > cbFormLetters.Items.Count-1)  then begin
      FCurrentBoilerplate.Clear;
    end else begin
      Name := FLetterList.Strings[i];
      FCurrentBoilerplateIEN := Piece(Name,'^',1);
      GetTemplateBoilerplate(FCurrentBoilerplateIEN);
      FCurrentBoilerplate.Assign(RPCBrokerV.Results);
    end;
    DisplayCurrentPreview;
  end;


  procedure TfrmLetterWriter.DisplayCurrentPreview;
  var CurPatient, DFN: string;
  begin
    memoLetterText.Clear;
    btnPrevPt.Enabled := (FPreviewPtIndex>0);
    btnNextPt.Enabled := (FPreviewPtIndex < FPatientList.Count-1);
    lblPreviewFor.Visible := true;
    btnFont.Enabled := true;
    btnEditForm.Enabled := true;
    if (FPreviewPtIndex >= 0) and (FPreviewPtIndex < FPatientList.Count) then begin
      CurPatient := FPatientList.Strings[FPreviewPtIndex];
      lblPreviewFor.Caption:= 'Showing Preview For';
      lblPtName.Visible := true;
      lblPtName.Caption := piece(CurPatient,'^',2) + ' (#' +IntToStr(FPreviewPtIndex+1) + ' of ' + IntToStr(FPatientList.Count) + ')';
      DFN := piece(CurPatient,'^',1);
      btnPrint.Enabled := true;
      rLetters.GetLetterText(FCurrentBoilerplate, memoLetterText.Lines, DFN);
    end else begin
      lblPreviewFor.Caption:= 'Showing Raw Template';
      lblPtName.Visible := False;
      memoLetterText.Lines.Assign(FCurrentBoilerplate);
      btnPrint.Enabled := false;
    end;
  end;


  procedure TfrmLetterWriter.cboPatientListTypeChange(Sender: TObject);
  var  ListTypeIEN : int64;
  begin
    cboSelPatientList.clear;
    cboSelPatientList.Pieces := '2';
    ListTypeIEN := cboPatientListType.ItemIEN;
    if ListTypeIEN>0 then begin
      FListOfPatientLists.Assign(GetListOfPatientLists(ListTypeIEN));
    end else begin
      RPCBrokerV.Results.Clear;
    end;
    FastAssign(RPCBrokerV.Results, cboSelPatientList.Items);
  end;


  procedure TfrmLetterWriter.cboSelPatientListChange(Sender: TObject);
  var ListIEN : int64;
      ListTypeIEN : int64;
  begin
    ListIEN := cboSelPatientList.ItemIEN;
    ListTypeIEN := cboPatientListType.ItemIEN;

    if (ListIEN>0) and (ListTypeIEN>0) then begin
      FPatientList.Assign(GetPatientList(ListTypeIEN, ListIEN));
    end else begin
      FPatientList.Clear;
    end;
    DisplayPatientListChange;
  end;


  procedure TfrmLetterWriter.DisplayPatientListChange;
  var s : string;
      EndOfCap : string;
  begin
    FPreviewPtIndex := 0;
    //lblNumSelected.Caption := 'Current printing list contains ' + IntToStr(FPatientList.Count) + ' patients';
    if FPatientList.Count > 0 then begin
      if FPatientList.Count = 1 then EndOfCap := ' Patient' else EndOfCap := ' Patients';
      btnShowPrintingList.Caption := 'View/Edit ' + IntToStr(FPatientList.Count) + EndOfCap;
      btnShowPrintingList.Enabled := True;
    end else begin
      btnShowPrintingList.Caption := 'No Patients To View';
      btnShowPrintingList.Enabled := False;
    end;
    s := '&Print ' + IntToStr(FPatientList.Count) + ' Letter';  if (FPatientList.Count > 0) then s := s + 's';
    btnPrint.Caption := s;
    btnPrint.Enabled := (FPatientList.Count > 0);
    DisplayCurrentPreview;
  end;


end.

