unit fEncounterLabs;
//kt I *think* I added this entire form.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORFn, StrUtils,
  fODTMG1, rOrders, //kt
  Dialogs, fPCEBase, VA508AccessibilityManager, StdCtrls, Buttons, ExtCtrls;

type
  TfrmEnounterLabs = class(TfrmPCEBase)
    btnLaunchLabDlg: TBitBtn;
    btnNext: TBitBtn;
    lblLabActive: TLabel;
    lblLabActive2: TLabel;
    pnlRightTop: TPanel;
    lblOutput: TLabel;
    memOutput: TMemo;
    btnClearMemo: TButton;
    pnlTop: TPanel;
    pnlTopLeft: TPanel;
    Splitter1: TSplitter;
    btnSameNonFastingLabs: TButton;
    btnNoNewLabs: TButton;
    btnSameFastingLabs: TButton;
    btnSameLabs: TButton;
    btnPreexistingLabsToday: TButton;
    procedure btnPreexistingLabsTodayClick(Sender: TObject);
    procedure btnSameLabsClick(Sender: TObject);
    procedure btnSameFastingLabsClick(Sender: TObject);
    procedure btnNoNewLabsClick(Sender: TObject);
    procedure btnSameNonFastingLabsClick(Sender: TObject);
    procedure btnClearMemoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLaunchLabDlgClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    OrderIDSL : TStringList;  //kt  This will hold Order.ID of every order that has been created.
    OrderTextSLs : TList;     //kt  Each element will be a TStringList, holding 1 OrderTextSL
    LabOrderMessages : TList; //kt  Each element will be a TStringList, holding 1 lab order message.  These are messages sent, via TMG Messenger application, to other members of staff.
                              //Data FORMAT:  -- as created by TfrmODTMG1.SetupLabOrderMsg(SL : TStringList)
                              //              Data[0] = Recipient^Recipient^.....
                              //              Data[1] = 'T' or 'F' for boolean for FPromptToPrint
                              //              Data[2] = MyName
                              //              Data[3...] = the usual content of the message.
    FLabDlg : TfrmODTMG1;
    DialogActive : boolean;
    procedure DiscontinueLabsOrdered;
    procedure HandleCancelClosure;
    procedure SetReadyDisplayMode(Ready: boolean);
    procedure ClearOrderSL;
    procedure SaveOrderText(Text : string);  overload;
    procedure SaveOrderText(SL : TStringList);  overload;
    procedure DoPseudoOrder(Msg : string; FastingYNU : char);
    procedure SetupLabMsg(Msg : String; FastingYNU : char; SL : TStringList);
  public
    { Public declarations }
    IsDirty : boolean;  //11/14/23
    procedure SetDirtyStatus(DirtyStatus:boolean);  //11/14/23
    procedure SendData(var SendErrors,UnpastedHTML:string);  //kt
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder);    //kt added
    procedure HandleLabDlgClosing(Dlg : TfrmODTMG1; Data : TStringList);
    function OK2Close(Cancel : boolean) : boolean;   //kt added
    constructor CreateLinked(AParent: TWinControl);
  end;

var
  frmEnounterLabs: TfrmEnounterLabs;     //not auto-created


{NOTE: The life of the lab order is complicated.  I'll outline here

1) btnLaunchLabDlgClick causes creation of lab order by simulating user click to
   make new order: frmOrders.lstWriteClick.
2) When above returns, there is global variable, uOrderDialog, that holds pointer to lab dialog.
   This is of type TfrmODTMG1(uOrderDialog);  This is stored locally as FLabDlg.
3) The above order dialog is NOT modal (but it does stay on top), and user can
   do other things.  This makes managing 2 separate dialogs (encounter form and
   lab dialog) more tricky.  We don't want encounter to be closed and leave lab
   dialog still open.
4) We setup an OnClosing event handler, HandleLabDlgClosing.  This gives us chance to monitor
   the status of the lab dialog, and retrieve any info from it.  This will be called if
   the dialog is closed with OK, or Cancel.
5) After the lab dialog is closed (via Accept button), it goes through standard
   VA code, which generates a new lab order, a TOrder.  This then calls
   TfrmFrame.UMNewOrder() which in turn notifies many places in CPRS that an order
   has been created.  We wedge in a line to call back here, to TfrmEnounterLabs.NotifyOrder.
   Note: this code is not called if lab dialog is cancelled.
   Here we save off Order ID, which can be used to later delete order if user cancels Enounter changes.
