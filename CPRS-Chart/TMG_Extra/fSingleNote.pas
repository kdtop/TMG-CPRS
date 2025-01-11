unit fSingleNote;
//kt TMG Eddie  Added entire form.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ToolWin, ComCtrls, ExtCtrls, TMGHTML2,
  OleCtrls, SHDocVw, MSHTML, ORFn, fLabs, uImages, uReminders,
  rTIU, uTIU, rCore, fDrawers, ORNet,Trpcb, WinSock, uPCE,
  ORCtrls, ActnList, Menus, fReminderDialog;

type
  tSNModes = (snmNone, snmLab, snmReport, snmNurse, snmMessenger, snmRecordsRequest, snmReminder);

  TfrmSingleNote = class(TForm)
    pnlButton: TPanel;
    ToolBar: TToolBar;
    cbFontNames: TComboBox;
    cbFontSize: TComboBox;
    btnFonts: TSpeedButton;
    btnItalic: TSpeedButton;
    btnBold: TSpeedButton;
    btnUnderline: TSpeedButton;
    btnBullets: TSpeedButton;
    btnNumbers: TSpeedButton;
    btnLeftAlign: TSpeedButton;
    btnCenterAlign: TSpeedButton;
    btnRightAlign: TSpeedButton;
    btnMoreIndent: TSpeedButton;
    btnLessIndent: TSpeedButton;
    btnTextColor: TSpeedButton;
    btnBackColor: TSpeedButton;
    btnEditZoomOut: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    pnlHTMLEdit: TPanel;
    pnlBottom: TPanel;
    btnClose: TSpeedButton;
    btnSave: TSpeedButton;
    pnlDrawers: TPanel;
    Splitter1: TSplitter;
    timAutoSave: TTimer;
    splDrawers: TSplitter;
    btnFunc1: TBitBtn; //TButton;
    btnFunc2: TBitBtn; //TButton;
    btnFunc3: TBitBtn; //TButton;
    btnFunc4: TBitBtn; //TButton;
    btnFunc5: TBitBtn;
    btnChangeTitle: TBitBtn;
    pnlPatient: TKeyClickPanel;
    lblPtName: TStaticText;
    lblPtSSN: TStaticText;
    lblPtAge: TStaticText;
    ActionList1: TActionList;
    Action1: TAction;
    NotePopupMenu: TPopupMenu;
    mnuSignNote: TMenuItem;
    popNoteMacro: TMenuItem;
    cmdOld: TButton;
    cmdPrev: TButton;
    cmdNext: TButton;
    cmdRecent: TButton;
    lblMostRecent: TLabel;
    lblThisDate: TLabel;
    btnSaveNoSend: TSpeedButton;
    btnSaveWSend: TSpeedButton;
    Label1: TLabel;
    cmbUsers: TComboBox;
    chkCopyToClipboard: TCheckBox;
    chkSaveWOSignature: TCheckBox;
    procedure chkSaveWOSignatureClick(Sender: TObject);
    procedure chkCopyToClipboardClick(Sender: TObject);
    procedure btnSaveWSendClick(Sender: TObject);
    procedure btnSaveNoSendClick(Sender: TObject);
    procedure cmdRecentClick(Sender: TObject);
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdOldClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure mnuSignNoteClick(Sender: TObject);
    procedure Action1Execute(Sender: TObject); //TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFunc1Click(Sender: TObject);
    procedure btnFunc6Click(Sender: TObject);
    procedure btnFunc5Click(Sender: TObject);
    procedure btnFunc4Click(Sender: TObject);
    procedure btnFunc3Click(Sender: TObject);
    procedure btnFunc2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure btnChangeTitleClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEditNormalZoomClick(Sender: TObject);
    procedure btnEditZoomInClick(Sender: TObject);
    procedure btnEditZoomOutClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure btnBulletsClick(Sender: TObject);
    procedure btnCenterAlignClick(Sender: TObject);
    procedure btnFontsClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnLeftAlignClick(Sender: TObject);
    procedure btnLessIndentClick(Sender: TObject);
    procedure btnMoreIndentClick(Sender: TObject);
    procedure btnNumbersClick(Sender: TObject);
    procedure btnRightAlignClick(Sender: TObject);
    procedure btnTextColorClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure cbFontNamesChange(Sender: TObject);
    procedure cbFontSizeChange(Sender: TObject);
  private
    { Private declarations }
    FHTMLEditorWarmedUp : boolean;
    FEditIEN : Int64;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FMode: tSNModes;
    //FSilent : boolean;
    boolAutosaving : Boolean;
    FLabData : TStringList;
    FNotes : TStringList;
    FSaveAndCloseTriggered : boolean;
    FAddCosigner : boolean;
    NotifyOK:boolean;
    UserParamName:string;
    FDefaultType : string;
    MyName : string;  //Used to determine the current user's messenger name
    MyIPAddress : string; //Used to hold the current PC's IP Address
    uPCEShow : TPCEData;  //PCE data that is non-editable, for display only.
    uPCEEdit : TPCEData;  //PCE data for note being edited (when relevant)
    //procedure HTMLEditorKeyPress(Sender: TObject; var Key: Char);
    procedure SelectReminder;
    function GetDrawers: TFrmDrawers;
    function LacksRequiredForCreate(EditNoteRec : TEditNoteRec): Boolean;
    procedure InsertNewNote;
    procedure UpdateNoteAuthor(DocInfo: string; EditNoteRec : TEditNoteRec);
    procedure SaveCurrentNote(var Saved: Boolean; Silent : boolean = false);
    procedure DoAutoSave(Suppress: integer = 1);
    function GetClipHTMLText(var szText:string):Boolean;
    function SetClipText(szText:string):Boolean;
    procedure DoDeleteDocument(NoPrompt : boolean = false);
    procedure HandleHTMLObjPaste(Sender : TObject; var AllowPaste : boolean); //kt 8/16
    function VerifyNoteTitle: Boolean;
    function FontSize : integer;
    function LockNote(AnIEN : integer) : boolean;
    function SignNote():boolean;
    //procedure IdentifyAddlSigners();
    function EditorHasText : boolean;
    //function GetCurrentLabs : tLabsInfoRec;
    function HandleClosing(FormClosing : boolean):boolean;
    //function GetCurrentLabsHTMLTable : string;
    //function GetAbnormalCurrentLabsHTMLTable : string;
    //function GetCurrentLabNotesHTMLTable : string;
    //function GetPickedLabNotesHTMLTable : string;
    //function InfoToHTMLTable(LabInfo: tLabsInfoRec) : string;
    function GetEditNoteDisplay(): string;
    procedure UpdateNoteTitleDisplay();
    procedure RunMacro(Sender:TObject);
    procedure SendOneMessage(ToUser,FromUser:string;OneMessage:string;NoteCreated:integer=0);
    procedure LoadUsers;
    function GetMyName:string;
  public
    { Public declarations }
    HTMLEditor : THtmlObj;
    RemIEN : string;
    //frmDrawers : TfrmDrawers;
    function ActiveEditIEN : Int64;
    procedure HandleInsertDate(Sender: TObject);
    function AllowContextChange(var WhyNot: string): Boolean;
    procedure Initialize(Mode : tSNModes = snmNone);
    procedure UpdateButtons;
    procedure AssignRemForm;
    function CanFinishReminder: boolean;
    procedure DisplayPCE;
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
  end;

var
  frmSingleNote: TfrmSingleNote;  //<--Not autocreated


procedure CreateSingleNote(Mode : tSNModes = snmNone; NotifyOK:boolean = false; InitRemIEN:string = '');

implementation

uses fImages, fSignItem, uConst, rSurgery, uTMGUtil, uCore,
     fNoteProps, uHTMLTools, uTemplates, fFrame, fNoteDR,
     fAddlSigners, Clipbrd,fNotes, uTMGOptions, fEncnt, fLabPicker,
     fReports
     ;

{$R *.dfm}