6) And finally, when the frmEncounterFrame is closed, it calls SendData for each
   of the tabs.  So here in TfrmEnounterLabs.SendData, we put the lab order text
   into the note and send LabMessenger messages for checkout etc.

Design considerations
1) If a lab is ordered through the encounter form, and then the encounter form is cancelled,
   it is felt that the labs order(s) should also be cancelled.
2) Often more than one lab order is generated.  I.e. some for now, some for next visit,
   so process needs to be able to handle multiple orders (and multiple cancels if needed.)
}


implementation

{$R *.dfm}

uses fEncounterFrame, fOrders, uOrders, fNotes, fNetworkMessengerClient,
     fTMGDiagnoses,
     uCore;

procedure TfrmEnounterLabs.btnClearMemoClick(Sender: TObject);
var MsgResult : integer;
begin
  inherited;
  //Clear memo and also clear lab orders...
  if OrderIDSL.Count>0 then begin
    MsgResult := MessageDlg('Are you sure you want to Clear output AND Cancel Orders', mtConfirmation, [mbOK, mbCancel], 0);
    if MsgResult <> mrOK then exit;
    OrderTextSLs.Clear;
    LabOrderMessages.Clear;
    DiscontinueLabsOrdered;
  end;
  if OrderTextSLs.Count>0 then OrderTextSLs.Clear;
  if LabOrderMessages.Count>0 then LabOrderMessages.Clear;
  memOutput.Lines.Clear;
  SetDirtyStatus(False);
end;

procedure TfrmEnounterLabs.ClearOrderSL;
  var i : integer;
begin
  for i := 0 to OrderTextSLs.Count - 1 do begin
    TStringList(OrderTextSLs[i]).Free; //kt each element is a TStringList, holding 1 lab OrderTextSL.
  end;
end;

procedure TfrmEnounterLabs.btnLaunchLabDlgClick(Sender: TObject);
var i, index : integer;
    ItemName : string;
    SelectedDxInfo : TStringList;
    //SavedNeedsModal : boolean;

const TMG_LAB_ORDER_NAME = 'TMG Lab Order';
begin
  inherited;
  frmOrders.EnsureLstWriteLoaded();
  index := -1;
  for i := 0 to frmOrders.lstWrite.Items.Count - 1 do begin
    ItemName := Piece(frmOrders.lstWrite.Items[i], '^', 2);
    if ItemName <> TMG_LAB_ORDER_NAME then continue;
    index := i;
    break;
  end;
  if index = -1 then begin
    MessageDlg('Can''t find order "'+TMG_LAB_ORDER_NAME+'".',mtError, [mbOK], 0);
    exit;
  end;

  frmOrders.CheckInit;
  frmOrders.lstWrite.ItemIndex := index;
  frmOrders.lstWriteClick(self);    //this should create and setup uOrderDialog
  if Assigned(uOrderDialog) and (uOrderDialog is TfrmODTMG1) then begin
    FLabDlg := TfrmODTMG1(uOrderDialog);
    FLabDlg.OnClosing := HandleLabDlgClosing;
    FLabDlg.LaunchedFromEncounter := true;
    DialogActive := true;
    SetReadyDisplayMode(false);
    //kt doesn't work--> FLabDlg.Parent := Self;
    if assigned(frmTMGDiagnoses) then begin
      SelectedDxInfo := TStringList.Create;
      try
        frmTMGDiagnoses.GetSelectedDxs(SelectedDxInfo);
        FLabDlg.LoadUserDxList(SelectedDxInfo);
      finally
        SelectedDxInfo.Free;
      end;
    end;
  end;
end;

procedure TfrmEnounterLabs.btnSameNonFastingLabsClick(Sender: TObject);
begin
  inherited;
  DoPseudoOrder('OK with Existing NON-FASTING Lab Order.', 'N');
end;

procedure TfrmEnounterLabs.btnNoNewLabsClick(Sender: TObject);
begin
  inherited;
  DoPseudoOrder('No new labs.', '?');
end;

procedure TfrmEnounterLabs.btnPreexistingLabsTodayClick(Sender: TObject);
begin
  inherited;
  DoPseudoOrder('Preexisting Lab Order To Be Done Today.', '?');
end;

procedure TfrmEnounterLabs.btnSameFastingLabsClick(Sender: TObject);
begin
  inherited;
  DoPseudoOrder('OK with Existing FASTING Lab Order.', 'Y');
end;

procedure TfrmEnounterLabs.btnSameLabsClick(Sender: TObject);
begin
  inherited;
  DoPseudoOrder('OK with Existing Lab Order.', '?');
end;

procedure TfrmEnounterLabs.DoPseudoOrder(Msg : string; FastingYNU : char);
var
  ALabOrderMessageSL : TStringList;
begin
  SaveOrderText(Msg);

  ALabOrderMessageSL := TStringList.Create;  //owned by LabOrderMessages
  SetupLabMsg(Msg, FastingYNU, ALabOrderMessageSL);
  LabOrderMessages.Add(ALabOrderMessageSL); // LabOrderMessages will own TStringList
end;

procedure TfrmEnounterLabs.SetupLabMsg(Msg : String; FastingYNU : char; SL : TStringList);
//SL is an output parameter.
//FORMAT:  SL[0] = Recipient^Recipient^.....
//         SL[1] = 'T' or 'F' for boolean for FPromptToPrint
//         SL[2] = MyName
//         SL[3...] = the usual content of the message.
//
var s, MyName, User, LabUser, FastingMsg : string;
begin
  if not assigned(SL) then exit;
  SL.Clear;
  if FastingYNU = 'Y' then begin
    FastingMsg := 'FASTING';
  end else if FastingYNU = 'N' then begin
    FastingMsg := 'NON-FASTING';
  end else begin
    FastingMsg := 'FASTING STATUS UNSPECIFIED or N/A';
  end;
  //
  //GET USERS AND PREPARE MESSAGE
  User := LabOrderMsgRecip('1');
  if piece(User,'^',1)='-1' then begin
    ShowMessage('Error getting User Name: '+piece(User,'^',2));
    exit;
  end;
  LabUser := LabOrderMsgRecip('2');
  if piece(LabUser,'^',1)='-1' then begin
    ShowMessage('Error getting Lab User Name: '+piece(LabUser,'^',2));
    exit;
  end;
  MyName :=  GetMyName;
  if MyName='' then begin
    ShowMessage('Error getting Current User Name');
    exit;
  end;

  s := User + '^';

  SL.Add(s);       // index 0
  SL.Add('F');     // index 1    // s := IfThen(FPromptToPrint, 'T','F');
  SL.Add(MyName);  // index 2

  SL.Add(MyName+' ORDERED LABS');
  SL.Add('');
  SL.Add(Patient.TMGMsgString);
  SL.Add('');
  SL.Add(FastingMsg);
  SL.Add('');
  SL.Add(Msg);
end;


procedure TfrmEnounterLabs.SetReadyDisplayMode(Ready: boolean);
begin
  btnLaunchLabDlg.Visible := Ready;
  btnSameNonFastingLabs.Visible := Ready;
  btnNoNewLabs.Visible := Ready;
  btnSameFastingLabs.Visible := Ready;
  btnSameLabs.Visible := Ready;
  lblLabActive.Visible := not Ready;
  lblLabActive2.Visible := not Ready;
end;

procedure TfrmEnounterLabs.HandleLabDlgClosing(Dlg : TfrmODTMG1; Data : TStringList);
//callback handler, set up in btnLaunchLabDlgClick()
//This will be called if user clicks [AcceptOrder] or [Quit]
//    If [Quit] clicked, then FLabDlg.FromQuit = TRUE, and Data will be nil
//Data FORMAT:  -- as created by TfrmODTMG1.SetupLabOrderMsg(SL : TStringList)
//              Data[0] = Recipient^Recipient^.....
//              Data[1] = 'T' or 'F' for boolean for FPromptToPrint
//              Data[2] = MyName
//              Data[3...] = the usual content of the message.
//NOTE: Data can be nil
var
  ALabOrderMessageSL : TStringList;
  FromQuit : boolean;