const
  DEFAULT_NOTE_TYPE : array[snmNone .. snmReminder] of string = (
    '',
    'SINGLE NOTE LAB DEFAULT TYPE^1397|LAB/XRAYS/STUDIES RESULTS',
    'SINGLE NOTE RAB DEFAULT TYPE^1397|LAB/XRAYS/STUDIES RESULTS',
    'SINGLE NOTE NURSE DEFAULT TYPE^2207|BRIEF NURSE NOTE',
    'SINGLE NOTE MESSENGER DEFAULT TYPE^183|PATIENT TASK',
    'SINGLE NOTE RECORDS DEFAULT TYPE^207|REQUEST RECORDS TASK',
    'SINGLE NOTE REMINDERS DEFAULT TYPE^210|PROCESS REMINDERS'
  );


var
  frmDrawers: TfrmDrawers;
//====================================================================

procedure CreateSingleNote(Mode : tSNModes = snmNone; NotifyOK:boolean = false; InitRemIEN:string = '');
begin
   frmSingleNote := TfrmSingleNote.Create(Application);
   frmSingleNote.NotifyOK := NotifyOK;
   frmSingleNote.Initialize(Mode);
   with frmSingleNote do begin
      RemIEN := 'R'+InitRemIEN;
      lblPtName.Caption := Patient.Name;
      lblPtSSN.Caption := Patient.SSN;
      lblPtAge.Caption := FormatFMDateTime('mmm dd,yyyy', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')';
      pnlPatient.Caption := lblPtName.Caption + ' ' + lblPtSSN.Caption + ' ' + lblPtAge.Caption;
   end;
   if Mode=snmReminder then begin
     frmSingleNote.ShowModal;
   end else begin
     frmSingleNote.FormStyle := fsStayOnTop;
     frmSingleNote.Show;  //<-- NOTE: the OnClose event sets close action to caFree --> all will be freed automatically
   end;
   //FreeAndNil(frmSingleNote);
end;

procedure ClearEditRec(EditNoteRec : TEditNoteRec);
{ resets controls used for entering a new progress note }
begin
  with EditNoteRec do begin
    DocType      := 0;
    IsNewNote    := true;
    Title        := 0;
    TitleName    := '';
    DateTime     := 0;
    Author       := 0;
    AuthorName   := '';
    Cosigner     := 0;
    CosignerName := '';
    Subject      := '';
    Location     := 0;
    LocationName := '';
    PkgIEN       := 0;
    PkgPtr       := '';
    PkgRef       := '';
    NeedCPT      := False;
    Addend       := 0;
    IsComponent  := false;
    if Assigned (Lines) then Lines.Clear;
    PRF_IEN      := 0;
    ActionIEN    := '';
    VisitDate    := 0;
    LastCosigner := 0;
    LastCosignerName := '';
    IDParent     := 0;
    ClinProcSummCode := 0;
    ClinProcDateTime := 0;
  end;
end;

//====================================================================

procedure TfrmSingleNote.FormCreate(Sender: TObject);
var
  NewItem:tMenuItem;
  arrMacros : TStringList;
  i : integer;

begin
  cbFontNames.Items.Assign(Screen.Fonts);
  HTMLEditor := THtmlObj.Create(pnlHTMLEdit,Application);
  TWinControl(HTMLEditor).Parent:=pnlHTMLEdit;
  TWinControl(HTMLEditor).Align:=alClient;
  FHTMLEditorWarmedUp := false;
  UserParamName := '';
  FEditIEN := 0;
  FVerifyNoteTitle := 0;
  FMode := snmNone;
  FSaveAndCloseTriggered := false;
  FAddCosigner := false;
  FLabData := TStringList.Create;
  FNotes := TStringList.Create;
  //FSilent := false;
  boolAutosaving := False;
  FEditNote.Lines := TStringList.Create;
  ClearEditRec(FEditNote);
  HTMLEditor.Navigate('about:blank');
  HTMLEditor.Editable := True;
  HTMLEditor.MoveCaretToEnd;
  HTMLEditor.InsertHTMLAtCaret(' ');
  HTMLEditor.BringToFront;
  //HtmlEditor.OnPasteEvent := HandleHTMLObjPaste;
  frmDrawers := TfrmDrawers.CreateDrawers(Self, pnlDrawers, [],[]);
  frmDrawers.Align := alBottom;
  frmDrawers.Splitter := splDrawers;
  frmDrawers.DefTempPiece := 2;
  frmDrawers.RichEditControl := nil;
  frmDrawers.HTMLEditControl := HtmlEditor;
  frmDrawers.HTMLModeSwitcher := nil;
  frmDrawers.ActiveEditIEN := ActiveEditIEN;
  frmDrawers.ReloadNotes := nil;
  frmDrawers.DocSelRec.TreeView := nil;
  frmDrawers.DocSelRec.TreeType := edseNotes;
  frmDrawers.NewNoteButton := nil;
  frmDrawers.DefTempPiece := 1;
  //HtmlEditor.OnLaunchTemplateSearch := frmDrawers.HandleLaunchTempOnlyQuickSearch;
  HtmlEditor.OnLaunchTemplateSearch := frmDrawers.HandleLaunchTemplateQuickSearch;
  HtmlEditor.OnLaunchConsole := frmDrawers.HandleLaunchConsole;
  HtmlEditor.OnInsertDate := HandleInsertDate;
  HtmlEditor.PopupMenu := NotePopupMenu;

  //Create submenu for Macro
  //Duplicate code: similar to fNotes.OnCreate
  arrMacros := TStringList.Create();
  tCallV(arrMacros,'TMG CPRS GET MACRO LIST',[User.DUZ]);
  popNoteMacro.Visible := (arrMacros.Count>1);
   if arrMacros.Count>1 then begin
     arrMacros.Delete(0);
     for i := 0 to arrMacros.Count - 1 do begin
      //mnuRelationships.Items[i].Add(NewItem(piece(arrRelatives.Strings[i],'^',2)+' '+piece(arrRelatives.strings[i],'^',3),0,False,True,OpenRelationshipChart,0,'mnuRelation'+inttostr(i)));
      NewItem := TMenuItem.Create(popNoteMacro);
      NewItem.Caption := piece(arrMacros.Strings[i],'^',2);
      //NewItem.
      NewItem.Name := 'Macro_'+piece(arrMacros.Strings[i],'^',1); //'mnuRelation_'+piece(arrRelatives.Strings[i],'^',1)+'_'+inttostr(i);
      NewItem.Tag := strtoint(piece(arrMacros.Strings[i],'^',1));
      NewItem.Hint := piece(arrMacros.Strings[i],'^',3);
      NewItem.OnClick := RunMacro;
      //mnuRelationships.Items[i].Add(NewItem);
      popNoteMacro.Insert(i,NewItem);
    end;
  end;

  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;

end;

procedure TfrmSingleNote.RunMacro(Sender:TObject);
  //Duplicate code: similar to fNotes.RunMacro
var ProcessedNote : TStrings;  //pointer to other objects
    OriginalNote : TStringList;
    Selection,SelText : string;
    ErrMsg:string;
begin
  inherited;
  if not boolAutosaving then DoAutoSave;      //elh added 1/15/18
  //What call will properly save text for Processing Note????
  //PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
  OriginalNote := TStringList.Create;
  //if (vmHTML in FViewMode) then begin
    SplitHTMLToArray(WrapHTML(HtmlEditor.HTMLText), OriginalNote);
    //breaks image paths - should not be necessary HTMLTools.InsertSubs(OriginalNote);
    if HTMLEditor.SelText<>'' then begin
      Selection := '1';
      SelText := HTMLEditor.SelText;
    end else begin
      Selection := '0';
      SelText := '';
    end;
    ProcessedNote := TMGTIUResolveMacro(inttostr(TMenuItem(Sender).Tag), IntToStr(FEditIEN), OriginalNote, SelText,Selection, ErrMsg);
    //ProcessedNote := ProcessNote(OriginalNote,GetCurrentNoteIEN);
    if ErrMsg<>'' then begin
      messagedlg('Error with macro'+#13#10+ErrMsg,mtError,[mbOk],0);
    end else begin
      if Selection='1' then
        HtmlEditor.SelText := ProcessedNote.Text
      else
        HtmlEditor.HTMLText := ProcessedNote.Text;
      //GLOBAL_HTMLTemplateDialogsMgr.SyncFromHTMLDocument(HtmlEditor); //later I can embed this functionality in THtmlObj
    end;
    //messagedlg(piece(TMenuItem(Sender).Name,'-',2),mtConfirmation,[mbok],0);
    //OpenNewPatient(piece(TMenuItem(Sender).Name,'_',2));
  //end;
end;



procedure TfrmSingleNote.FormDestroy(Sender: TObject);
begin
  FEditNote.Lines.Free;
  FLabData.Free;
  FNotes.Free;
  frmDrawers.DisplayDrawers(FALSE);
  frmDrawers.free;
  //fSingleNote.frmDrawers.ClearPtData;  //kt added 6/15
  //fSingleNote.frmDrawers.ResetTemplates;
  //frmDrawers.FormDestroy(Sender);
  //freeandnil(fSingleNote.frmDrawers);
  HTMLEditor.Free;
  if (uPCEEdit <> nil) then uPCEEdit.Free; //CQ7012 Added test for nil
  if (uPCEShow <> nil) then uPCEShow.Free; //CQ7012 Added test for nil
end;

procedure TfrmSingleNote.FormShow(Sender: TObject);
var
  EnableList, ShowList: TDrawers;

begin
  if not FHTMLEditorWarmedUp then begin
    HtmlEditor.Loaded;
    HtmlEditor.Editable := true;  //Sets ContentEditable=true to doc.body, so needs to be done AFTER loading document.
    FHTMLEditorWarmedUp :=true;
    if (FMode=snmReminder)or(FMode=snmLab) then begin
      EnableList := [odTemplates, odReminders];
      ShowList := [odTemplates, odReminders];
    end else begin
      EnableList := [odTemplates];
      ShowList := [odTemplates];
    end;
    frmDrawers.DisplayDrawers(TRUE, EnableList, ShowList);
  end;
  if FEditIEN = 0 then InsertNewNote;
  if FEditIEN = 0 then Self.Close;
  HTMLEditor.SetFocus;
  HTMLEditor.ShowCaret;
  HTMLEditor.MoveCaretToEnd;
  if NotifyOK then begin
    if frmSingleNote.FMode = snmLab then begin
      HTMLEditor.InsertTextAtCaret('For labs obtained on: '+frmLabs.GetCurrentDate+', please notify that they are OK.');
    end else if frmSingleNote.FMode= snmReport then begin
      HTMLEditor.InsertTextAtCaret('For '+frmReports.GetCurrentReportString+', please notify that it is OK.');
    end;
  end;
  if FMode=snmLab then UpdateButtons;
  if FMode=snmReminder then SelectReminder;
end;

procedure TfrmSingleNote.SelectReminder;
var i:integer;
begin
    frmDrawers.sbRemindersClick(self);
    //frmDrawers.OpenDrawer(odReminders);
    if RemIEN='' then exit;
    for i:=0 to Drawers.tvReminders.Items.count-1 do begin   //TreeView1.Items.Count - 1 do begin
      if (Drawers.tvReminders.Items[i].Parent.Index = 0) and (piece(ReminderNode(Drawers.tvReminders.Items[i]).StringData,'^',1) = RemIEN) then begin
        Drawers.tvReminders.Select(Drawers.tvReminders.Items[i]);
        Drawers.tvReminders.SetFocus;
        ViewReminderDialog(ReminderNode(Drawers.tvReminders.Selected));
        break;
      end;
    end;
end;

procedure TfrmSingleNote.FormClose(Sender: TObject; var Action: TCloseAction);
var Closing:boolean;
begin
  Closing := HandleClosing(true);        //elh added boolean to handle non-closing condition
  if not Closing then begin //elh added to short circuit closing
    Action := caNone;
    exit;
  end;
  Action := caFree;  //The form is closed and all allocated memory for the form is freed.
  frmSingleNote := nil;  //This is just a reference to the form. Actual free is automatic, as per above
end;


procedure TfrmSingleNote.btnCloseClick(Sender: TObject);
begin
  inherited;
  FSaveAndCloseTriggered := false;
  Self.Close;  //FormClose event will trigger call to HandleClosing.
end;

procedure TfrmSingleNote.btnSaveClick(Sender: TObject);
begin
  inherited;
  FSaveAndCloseTriggered := true;
  Self.Close;  //FormClose event will trigger call to HandleClosing.
end;


procedure TfrmSingleNote.btnSaveNoSendClick(Sender: TObject);
begin
  FSaveAndCloseTriggered := true;
  FAddCosigner := True;
  Self.Close;  //FormClose event will trigger call to HandleClosing.
end;

procedure TfrmSingleNote.SendOneMessage(ToUser,FromUser:string;OneMessage:string;NoteCreated:integer=0);
//Public function to send a NetworkMessenger message
var
  i : integer;
  Result : string;
begin
  RPCBrokerV.remoteprocedure := 'TMG MESSENGER SEND MESSAGE';
  RPCBrokerV.Param[0].Value := ToUser;  // not used
  RPCBrokerV.param[0].ptype := literal;
  RPCBrokerV.Param[1].Value := FromUser;  // not used
  RPCBrokerV.param[1].ptype := literal;
  RPCBrokerV.param[2].ptype := list;
  RPCBrokerV.Param[2].Mult['0'] := OneMessage;
  RPCBrokerV.Param[3].Value := inttostr(NoteCreated);  // not used
  RPCBrokerV.param[3].ptype := literal;
  RPCBrokerV.Param[4].Value := Patient.DFN;
  RPCBrokerV.param[4].ptype := literal;
  CallBroker;
  Result := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
end;

function TfrmSingleNote.GetMyName():string;
//Public function to get the current user's name, based on IP Address
begin
  Result := sCallV('TMG MESSENGER GET MY NAME',[MyIPAddress]);
  if piece(Result,'^',1)='1' then
    Result := piece(Result,'^',2);
end;

procedure TfrmSingleNote.btnSaveWSendClick(Sender: TObject);
begin
  SendOneMessage(cmbUsers.Text,MyName,Patient.TMGMsgString+' '+HTMLEditor.Text,1);
  FSaveAndCloseTriggered := true;
  FAddCosigner := True;
  Self.Close;  //FormClose event will trigger call to HandleClosing.
end;

function TfrmSingleNote.HandleClosing(FormClosing : boolean):boolean;   //changed to function in case of cancel response from user
var Response:integer;
    EmptyNote : boolean;
    Signed : boolean;
    AddlSigners : TStringList;
    AddlUser : string;
begin
  result := True;
  if (FSaveAndCloseTriggered) and (not chkSavewosignature.checked) then begin
    //MOVED BELOW    7/9/24
    //Signed := SignNote;
    //if Signed=false then begin
    //  result := false;
    //  exit;
    //end;
    if (chkCopyToClipboard.visible=True)and(chkCopyToClipboard.Checked=True) then    //11/2/23
        CopyHTMLToClipboard('',HtmlEditor.HTMLText);
    if (FAddCosigner = True) or (NotifyOK=True) then begin      //Added NotifyOK  7/9/24
      AddlSigners := TStringList.create();
      AddlUser := sCallV('TMG GET USER FROM MGR NAME',[cmbUsers.Text]);
      if piece(AddlUser,'^',1)='-1' then begin
        ShowMessage(piece(AddlUser,'^',2));
        //exit;
      end else begin
        AddlSigners.Add(AddlUser);
        UpdateAdditionalSigners(FEditIEN,AddlSigners);
      end;
      AddlSigners.Free;
    end;
    Signed := SignNote;
    if Signed=false then begin
      result := false;
      exit;
    end;
  end else begin
    EmptyNote := (HtmlEditor.GetTextLen = 0) or not HTMLContainsVisibleItems(HtmlEditor.HTMLText);
    if not EmptyNote then begin
      if chkSavewosignature.checked then begin  //added to assume that note will be signed w/o user response
         Response := mrYes;
      end else begin
         Response := MessageDlg('Do you want to save (unsigned) this note before exiting?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
      end;
    end else begin
      Response := mrNo;
    end;
    if Response=mrCancel then begin
      //if FormClosing then DoAutoSave(0);
      result := False;
      exit;
    end else if Response=mrYes then begin
      DoAutoSave(0);
      UnlockDocument(FEditIEN);
    end else begin
      DoDeleteDocument(true);
    end;
  end;
  if (cmbUsers.Visible) and (UserParamName<>'') then uTMGOptions.WriteInteger(UserParamName,cmbUsers.ItemIndex);
  if frmNotes.tvNotes.Items.Count > 0 then begin
    frmNotes.FromSingleNote:= True;
    frmNotes.ReloadNotes;
    frmNotes.FromSingleNote:= False;
  end;
end;

procedure TfrmSingleNote.Action1Execute(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

function TfrmSingleNote.ActiveEditIEN : Int64;
begin
  Result := FEditIEN;
end;

function TfrmSingleNote.LacksRequiredForCreate(EditNoteRec : TEditNoteRec): Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
begin
  Result := False;
  with EditNoteRec do begin
    if Title <= 0    then Result := True;
    if Author <= 0   then Result := True;
    if DateTime <= 0 then Result := True;
    if IsConsultTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsSurgeryTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsPRFTitle(Title) and (PRF_IEN = 0) and (not DocType = TYP_ADDENDUM) then Result := True;
    if (DocType = TYP_ADDENDUM) then begin
      if AskCosignerForDocument(Addend, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end else begin
      if Title > 0 then CurTitle := Title else CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end;
  end;
end;

function TfrmSingleNote.VerifyNoteTitle: Boolean;
const
  VNT_UNKNOWN = 0;
  VNT_NO      = 1;
  VNT_YES     = 2;
var
  AParam: string;
begin
  if FVerifyNoteTitle = VNT_UNKNOWN then begin
    AParam := GetUserParam('ORWOR VERIFY NOTE TITLE');
    if AParam = '1' then FVerifyNoteTitle := VNT_YES else FVerifyNoteTitle := VNT_NO;
  end;
  Result := FVerifyNoteTitle = VNT_YES;
end;

function TfrmSingleNote.GetEditNoteDisplay(): string;
begin
  Result := FormatFMDateTime('mmm dd,yy', FEditNote.DateTime) + ' ' + FEditNote.TitleName +
         ' -- ' + FEditNote.AuthorName;
end;

procedure TfrmSingleNote.UpdateNoteTitleDisplay();
begin
  Self.Caption := piece(Self.Caption, ':', 1) + ': ' + GetEditNoteDisplay;
end;

procedure TfrmSingleNote.InsertNewNote();
{ creates the editing context for a new progress note }
var
  HaveRequired        : boolean;
  CreatedNote         : TCreatedDoc; //a record
  TmpBoilerPlate      : TStringList;
  DocInfo             : string;
  //BoilerplateIsHTML   : boolean;
  FNewIDChild, IsIDChild: boolean;
  Param, DefValue, NoteTitle : string;
begin
  if Encounter.NeedVisit then begin
    //7/9/19 - Autocreate encounter whether NotifyOk or not
    //if NotifyOK then begin
      Encounter.Location := 6;
      Encounter.DateTime := DateTimeToFMDateTime(Now);
      Encounter.VisitCategory := 'A';
      Encounter.StandAlone := true;
    //end else begin
      //UpdateVisit(Font.Size, DfltTIULocation);
    //end;
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  IsIDChild := false;  //kt
  FNewIDChild := IsIDChild;
  TmpBoilerPlate := nil;
  Param := piece(DEFAULT_NOTE_TYPE[FMode], '^',1);
  DefValue := piece(DEFAULT_NOTE_TYPE[FMode], '^',2);
  NoteTitle := uTMGOptions.ReadString(Param,DefValue);
  try
    ClearEditRec(FEditNote);
    with FEditNote do begin
      DocType      := TYP_PROGRESS_NOTE;
      IsNewNote    := True;
      Title        := strtoint(piece(NoteTitle,'|',1));
      TitleName    := piece(NoteTitle,'|',2);
      if IsSurgeryTitle(Title) then begin   // Don't want surgery title sneaking in unchallenged
        Title := 0;  TitleName := '';
      end;
      //if AtFPGLoc() then DateTime := Encounter.DateTime else   //Not needed
      DateTime     := FMNow;
      Author       := User.DUZ;
      AuthorName   := User.Name;
      Location     := Encounter.Location;
      LocationName := Encounter.LocationName;
      VisitDate    := Encounter.DateTime;
      IDParent     := 0;
      NeedCPT      := false;
    end;
    HaveRequired := True; //default to OK
    // check to see if interaction necessary to get required fields
    if LacksRequiredForCreate(FEditNote) then begin
      HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild, FNewIDChild, '', 0);
    end;
    if HaveRequired then begin
      uPCEEdit.UseEncounter := True;       //8/13/24
      uPCEEdit.NoteDateTime := FEditNote.DateTime;  //8/13/24
      uPCEEdit.PCEForNote(USE_CURRENT_VISITSTR, uPCEShow);   //8/13/24
      // create the note
      PutNewNote(CreatedNote, FEditNote);
      FEditIEN := CreatedNote.IEN;
      uPCEEdit.NoteIEN := CreatedNote.IEN;  //8/13/24
      if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
      if CreatedNote.ErrorText = '' then begin
        TmpBoilerPlate := TStringList.Create;
        LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title);
        //HtmlEditor.SetFocus;
        DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
        ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
        FEditNote.Lines.Assign(TmpBoilerPlate);
        ResolveEmbeddedTemplates(frmDrawers);
        HtmlEditor.MoveCaretToEnd;
        if uHTMLTools.TextIsHTML(TmpBoilerPlate.Text) then begin
          HTMLEditor.InsertHTMLAtCaret(TmpBoilerPlate.Text);
        end else begin
          HTMLEditor.InsertHTMLAtCaret(Text2HTML(TmpBoilerPlate));
        end;
        Application.ProcessMessages;
        UpdateNoteAuthor(DocInfo, FEditNote);
        UpdateNoteTitleDisplay();
        HTMLEditor.MoveCaretToEnd;
      end else begin
        InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
        //HaveRequired := False;
      end; {if CreatedNote.IEN}
    end; {if HaveRequired}
  finally
    TmpBoilerPlate.Free;
  end;
end;

procedure TfrmSingleNote.UpdateNoteAuthor(DocInfo: string; EditNoteRec : TEditNoteRec);
const
  TX_INVALID_AUTHOR1 = 'The author returned by the template (';
  TX_INVALID_AUTHOR2 = ') is not valid.' + #13#10 + 'The note''s author will remain as ';
  TC_INVALID_AUTHOR  = 'Invalid Author';
var
  NewAuth, NewAuthName, AuthNameCheck: string;
  //ADummySender: TObject;
begin
  if DocInfo = '' then Exit;
  NewAuth := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_IEN');
  if NewAuth = '' then Exit;
  AuthNameCheck := ExternalName(StrToInt64Def(NewAuth, 0), 200);
  if AuthNameCheck <> '' then with EditNoteRec do begin
    if StrToInt64Def(NewAuth, 0) <> Author then begin
      Author := StrToInt64Def(NewAuth, 0);
      AuthorName := AuthNameCheck;
    end;
  end else begin
    NewAuthName := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_NAME');
    InfoBox(TX_INVALID_AUTHOR1 + UpperCase(NewAuthName) +
            TX_INVALID_AUTHOR2 + UpperCase(FEditNote.AuthorName),
            TC_INVALID_AUTHOR, MB_OK and MB_ICONERROR);
  end;
end;


procedure TfrmSingleNote.SaveCurrentNote(var Saved: Boolean; Silent : boolean = false);
{ validates fields and sends the updated note to the server }
var
  UpdatedNote: TCreatedDoc;
  //x: string;
  EmptyNote : boolean; //kt 9/11
  //EditIsHTML : boolean;  //kt 5/15
  HTMLText : string;

begin
  Saved := False;
  if FEditNote.Lines = nil then FEditNote.Lines := TStringList.Create; //kt 9/11
  HTMLText := HtmlEditor.HTMLText;
  EmptyNote := (HtmlEditor.GetTextLen = 0) or not HTMLContainsVisibleItems(HTMLText);
  if EmptyNote then begin
    if not Silent then MessageDlg('Note is empty.  Nothing to save', mtError, [mbOK],0);
    Exit;
  end;
  SplitHTMLToArray(WrapHTML(HTMLText), FEditNote.Lines);
  InsertSubs(FEditNote.Lines);
  FEditNote.Subject  := ''; //no subject support here... txtSubject.Text;
  //timAutoSave.Enabled := False;
  try
    PutEditedNote(UpdatedNote, FEditNote, FEditIEN);
  finally
    //timAutoSave.Enabled := True;
  end;
  if UpdatedNote.IEN > 0 then begin
    Saved := True;
    HTMLEditor.KeyStruck := false; //kt
  end else begin
    InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmSingleNote.DoAutoSave(Suppress: integer = 1);
var
//  ErrMsg: string;
//  HTMLText : string;
//  Changed : boolean;
  Saved : boolean;
begin
  if fFrame.frmFrame.DLLActive = true then Exit;
  boolAutosaving := True;
  SaveCurrentNote(Saved, True);
  {
  Changed := HTMLEditor.KeyStruck;
  if Changed then begin
    StatusText('Autosaving note...');
    timAutoSave.Enabled := False;
    try
      HTMLText := GetEditorHTMLText;
      SplitHTMLToArray (HTMLText, FEditNote.Lines);
      SetText(ErrMsg, FEditNote.Lines, lstNotes.GetIEN(EditingIndex),Suppress);
    finally
      timAutoSave.Enabled := True;
    end;
    FChanged := False;
    HTMLEditor.KeyStruck := false; //kt 9/11
    StatusText('');
  end;
  }
  boolAutosaving := False;
  {
  if ErrMsg <> '' then
    InfoBox(TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  }
end;


procedure TfrmSingleNote.DoDeleteDocument(NoPrompt : boolean = false);
//kt added, taking from mnuActDeleteClick
const
  TX_DEL_OK  = CRLF + CRLF + 'Delete this progress note?';
var
  DeleteSts, ActionSts:                         TActionRec;
  SavedDocIEN:                                  Integer;
  strIEN, ReasonForDelete, AVisitStr, x:        string;
  ErrStr :                                      string;
begin
  if FEditIEN <= 0 then exit;  //can happen when note was never initially created.  Nothing to delete.
  strIEN := IntToStr(FEditIEN);
  ActOnDocument(ActionSts, FEditIEN, 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(FEditIEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  if not NoPrompt and (InfoBox(TX_DEL_OK, TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then begin
    //frmImages.DeleteAll(idmDelete);  // Delete attached images
    MessageDlg('Todo, handle deleting images in TfrmSingleNote.DoDeleteDocument', mtWarning, [mbOK], 0);
  end;
  //if not LockNote(FEditIEN) then Exit;
  if JustifyDocumentDelete(FEditIEN) then InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocIEN := FEditIEN;
  DeleteSts.Success := True;
  x := GetPackageRefForNote(SavedDocIEN);
  //SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  if (SavedDocIEN > 0) then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if DeleteSts.Success then begin
    // reset the display now that the note is gone
    if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0); //kt added 5/16
    frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
  end else begin
    InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
  end;
end;

function TfrmSingleNote.SignNote():boolean;
{ sign the currently selected note, save first if necessary }
{returns success status}
const
  SIG_COSIGN   = 'COSIGNATURE';
  SIG_SIGN     = 'SIGNATURE';
  TC_NO_LOCK   = 'Unable to Lock Note';

var
  Saved, NoteLocked: Boolean;
  ActionType, ESCode, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  EmptyNote: boolean;
  HTMLText : string;
  NoteDisplayTitle : string;

begin
  result := false;
  NoteLocked := false;
  NoteDisplayTitle := GetEditNoteDisplay;
  HTMLText := HtmlEditor.HTMLText;
  EmptyNote := (HtmlEditor.GetTextLen = 0) or not HTMLContainsVisibleItems(HTMLText);
  if EmptyNote then begin
    MessageDlg('Note is empty.  Nothing to sign.', mtError, [mbOK],0);
    Exit;
  end;
  SaveCurrentNote(Saved);
  if (not Saved) then Exit;
  if not LastSaveClean(FEditIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(FEditIEN) then begin
    SignTitle := TX_COSIGN;     ActionType := SIG_COSIGN;
  end else begin
    SignTitle := TX_SIGN;       ActionType := SIG_SIGN;
  end;
  //if not LockNote(FEditIEN) then exit;
  // no exits after things are locked <-- not true, as finally block should be able to unlock.
  try
    frmSingleNote.FormStyle := fsNormal;  //ELH 10/22/24
    NoteLocked := true;
    ActOnDocument(ActionSts, FEditIEN, ActionType);
    if ActionSts.Success then begin
      if frmFrame.Closing then exit;
      if not AuthorSignedDocument(FEditIEN) then begin
        if InfoBox(TX_AUTH_SIGNED + NoteDisplayTitle, TX_SIGN ,MB_YESNO)= ID_NO then exit;
      end;
      SignatureForItem(FontSize, NoteDisplayTitle, SignTitle, ESCode);
      SignSts.Success := false;
      if Length(ESCode) > 0 then SignDocument(SignSts, FEditIEN, ESCode);
      result := (SignSts.Success=true);
      if SignSts.Success then begin
        if DisplayCosignerDialog(FEditIEN) then frmNotes.IdentifyAddlSigners(FEditIEN, FEditNote.DateTime);
      end else begin
        //InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end;
    end else begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    end;
  finally
    if NoteLocked then UnlockDocument(FEditIEN);
  end;
end;

procedure TfrmSingleNote.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave(1);    //kt changed param to 0 (from no param) to force call to save in "TEXT" instead of "TEMP"  9/15/16
end;

function TfrmSingleNote.FontSize : integer;
begin
  Result := btnSave.Font.Size
end;

function TfrmSingleNote.LockNote(AnIEN : integer) : boolean;
var
  LockMsg: string;
begin
  Result := true;
  //if NoteLocked then exit;
  LockDocument(AnIEN, LockMsg);
  if LockMsg <> '' then begin
    Result := False;
    InfoBox(LockMsg, TC_NO_LOCK, MB_OK);
  end;
end;


procedure TfrmSingleNote.mnuSignNoteClick(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

function TfrmSingleNote.AllowContextChange(var WhyNot: string): Boolean;
var Silent : boolean;
begin
  Result := true;
  case BOOLCHAR[frmFrame.CCOWContextChanging] of
    '1': begin
           if EditorHasText then   //kt 9/11
             WhyNot := WhyNot + 'A note in progress will be saved as unsigned.  '
           else
             WhyNot := WhyNot + 'An empty note in progress will be deleted.  ';
           Result := False;
         end;
    '0': begin
           if WhyNot = 'COMMIT' then Silent := True else Silent := False;
           //SaveCurrentNote(Result, Silent);
           if Result then begin
             Result := HandleClosing(Result);
             if Result then frmSingleNote.close;  
           end; 
         end;
  end;
end;

function TfrmSingleNote.GetClipHTMLText(var szText:string):Boolean;
//kt added entire function 8/16
//from: http://www.delphibasics.info/home/delphibasicssnippets/operateclipboardwithoutclipboardunit
var hData:  DWORD;
    pData:  Pointer;
    dwSize: DWORD;
begin
  Result := FALSE;
  //original if OpenClipBoard(0) <> 0 then begin
  if OpenClipBoard(0) then begin
    try
      hData := GetClipBoardData(CF_HTML);
      if hData <> 0 then begin
        pData := GlobalLock(hData);
        if pData <> nil then begin
          dwSize := GlobalSize(hData);
          if dwSize <> 0 then begin
            SetLength(szText, dwSize);
            CopyMemory(@szText[1], pData, dwSize);
            Result := TRUE;
          end;
          GlobalUnlock(DWORD(pData));
        end;
      end;
    finally
      CloseClipBoard;
    end;
  end else begin
    szText := '';
  end;
end;

function TfrmSingleNote.SetClipText(szText:string):Boolean;
//kt added entire function 8/16
//from: http://www.delphibasics.info/home/delphibasicssnippets/operateclipboardwithoutclipboardunit
var pData:  DWORD;
    dwSize: DWORD;
begin
  Result := FALSE;
  if OpenClipBoard(0) then begin
    dwSize := Length(szText) + 1;
    if dwSize <> 0 then begin
      pData := GlobalAlloc(MEM_COMMIT, dwSize);
      if pData <> 0 then begin
        CopyMemory(Pointer(pData), PChar(szText), dwSize);
        if SetClipBoardData(CF_HTML, pData) <> 0 then Result := TRUE;
      end;
    end;
    CloseClipBoard;
  end;
end;

procedure TfrmSingleNote.HandleHTMLObjPaste(Sender : TObject; var AllowPaste : boolean); //kt 8/16
//kt added entire function 8/16
//Handle paste event of one of the THtmlObj objects
//We can modify the clipboard if we want..
{From TClipboard documentation:
  Read TClipboard.Formats to determine what formats encode the information currently on the clipboard.
  Each format can be accessed by its position in the array.
  Usually, when an application copies or cuts something to the clipboard, it places it
  there in multiple formats. An application can place items of a particular format on
  the clipboard and retrieve items with a particular format from the clipboard if the
  format is in the Formats array. To find out if a particular format is available
  on the clipboard, use the HasFormat method.
  When reading information from the clipboard, use the Formats array to choose the best
  possible encoding for information that can be encoded in several ways.
  Before you can write information to the clipboard in a particular format, the
  format must be registered.
  To register a new format, use the RegisterClipboardFormat method of TPicture.
  }

  procedure RemoveWrapping(SL : TStringList);
  var HTMLText: string;
  begin
    HTMLText := SL.text;
    HTMLText := piece2(HTMLText,'<!--StartFragment-->',2);
    HTMLText := piece2(HTMLText,'<!--EndFragment-->',1);
    SL.clear;
    SL.text := HTMLText;
  end;

  procedure AddWrapping(SL : TStringList);
  var HTMLText : string;
  begin
    HTMLText := 'Version:0.9' + CRLF;
    HTMLText := HTMLText + 'StartHTML:-1' + CRLF;
    HTMLText := HTMLText + 'EndHTML:-1' + CRLF;
    HTMLText := HTMLText + 'StartFragment:000081' + CRLF;
    HTMLText := HTMLText + 'EndFragment:같같같' + CRLF;
    HTMLText := HTMLText + SL.Text + CRLF;
    HTMLText := StringReplace(HTMLText, '같같같', Format('%.6d', [Length(HTMLText)]), []);
    SL.Clear;
    SL.Text := HTMLText;
  end;

var
   TempCBText   : TStringList;
   TextModified : boolean;
   ClipText     : string;  //= 49285;

begin
  AllowPaste := true; //default
  exit;
  //ELH - (5/7/18) This function was clearing the clipboard of HTML that Kevin was wanted
  //      to actually paste. We weren't sure of the original intent of the procedure to
  //      for now it just exits out after setting "AllowPaste" to true.
  if not Clipboard.HasFormat(CF_HTML) then exit; //for now, I am only going to modify HTML pastes.
  try
    TempCBText := TStringList.Create;
    AllowPaste := true;
    if not GetClipHTMLText(ClipText) then exit;
    TempCBText.Text := ClipText; //FYI, if we just wanted text, then could use: TempCBText.Text := Clipboard.AsText;
    RemoveWrapping(TempCBText);
    StripJavaScript(TempCBText, TextModified);  //modify TempCBText if needed
    //if not TextModified then exit;  <--- NOTE: if text is not put back, then the format is all screwy, I don't understand why.
    AddWrapping(TempCBText);
    if not SetClipText(TempCBText.text) then begin
      AllowPaste := false;
    end;
    //FYI, if we just working with text, then could use: Clipboard.AsText := <my new text>
  finally
    FreeAndNil(TempCBText)
  end;
end;

procedure TfrmSingleNote.HandleInsertDate(Sender: TObject);  //kt
begin inherited; HTMLEditor.InsertHTMLAtCaret(datetostr(date)); end;

procedure TfrmSingleNote.btnBoldClick(Sender: TObject);
begin inherited; HTMLEditor.ToggleBold; end;

{
procedure TfrmSingleNote.HTMLEditorKeyPress(Sender: TObject; var Key: Char);
begin
end;
}
procedure TfrmSingleNote.btnItalicClick(Sender: TObject);
begin inherited; HTMLEditor.ToggleItalic; end;

procedure TfrmSingleNote.btnUnderlineClick(Sender: TObject);
begin inherited; HTMLEditor.ToggleUnderline; end;

procedure TfrmSingleNote.btnCenterAlignClick(Sender: TObject);
//kt 9/11 added function
begin inherited; HTMLEditor.AlignCenter; end;

procedure TfrmSingleNote.btnChangeTitleClick(Sender: TObject);
var
  LastTitle, LastConsult: Integer;
  OKPressed, IsIDChild: Boolean;
  x: string;

begin
  inherited;
  //IsIDChild := false;
  LastTitle := FEditNote.Title;
  FEditNote.IsNewNote := False;
  if Sender = Self then exit;
  OKPressed := ExecuteNoteProperties(FEditNote, CT_NOTES, false, false, '', 0);
  if not OKPressed then Exit;
  UpdateNoteTitleDisplay();
end;


procedure TfrmSingleNote.btnEditNormalZoomClick(Sender: TObject);
begin inherited; HTMLEditor.ZoomReset; end;

procedure TfrmSingleNote.btnEditZoomInClick(Sender: TObject);
begin inherited; HTMLEditor.ZoomIn; end;

procedure TfrmSingleNote.btnEditZoomOutClick(Sender: TObject);
begin inherited; HTMLEditor.ZoomOut; end;

procedure TfrmSingleNote.btnLeftAlignClick(Sender: TObject);
begin inherited; HTMLEditor.AlignLeft; end;

procedure TfrmSingleNote.btnNumbersClick(Sender: TObject);
begin inherited; HTMLEditor.ToggleNumbering; end;

procedure TfrmSingleNote.btnBulletsClick(Sender: TObject);
begin inherited; HTMLEditor.ToggleBullet;
end;

procedure TfrmSingleNote.btnTextColorClick(Sender: TObject);
begin inherited; HTMLEditor.TextForeColorDialog; end;

procedure TfrmSingleNote.btnBackColorClick(Sender: TObject);
begin inherited; HTMLEditor.TextBackColorDialog; end;

procedure TfrmSingleNote.btnFontsClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HTMLEditor.FontDialog;
end;

(*
function TfrmSingleNote.GetCurrentLabs : tLabsInfoRec;
begin
  Result.Data := FLabData; //owned by the TfrmSingleNote class
  Result.Notes := FNotes; //owned by the TfrmSingleNote class
  frmLabs.GetVisibleLabs(Result);
end;


function TfrmSingleNote.InfoToHTMLTable(LabInfo: tLabsInfoRec) : string;
//Input:  Record containing lab data
//Output:  A string containing HTML that displays data in an HTML table.
{
.Strings[i]='LabName^LabValue^Flags^Units^ReferenceRange'
  +--------+---------+---------+---------+--------+-------+
  |Date    | Lab     +  Value  |  Flags  |  Units | Ref   |   <-- will have to be hard coded
  +--------+---------+---------+---------+--------+-------+
  | 1/1/17 | WBC     |  17     |   H     | cc     |  1-10 |
  +--------+---------+---------+---------+--------+-------+
  | 1/1/17 | RBC     |  17     |   H     | cc     |  1-10 |
  +--------+---------+---------+---------+--------+-------+
  | 1/1/17 | PLT     |  17     |   H     | cc     |  1-10 |
  +--------+---------+---------+---------+--------+-------+
  | COMMENT                                               |  <-- Dont have this cell if LabInfo.Notes.Count = 0
  |                                                       |
  |                                                       |
  +--------+---------+---------+---------+--------+-------+
}

var
  i,j : integer;
  s : string;
  HasData, HasNotes : boolean;
const
 BG_COLOR = '#ffffe6';
begin
  result := '';
  HasNotes := (LabInfo.Notes.Count>0);
  HasData := (LabInfo.Data.Count>0);
  //Build the header
  if (HasNotes and HasData) then result := result+'<table border=1><tr><td>';
  if HasData then begin
    result := result+'<table border=1 bgcolor='+BG_COLOR+'><tr><th>Date</th><th>Lab</th><th>Value</th>';
    result := result+'<th>Flags</th><th>Units</th><th>Ref</th></tr>';
    //cycle through each string to create each row
    for i := 0 to LabInfo.Data.Count-1 do begin
      if i = 0 then s := LabInfo.Date else s := '';
      result := result+'<tr><td>'+ s +'</td>'; //begin row and date cell
      for j := 1 to 5 do begin //cycle through each piece for cell value
        result := result+'<td>'+piece(LabInfo.Data[i],'^',j)+'</td>';
      end;
      result := result+'</tr>';  //end row
    end;
    result := result+'</table>';  //end table
  end;  
  if HasNotes then begin
    result := result+'<table border=1 bgcolor='+BG_COLOR+'><tr><td><pre>';
    result := result + LabInfo.Notes.Text;
    result := result+'</pre></td></tr></table>';
  end;
  if (HasNotes and HasData) then result := result+'</tr></td></table>';
  if result <> '' then result := result + '<BR>'
end;


function TfrmSingleNote.GetCurrentLabsHTMLTable : string;
//Gets table with ALL lab values, but NOT notes.
var
  LabInfo: tLabsInfoRec;
begin
  LabInfo := GetCurrentLabs;
  LabInfo.Notes.Clear;
  Result := InfoToHTMLTable(LabInfo);
end;

function TfrmSingleNote.GetAbnormalCurrentLabsHTMLTable : string;
//Gets table with abnormal lab values, but NOT notes.
var
  i : integer;
  s : string;
  LabInfo: tLabsInfoRec;
begin
  LabInfo := GetCurrentLabs;
  for i := LabInfo.Data.Count-1 downto 0 do begin
    S := LabInfo.Data.Strings[i];  // 'LabName^LabValue^Flags^Units^ReferenceRange'
    if piece(s,'^',3) = '' then LabInfo.Data.Delete(i);
  end;
  LabInfo.Notes.Clear;
  Result := InfoToHTMLTable(LabInfo);
end;

function TfrmSingleNote.GetCurrentLabNotesHTMLTable : string;
var
  LabInfo: tLabsInfoRec;
begin
  LabInfo := GetCurrentLabs;
  LabInfo.Data.Clear;
  Result := InfoToHTMLTable(LabInfo);
end;

function TfrmSingleNote.GetPickedLabNotesHTMLTable : string;
var
  LabInfo: tLabsInfoRec;
  LabPicker: TfrmLabPicker;
begin
  Result := '';
  LabInfo := GetCurrentLabs;
  LabPicker := TfrmLabPicker.Create(Self);
  try
    LabInfo := GetCurrentLabs;
    LabPicker.Initialize(LabInfo);
    if LabPicker.ShowModal <> mrCancel then begin
      LabPicker.GetResults(LabInfo);
      Result := InfoToHTMLTable(LabInfo);
    end;
  finally
    LabPicker.Free;
  end;
end;
*)

procedure TfrmSingleNote.Initialize(Mode : tSNModes = snmNone);

    Function GetIPAddress():String;
    type
      TaPInAddr = array [0..10] of PInAddr;
      PaPInAddr = ^TaPInAddr;
    var
      phe: PHostEnt;
      pptr: PaPInAddr;
      Buffer: array [0..63] of Ansichar;
      i: Integer;
      GInitData: TWSADATA;
    begin
      WSAStartup($101, GInitData);
      Result := '';
      GetHostName(Buffer, SizeOf(Buffer));
      phe := GetHostByName(Buffer);
      if phe = nil then
        Exit;
      pptr := PaPInAddr(phe^.h_addr_list);
      i := 0;
      while pptr^[i] <> nil do
      begin
        Result := StrPas(inet_ntoa(pptr^[i]^));
        Inc(i);
      end;
      WSACleanup;
    end;

begin
  //tSNModes = (snmNone, snmLab, snmReport);
  FMode := Mode;
  lblMostRecent.Visible := (Mode=snmLab);
  cmdOld.Visible := (Mode=snmLab);
  cmdPrev.Visible := (Mode=snmLab);
  lblThisDate.Visible := (Mode=snmLab);
  cmdNext.Visible := (Mode=snmLab);
  cmdRecent.Visible := (Mode=snmLab);
  case Mode of
    snmLab: begin
      btnFunc1.Caption := 'Copy Labs';
      btnFunc1.Visible := true;
      btnFunc2.Caption := 'Copy Abnormal Labs';
      btnFunc2.Visible := true;
      btnFunc3.Caption := 'Copy Notes';
      btnFunc3.Visible := true;
      btnFunc4.Caption := 'Pick Labs';
      btnFunc4.Visible := true;
      Label1.Visible := True;
      cmbUsers.Visible := True;
      UserParamName := 'Last Lab User Selected';
      LoadUsers;
      btnSaveNoSend.Caption := 'Save Note w/'+#13#10+'Addl Signer';
      btnSaveNoSend.Visible := (NotifyOK=false);
      if NotifyOK then btnSave.Caption := 'Save w/'+#13#10+'Addl Signer';
      pnlButton.height := 84;
    end;
    snmReport: begin
      btnFunc1.Caption := 'Copy Reports';
      btnFunc1.Visible := true;
      btnFunc2.Visible := false;
      btnFunc3.Visible := false;
      btnFunc4.Visible := false;
      Label1.Visible := True;
      cmbUsers.Visible := True;
      UserParamName := 'Last Report User Selected';
      LoadUsers;
      btnSaveNoSend.Caption := 'Save Note w/'+#13#10+'Addl Signer';
      btnSaveNoSend.Visible := (NotifyOK=false);
      if NotifyOK then btnSave.Caption := 'Save w/'+#13#10+'Addl Signer';
      pnlButton.height := 57;
    end;
    snmNurse: begin
      btnFunc1.Caption := 'Nurse Note';
      btnFunc1.Visible := false;
      btnFunc2.Visible := false;
      btnFunc3.Visible := false;
      btnFunc4.Visible := false;
      pnlButton.height := 0;
    end;
    snmReminder: begin
      btnFunc1.Caption := 'Reminder Note';
      btnFunc1.Visible := false;
      btnFunc2.Visible := false;
      btnFunc3.Visible := false;
      btnFunc4.Visible := false;
      pnlButton.height := 0;
    end;
    snmMessenger: begin
      btnFunc1.Caption := 'Messenger Note';
      btnFunc1.Visible := false;
      btnFunc2.Visible := false;
      btnFunc3.Visible := false;
      btnFunc4.Visible := false;
      pnlButton.height := 0;
      btnSaveNoSend.Caption := 'Save Note'+#13#10+'NO POPUP';
      btnSaveWSend.Caption := 'Save Note'+#13#10+'WITH POPUP';
      btnSaveNoSend.Visible := true;
      btnSaveWSend.Visible := true;
      btnSave.Visible := False;
      btnClose.Left := btnSave.Left;
      Label1.Visible := True;
      cmbUsers.Visible := True;
      UserParamName := 'Last Messenger User Selected';
      chkCopyToClipboard.Visible := True;
      chkCopyToClipboard.Checked := uTMGOptions.ReadBool('MessageCopyToCB',false);
      LoadUsers;
      MyIPAddress := GetIPAddress;
      MyName := GetMyName();
      if piece(MyName,'^',1)='-1' then MyName := 'CPRS (Sender Unknown)';
      frmSingleNote.Caption := 'Single Patient Task Note - '+MyName+' ('+MyIPAddress+')';
    end;
    snmRecordsRequest: begin
      btnFunc1.Caption := 'Records Request Note';
      btnFunc1.Visible := false;
      btnFunc2.Visible := false;
      btnFunc3.Visible := false;
      btnFunc4.Visible := false;
      pnlButton.height := 0;
      btnSaveNoSend.Caption := 'Save Note'+#13#10+'NO POPUP';
      btnSaveWSend.Caption := 'Save Note'+#13#10+'WITH POPUP';
      btnSaveNoSend.Visible := true;
      btnSaveWSend.Visible := true;
      btnSave.Visible := False;
      btnClose.Left := btnSave.Left;
      Label1.Visible := True;
      cmbUsers.Visible := True;
      UserParamName := 'Last Record User Selected';
      chkCopyToClipboard.Visible := True;
      chkCopyToClipboard.Checked := uTMGOptions.ReadBool('MessageCopyToCB',false);
      LoadUsers;
      MyIPAddress := GetIPAddress;
      MyName := GetMyName();
      if piece(MyName,'^',1)='-1' then MyName := 'CPRS (Sender Unknown)';
      frmSingleNote.Caption := 'Single Records Request Task Note - '+MyName+' ('+MyIPAddress+')';
    end;
  end;
end;

procedure TfrmSingleNote.LoadUsers;
var Users:TStringList;
    i :integer;
    FirstUser:integer;
begin
  Users := TStringList.Create;
  //Users.LoadFromFile('\\server1\Public\NetworkMessenger\NetworkMessengerUsers.ini');
  cmbUsers.Items.Clear;
  cmbUsers.Text := '';
  tCallV(Users,'TMG MESSENGER GETUSERS',[]);
  for I := 1 to Users.Count - 1 do begin
    cmbUsers.Items.Add(piece(Users[i],'^',1));
  end;
  Users.Free;
  FirstUser := uTMGOptions.ReadInteger(UserParamName,0);
  cmbUsers.ItemIndex := FirstUser;
end;

procedure TfrmSingleNote.btnFunc1Click(Sender: TObject);
//for Lab: Copy (all) Labs, but NOT notes
var
  TableHTML : string;
begin
  Self.ActiveControl := nil;
  TableHTML := '';
  case FMode of
    snmLab: begin
      //for labs: copy lab results
      TableHTML := frmLabs.GetCurrentLabsHTMLTable;
    end;
    snmReport: begin
      //for Reports: copy current report.
      TableHTML := '<font face="Consolas">'+frmReports.GetCurrentReportHTMLTable+'</font>';
      TableHTML := StringReplace(TableHTML, #$D#$A,'<BR>', [rfReplaceAll]);
      TableHTML := StringReplace(TableHTML, '<pre>','', [rfReplaceAll]);
      TableHTML := StringReplace(TableHTML, '</pre>','', [rfReplaceAll]);
    end;
  end; //case
  if TableHTML <> '' then HTMLEditor.InsertHTMLAtCaret(TableHTML);
  HTMLEditor.SetFocus;
  HTMLEditor.SetFocusToDoc;
end;

procedure TfrmSingleNote.btnFunc2Click(Sender: TObject);
//for Lab: Copy abnormal lab results
var
  TableHTML : string;

begin
  Self.ActiveControl := nil;
  case FMode of
    snmLab: begin
      //for labs: copy abnormal lab results
      TableHTML := frmLabs.GetAbnormalCurrentLabsHTMLTable;
      HTMLEditor.InsertHTMLAtCaret(TableHTML);
      HTMLEditor.SetFocus;
      HTMLEditor.SetFocusToDoc;
    end;
    snmReport: begin
      //implement later if desired
    end;
  end;
end;

procedure TfrmSingleNote.btnFunc3Click(Sender: TObject);
//for Lab: Copy Notes
var
  TableHTML : string;
begin
  Self.ActiveControl := nil;
  case FMode of
    snmLab: begin
      //for labs: copy notes
      TableHTML := frmLabs.GetCurrentLabNotesHTMLTable;
      HTMLEditor.InsertHTMLAtCaret(TableHTML);
      HTMLEditor.SetFocus;
      HTMLEditor.SetFocusToDoc;
    end;
    snmReport: begin
      //implement later if desired
    end;
  end;
end;

procedure TfrmSingleNote.btnFunc4Click(Sender: TObject);
//for labs: Get Picked labs and notes
var
  TableHTML : string;
begin
  Self.ActiveControl := nil;
  case FMode of
    snmLab: begin
      //for labs: copy notes
      TableHTML := frmLabs.GetPickedLabNotesHTMLTable;
      if TableHTML <> '' then HTMLEditor.InsertHTMLAtCaret(TableHTML);
      HTMLEditor.SetFocus;
      HTMLEditor.SetFocusToDoc;
    end;
    snmReport: begin
      //implement later if desired
    end;
  end;
end;

procedure TfrmSingleNote.btnFunc5Click(Sender: TObject);
begin
//implement later if desired
end;

procedure TfrmSingleNote.btnFunc6Click(Sender: TObject);
begin
//implement later if desired
end;

procedure TfrmSingleNote.cbFontSizeChange(Sender: TObject);
//kt 9/11 added function
const
  FontSizes : array [0..6] of byte = (8,10,12,14,18,24,36);
begin
  inherited;
  //HtmlEditor.FontSize := StrToInt(cbFontSize.Text);
  HTMLEditor.FontSize := FontSizes[cbFontSize.ItemIndex];
end;

procedure TfrmSingleNote.chkCopyToClipboardClick(Sender: TObject);
begin
   uTMGOptions.WriteBool('MessageCopyToCB',chkCopyToClipboard.Checked);
end;

procedure TfrmSingleNote.chkSaveWOSignatureClick(Sender: TObject);
begin
   btnSavewsend.Enabled := not chkSaveWOSignature.Checked;
   if ((FMode=snmLab)or(FMode=snmReport)) and (NotifyOK) then begin
     if chkSaveWOSignature.Checked then
       btnSave.Caption := 'Save'
     else
       btnSave.Caption := 'Save w/'+#13#10+'Addl Signer';
   end;
   if FMode=snmLab then begin
      label1.visible := not chkSaveWOSignature.Checked;
      cmbUsers.Visible := not chkSaveWOSignature.Checked;
      btnSaveNoSend.Visible := not chkSaveWOSignature.Checked;
   end;
end;

procedure TfrmSingleNote.cmdNextClick(Sender: TObject);
begin
   frmLabs.cmdNextClick(Sender);
   UpdateButtons;
end;

procedure TfrmSingleNote.cmdOldClick(Sender: TObject);
begin
   frmLabs.cmdOldClick(Sender);
   UpdateButtons;
end;

procedure TfrmSingleNote.cmdPrevClick(Sender: TObject);
begin
  frmLabs.cmdPrevClick(Sender);
  UpdateButtons;
end;

procedure TfrmSingleNote.cmdRecentClick(Sender: TObject);
begin
  frmLabs.cmdRecentClick(Sender);
  UpdateButtons;
end;

procedure TfrmSingleNote.UpdateButtons;
begin
   lblThisDate.Caption := 'Date: '+frmLabs.GetCurrentDateTime;
   cmdRecent.Enabled := frmLabs.cmdRecent.Enabled;
   cmdPrev.Enabled := frmLabs.cmdPrev.Enabled;
   cmdOld.Enabled := frmLabs.cmdOld.Enabled;
   cmdNext.Enabled := frmLabs.cmdNext.Enabled;
end;

procedure TfrmSingleNote.cbFontNamesChange(Sender: TObject);
//kt 9/11 added function
var i :  integer;
    FontName : string;
const
   TEXT_BAR = '---------------';
begin
  inherited;
  if cbFontNames.Text[1]='<' then exit;
  FontName := cbFontNames.Text;
  HTMLEditor.FontName := FontName;
  i := cbFontNames.Items.IndexOf(TEXT_BAR);
  if i < 1 then cbFontNames.Items.Insert(0,TEXT_BAR);
  if i > 5 then cbFontNames.Items.Delete(5);
  if cbFontNames.Items.IndexOf(FontName)> i then begin
    cbFontNames.Items.Insert(0,FontName);
  end;
end;

procedure TfrmSingleNote.btnLessIndentClick(Sender: TObject);
begin inherited; HTMLEditor.Outdent; end;

procedure TfrmSingleNote.btnMoreIndentClick(Sender: TObject);
begin inherited; HTMLEditor.Indent; end;

procedure TfrmSingleNote.btnRightAlignClick(Sender: TObject);
begin inherited; HTMLEditor.AlignRight; end;

function TfrmSingleNote.EditorHasText : boolean;
var HTMLText : string;
begin
  HTMLText := HtmlEditor.HTMLText;
  Result := (HtmlEditor.GetTextLen = 0) or not HTMLContainsVisibleItems(HTMLText);
end;

//===========================================================================
//=========REMINDER FUNCTIONS -- TESTING CURRENTLY
//===========================================================================

procedure TfrmSingleNote.AssignRemForm;
// This was added for Reminder Handling
begin
  with RemForm do
  begin
    Form := Self;
    PCEObj := uPCEEdit;
    RightPanel := pnlHTMLEdit;
    CanFinishProc := CanFinishReminder;
    DisplayPCEProc := DisplayPCE;
    Drawers := fSingleNote.frmDrawers;
    //NewNoteRE := memNewNote;
    NewNoteHTMLE := HTMLEditor;  //kt
    NoteList := frmNotes.lstNotes;
  end;
end;

function TfrmSingleNote.CanFinishReminder: boolean;
begin
  result := True;
end;

procedure TfrmSingleNote.DisplayPCE;
begin
  //Nothing to do here
end;

function TfrmSingleNote.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers;
end;



end.