begin
  DialogActive := false;
  SetReadyDisplayMode(true);

  Dlg.OnClosing := nil;  //Just in case uOrderDialog(TfrmODTMG1) exists after being closed
  //Save off LabOrderMessage.  If user cancels, these will not be sent.  If not, then sent in OK2Close
  FromQuit := false;
  if assigned(FLabDlg) then FromQuit := FLabDlg.FromQuit;
  if assigned(Data) and not FromQuit then begin
    ALabOrderMessageSL := TStringList.Create;
    ALabOrderMessageSL.Assign(Data);
    LabOrderMessages.Add(ALabOrderMessageSL); // LabOrderMessages will own TStringList
  end;
  FLabDlg := nil;
end;

procedure TfrmEnounterLabs.SaveOrderText(Text : string);
var SL : TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Add(Text);
    SaveOrderText(SL);
  finally
    SL.Free;
  end;
end;

procedure TfrmEnounterLabs.SaveOrderText(SL : TStringList);
var i : integer;
    AnOrderTextSL : TStringList;
begin
  if memOutput.Lines.Count>0 then begin
    memOutput.Lines.Add('');
    memOutput.Lines.Add(' ---------------------------------- ');
    memOutput.Lines.Add('');
  end;
  for i := 0 to SL.Count - 1 do begin
    memOutput.Lines.Add(SL.Strings[i]);
  end;
  AnOrderTextSL := TStringList.Create;
  AnOrderTextSL.Assign(SL);
  OrderTextSLs.Add(AnOrderTextSL); //AnOrderTextSL will be owned by OrderTextSLs
  SetDirtyStatus(True);
end;


procedure TfrmEnounterLabs.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);    //kt added
//NOTE: This gets called when a new order is created, by TfrmFrame.UMNewOrder();
var OrderTextSL : TStringList;
    ALine : string;
    i : integer;
const UNSIGNED_STR = '*UNSIGNED*';
begin
  if AnOrder.ID <> '0' then begin   //if ID='0' then skip....
    OrderIDSL.Add(AnOrder.ID);
    OrderTextSL := TStringList.Create;
    try
      if Assigned(FLabDlg) and (FLabDlg.memOrder.Text <> '') then begin
        OrderTextSL.Assign(FLabDlg.memOrder.Lines);
      end else begin
        OrderTextSL.Text := AnOrder.Text;
      end;
      //Remove '*UNSIGNED*' if found
      for i := OrderTextSL.Count - 1 downto 0 do begin
        ALine := OrderTextSL.Strings[i];
        if Pos(UNSIGNED_STR, ALine)=0 then continue;
        ALine := Trim(Piece2(ALine,UNSIGNED_STR,1) + Piece2(ALine,UNSIGNED_STR,2));
        if ALine <> '' then begin
          OrderTextSL.Strings[i] := ALine;
        end else begin
          OrderTextSL.Delete(i);
        end;
        break;
      end;
      SaveOrderText(OrderTextSL);
    finally
      OrderTextSL.Free;
    end;
  end;
end;

procedure TfrmEnounterLabs.DiscontinueLabsOrdered;
var i : integer;
    s : string;
    AnOrder : TOrder;
    AnID : string;
    OrderSelected : boolean;
begin
  if OrderIDSL.Count>0 then begin
    //Cancel any orders that may have been generated
    for i := 0 to frmOrders.lstOrders.Items.Count - 1 do begin
      //clear any previous selections
      if frmOrders.lstOrders.Selected[i] then begin
        frmOrders.lstOrders.Selected[i] := false;  //Only set FALSE if previously true.  Avoid triggering any unneeded event.
      end;
    end;
    OrderSelected := false;
    //Now select any matching order
    for i := 0 to frmOrders.lstOrders.Items.Count - 1 do begin
      AnOrder := TOrder(frmOrders.lstOrders.Items.Objects[i]);
      AnID := AnOrder.ID;
      if OrderIDSL.IndexOf(AnID) < 0 then continue;
      frmOrders.lstOrders.Selected[i] := true;
      OrderSelected := true;
    end;
    if OrderSelected then begin
      frmOrders.mnuActDCClick(self);  //Tell Order page to DC selected orders.
    end;
  end;
end;

procedure TfrmEnounterLabs.HandleCancelClosure;
begin
  DiscontinueLabsOrdered;
end;

function TfrmEnounterLabs.OK2Close(Cancel : boolean) : boolean;  //kt added
//If user clicked on Cancel, then Cancel will = TRUE;
begin
  Result := (DialogActive = false);  // turned ON in btnLaunchLabDlgClick, and turned OFF in HandleLabDlgClosing
  if (Result = true) then begin
    if Cancel then begin
      HandleCancelClosure;
    end else begin
      //kt moved to SendData;
    end;
  end else begin
    MessageDlg('Close Lab Order Dialog First', mtWarning, [mbOK], 0);
  end;

end;


procedure TfrmEnounterLabs.btnNextClick(Sender: TObject);
begin
  inherited;
  frmEncounterFrame.SelectNextTab;
end;

constructor TfrmEnounterLabs.CreateLinked(AParent: TWinControl);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.
  inherited;
end;

procedure TfrmEnounterLabs.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_TMG_LabsNm;    // <-- required!

  btnOK.Height := 32;
  btnOK.Top := Self.Height - BtnOK.Height - 5;
  btnCancel.Height := 32;
  btnCancel.Top := BtnOK.Top;
  btnNext.Top := Self.Height - BtnNext.Height - 5;
  DialogActive := false;

  OrderIDSL := TStringList.Create; //kt
  OrderTextSLs := TList.Create; //kt   Each element will be a TStringList, holding 1 Order.Text
  LabOrderMessages := TList.Create; //kt each element will be a TStringList, holding 1 lab order message.

  IsDirty := True;
end;


procedure TfrmEnounterLabs.FormDestroy(Sender: TObject);  //kt addeed
var i : integer;
begin
  OrderIDSL.Free;  //kt
  for i := 0 to OrderTextSLs.Count - 1 do begin
    TStringList(OrderTextSLs[i]).Free; //kt each element is a TStringList, holding 1 lab OrderTextSL.
  end;
  OrderTextSLs.Free; //kt
  for i := 0 to LabOrderMessages.Count - 1 do begin
    TStringList(LabOrderMessages[i]).Free; //kt each element is a TStringList, holding 1 lab order message.
  end;
  LabOrderMessages.Free;

  inherited;
end;

procedure TfrmEnounterLabs.SendData(var SendErrors,UnpastedHTML:string);  //kt
var i,j : integer;
    OrderSelected : boolean;
    MessageArray : TStringList;
    AnOrderTextSL : TStringList;
    Result, ErrMsg : string;
    HTMLTable : TStringList;
    line : string;

begin
  if IsDirty=False then exit;
  
  TMGLabOrderAutoPopulateIfActive;

  //Insert HTML order table into note text.
  HTMLTable := TStringList.Create;
  try
    for i := 0 to OrderTextSLs.Count - 1 do begin
      AnOrderTextSL := TStringList(OrderTextSLs[i]);
      HTMLTable.Clear;
      HTMLTable.Add('<table border="0" cellspacing="2" cellpadding="0" bgcolor="#d3d3d3" TMGLABS="1">');
      for j := 0 to AnOrderTextSL.Count - 1 do begin
        Line := AnOrderTextSL[j];
        HTMLTable.Add('<tr bgcolor="#f2f2f2">');
        HTMLTable.Add('<td>'+Line+'</td>');
        HTMLTable.Add('</tr>')
      end;
      HTMLTable.Add('</table>');
      HTMLTable.Add('<p><DIV name="'+HTML_TARGET_LABS+'"></DIV>');
      frmNotes.InsertLabOrderTextBox(HTMLTable,SendErrors,UnpastedHTML);  //Push order text to note.
    end;
    OrderTextSLs.Clear;
  finally
    HTMLTable.Free;
  end;

  //Send LabOrderMessages to other members of staff
  for i := 0 to LabOrderMessages.Count - 1 do begin
    MessageArray := TStringList(LabOrderMessages[i]);
    fODTMG1.SendLabOrderMsg(MessageArray);   //this is a global UNIT function, not a class function
  end;
  LabOrderMessages.Clear;

end;

procedure TfrmEnounterLabs.SetDirtyStatus(DirtyStatus:boolean);
begin
  IsDirty := DirtyStatus;
  frmEncounterFrame.SetCurrentTabAsDirty(DirtyStatus);
end;

end.
