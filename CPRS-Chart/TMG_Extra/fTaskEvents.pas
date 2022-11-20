unit fTaskEvents;

//added by K.Toppenberg on 10/30/22

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, StrUtils, Math,
  rCore, uCore, ORFn, ORNet, ORDtTm, ORCtrls;

type
  TTaskEventData = class(TObject)
  public
    IEN : string;  //ien in file# 22750 (TMG TASK EVENTS)
    PatientDFN : string;
    DateCreated, ActionDate: TFMDateTime;
    Description: String;
    Status: String;
    Notes: TStringList;
    ParentIEN : string;
    ResponsiblePerson: string;
    ResponsiblePersonIEN: string;
    CreatedByPerson: string;
    CreatedByPersonIEN: string;
    ServerUnmodifiedData : TTaskEventData; //doesn't own object. Will be nil for original server objects.  Ignored for Equals()
    Updates : TStringList;  //will hold list of IEN's (if any).  These will be children objects.  UPDATE: NOT USED....
    LinkedTreeNode : TTreeNode; //doesn't own object
    function Equals(Other : TTaskEventData) : boolean;
    procedure Subtract(Other : TTaskEventData);
    procedure ToGlobalFormat(SL : TStringList);
    function HasData : boolean;
    function IsModified : boolean;
    procedure Assign(Source : TTaskEventData);
    constructor Create(); overload;
    constructor Create(ACopySource : TTaskEventData); overload;
    destructor Destroy();
  end;

  TTaskEventDataList = class(TList)
  private
    function Get(Index: Integer): TTaskEventData;
    procedure Put(Index: Integer; Item: TTaskEventData);
  public
    function IndexOf(Item: TTaskEventData): Integer;
    function IndexOfIEN(IEN : string): Integer;
    function IsModified : boolean;
    procedure Insert(Index: Integer; Item: TTaskEventData);
    procedure FreeAndClearAll;
    function GetByIEN(IEN : string) : TTaskEventData;
    property Items[Index: Integer]: TTaskEventData read Get write Put; default;
  end;

  TfrmEditTaskEvents = class(TForm)
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    pnlRight: TPanel;
    leDescription: TLabeledEdit;
    cboStatus: TComboBox;
    memNotes: TMemo;
    btnCancel: TBitBtn;
    btnApply: TBitBtn;
    lblStatus: TLabel;
    cboResponsiblePerson: TORComboBox;
    lblResponsiblePerson: TLabel;
    btnAdd: TBitBtn;
    lblActionDate: TLabel;
    tvTaskEventList: TORTreeView;
    leDateCreated: TLabel;
    btnAddFollowup: TBitBtn;
    btnDone: TBitBtn;
    btnDelete: TBitBtn;
    ordtActionDate: TORDateBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDoneClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure tvTaskEventListChange(Sender: TObject; Node: TTreeNode);
    procedure btnAddFollowupClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure memNotesChange(Sender: TObject);
    procedure leDescriptionChange(Sender: TObject);
    procedure cboResponsiblePersonChange(Sender: TObject);
    procedure ordtActionDateChange(Sender: TObject);
    procedure cboStatusChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure cboResponsiblePersonNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: Integer);
  private
    { Private declarations }
    DataList: TTaskEventDataList;
    ServerUnmodifiedData : TTaskEventDataList;
    SetInfo : TStringList;
    LoadingGUI : boolean;
    DataInGUI : TTaskEventData; //doesn't own object
    AddedIndex : integer;
    function  AddTE(ParentData: TTaskEventData) : TTaskEventData;
    procedure ClearData(ADataList : TTaskEventDataList);
    procedure Data2Form(Data: TTaskEventData);
    procedure SetStatus(Value: String);
    procedure SetButtonEnableStatus(mode : string);
    procedure LoadFromServer(ADataList: TTaskEventDataList; SetInfo : TStringList);
    procedure Initialize(InitialIEN: string = '');
    procedure CopyDataList(Source, Dest : TTaskEventDataList);
    function  ParseOneIEN(SL: TStringList) : TTaskEventData;
    procedure ParseStatusSetInfo(SetInfo : TStringList; Line : string);
    procedure CallReadPRC(Results : TStringList; SDT, EDT : TFMDateTime);
    function CallPostPRC(DataSL : TStringList) : string;
    procedure LoadTreeView(DataList : TTaskEventDataList);
    function  TreeNodeStr(Data : TTaskEventData) : string;
    function  GetTreeNodeByIEN(IEN : string) : TTreeNode;
    procedure SelectTreeNodeByData(Data : TTaskEventData);
    procedure PostDataIfNeeded();
    procedure FixAddedData(InfoIENStr : string);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy();
    { Public declarations }
  end;

//var
//  frmEditTaskEvents: TfrmEditTaskEvents;

function LaunchTaskEvent(InitialIEN: string = '') : integer; //returns modal result
function AddTaskEvent(EditMode : boolean; Description: String; ActionDate: TFMDateTime=0) : integer;  //returns modal result or mrOK

implementation

{$R *.dfm}
//========================================================================

  function LaunchTaskEvent(InitialIEN: string = '') : integer;
  //Notice: I could later modify form such that it could be used WITHOUT CPRS
  //        having a patient opened.  To do so, I would need to pass in ADFN parameter
  //        and create a custom, local TPatient, and set it's DFN, and use that.
  var
    frmEditTaskEvents : TfrmEditTaskEvents;
  begin
    Result := 0;
    frmEditTaskEvents := TfrmEditTaskEvents.create(nil);
    try
      frmEditTaskEvents.Initialize(InitialIEN);
      Result := frmEditTaskEvents.ShowModal;
    finally
      FreeAndNil(frmEditTaskEvents);
    end;
  end;

  function AddTaskEvent(EditMode : boolean;
                        Description: String;
                        ActionDate: TFMDateTime=0
                       ) : integer;
  //EditMode: if true, then form will be opened for further editing.  If false, then task is added silently.
  //NOTE: If ActionData is not passed, then default value of 0 will be changed to NOW

  //Notice: I could later modify form such that it could be used WITHOUT CPRS
  //        having a patient opened.  To do so, I would need to pass in ADFN parameter
  //        and create a custom, local TPatient, and set it's DFN, and use that.
  var
    frmEditTaskEvents : TfrmEditTaskEvents;
    AData         : TTaskEventData;
  begin
    Result := 0;
    frmEditTaskEvents := TfrmEditTaskEvents.create(nil);
    try
      frmEditTaskEvents.Initialize(InitialIEN);
      AData := frmEditTaskEvents.AddTE(nil)
      if ActionDate = 0 then ActionDate := FMDTNow;
      AData.ActionDate := ActionDate;
      AData.Description := Description;
      if EditMode then begin
        Result := frmEditTaskEvents.ShowModal;
      end else begin
        frmEditTaskEvents.PostDataIfNeeded;
        Result := mrOK;
      end;
    finally
      FreeAndNil(frmEditTaskEvents);
    end;
  end;

//========================================================================

  function TTaskEventDataList.Get(Index: Integer): TTaskEventData;
  begin
    Result := TTaskEventData(Self.List[Index]);
  end;

  procedure TTaskEventDataList.Put(Index: Integer; Item: TTaskEventData);
  begin
    Inherited Put(index, Item);
  end;

  function TTaskEventDataList.IndexOf(Item: TTaskEventData): Integer;
  begin
    Result := Inherited IndexOf(Item);
  end;

  function TTaskEventDataList.IndexOfIEN(IEN : string): Integer;
  var i : integer;
  begin
    Result := -1;
    for i := 0 to Self.Count - 1 do begin
      if Self.Items[i].IEN <> IEN then continue;
      Result := i;
      break;
    end;
  end;

  function TTaskEventDataList.GetByIEN(IEN : string) : TTaskEventData;
  var i : integer;
      Item : TTaskEventData;
  begin
    Result := nil;
    if IEN = '' then exit;
    for i := 0 to Self.Count - 1 do begin
      Item := Self.Items[i];
      if Item.IEN <> IEN then continue;
      Result := Item;
      break;
    end;
  end;

  function TTaskEventDataList.IsModified : boolean;
  var i : integer;
  begin
    Result := false;
    for i := 0 to Self.Count - 1 do begin
      if Self.Items[i].IsModified = false then continue;
      Result := true;
      break;
    end;
  end;

  procedure TTaskEventDataList.Insert(Index: Integer; Item: TTaskEventData);
  begin
    Inherited Insert(index, Item);
  end;

  procedure TTaskEventDataList.FreeAndClearAll;
  var i : integer;
  begin
    for i := 0 to Self.Count - 1 do Self.Items[i].Free;
    Self.Clear;
  end;


//========================================================================
  constructor TTaskEventData.Create();
  begin
    inherited Create();
    IEN := '';
    PatientDFN := '';
    DateCreated := 0;
    ActionDate := 0;
    Description := '';
    Status := '';
    ParentIEN := '';
    ResponsiblePerson := '';
    ResponsiblePersonIEN := '';
    CreatedByPerson := '';
    CreatedByPersonIEN := '';
    ServerUnmodifiedData := nil;
    Updates := TStringList.Create;  //will hold list if IEN's (if any).
    Notes := TStringList.Create;
  end;

  constructor TTaskEventData.Create(ACopySource : TTaskEventData);
  begin
    Self.Create();
    Self.Assign(ACopySource);
  end;

  destructor TTaskEventData.Destroy();
  begin
    Updates.Free;
    Notes.Free;
    inherited Destroy();
  end;

  function TTaskEventData.IsModified : boolean;
  begin
    Result := true;
    if Self.IEN = '' then exit;
    if not Assigned(ServerUnmodifiedData) then exit;
    result := not Self.Equals(ServerUnmodifiedData);
  end;

  procedure TTaskEventData.Assign(Source : TTaskEventData);
  begin
    Self.IEN                  := Source.IEN;
    Self.PatientDFN           := Source.PatientDFN;
    Self.DateCreated          := Source.DateCreated;
    Self.ActionDate           := Source.ActionDate;
    Self.Description          := Source.Description;
    Self.Status               := Source.Status;
    Self.ParentIEN            := Source.ParentIEN;
    Self.ResponsiblePerson    := Source.ResponsiblePerson;
    Self.ResponsiblePersonIEN := Source.ResponsiblePersonIEN;
    Self.CreatedByPerson      := Source.CreatedByPerson;
    Self.CreatedByPersonIEN   := Source.CreatedByPersonIEN;
    Self.LinkedTreeNode       := Source.LinkedTreeNode;
    Self.Notes.Assign(Source.Notes);
    Self.Updates.Assign(Source.Updates);
    Self.ServerUnmodifiedData := Source.ServerUnmodifiedData;
  end;

  function TTaskEventData.Equals(Other : TTaskEventData) : boolean;
  begin
    Result := (Self.IEN                  = Other.IEN) and
              (Self.PatientDFN           = Other.PatientDFN) and
              (Self.DateCreated          = Other.DateCreated) and
              (Self.ActionDate           = Other.ActionDate) and
              (Self.Description          = Other.Description) and
              (Self.Status               = Other.Status) and
              (Self.ParentIEN            = Other.ParentIEN) and
              (Self.ResponsiblePerson    = Other.ResponsiblePerson) and
              (Self.ResponsiblePersonIEN = Other.ResponsiblePersonIEN) and
              (Self.CreatedByPerson      = Other.CreatedByPerson) and
              (Self.CreatedByPersonIEN   = Other.CreatedByPersonIEN) and
              //(Self.LinkedTreeNode       = Other.LinkedTreeNode) and
              (Self.Notes.Text           = Other.Notes.Text) and
              (Self.Updates.Text         = Other.Updates.Text);
  end;

  procedure TTaskEventData.Subtract(Other : TTaskEventData);
    //This function aims to make self hold only changes compared to Other.
    function Diff(SelfValue, OtherValue : string) : string;
    (*  +---------+----------+  +----------+
        |  Self   | Other    |  | Result   |
        +=========+==========+  +==========+
        |  'ABC'  | 'ABC'    |  |  ''      |
        +---------+----------+  +----------+
        |  ''     | 'ABC'    |  |  '@'     |
        +---------+----------+  +----------+
        |  'ABC'  | ''       |  |  'ABC'   |
        +---------+----------+  +----------+
        |  'XYZ'  | 'ABC'    |  |  'XYZ'   |
        +---------+----------+  +----------+
        | (OTHER) |(OTHER)   |  |  ''      |
        +---------+----------+  +----------+   *)

    begin
      if OtherValue = SelfValue then begin
        Result := '';
      end else if (SelfValue = '') and (OtherValue <> '') then begin
        Result := '@';
      end else if (SelfValue <> '') and (OtherValue = '') then begin
        Result := SelfValue;
      end else if (SelfValue = OtherValue) then begin
        Result := '';
      end else begin
        Result := SelfValue;
      end;
    end;

    function DTDiff(SelfValue, OtherValue : TFMDateTime) : TFMDateTime;
    (*  +---------+----------+  +----------+
        |  Self   | Other    |  | Result   |
        +=========+==========+  +==========+
        |  123    | 123      |  |  -1      |   //-1 will mean don't file.
        +---------+----------+  +----------+
        |  0      | 123      |  |  0       |
        +---------+----------+  +----------+
        |  123    | 0        |  |  123     |
        +---------+----------+  +----------+
        |  789    | 123      |  |  123     |
        +---------+----------+  +----------+
        | (OTHER) |(OTHER)   |  |  0       |
        +---------+----------+  +----------+   *)

    begin
      if OtherValue = SelfValue then begin
        Result := -1;
      end else if (SelfValue = 0) and (OtherValue <> 0) then begin
        Result := 0;
      end else if (SelfValue <> 0) and (OtherValue = 0) then begin
        Result := SelfValue;
      end else if (SelfValue <> OtherValue) then begin
        Result := SelfValue;
      end else begin
        Result := 0;
      end;
    end;

  begin
    if not Assigned(Other) then exit;
    //don't change or consider .IEN or .PatientDFN
    DateCreated          := DTDiff(Self.DateCreated, Other.DateCreated);
    ActionDate           := DTDiff(Self.ActionDate, Other.ActionDate);
    Description          := Diff(Self.Description, Other.Description);
    Status               := Diff(Self.Status, Other.Status);
    ParentIEN            := Diff(Self.ParentIEN, Other.ParentIEN);
    ResponsiblePerson    := Diff(Self.ResponsiblePerson, Other.ResponsiblePerson);
    ResponsiblePersonIEN := Diff(Self.ResponsiblePersonIEN , Other.ResponsiblePersonIEN);
    CreatedByPerson      := Diff(Self.CreatedByPerson, Other.CreatedByPerson);
    CreatedByPersonIEN   := Diff(Self.CreatedByPersonIEN   , Other.CreatedByPersonIEN);
    Notes.Text           := Diff(Self.Notes.Text, Other.Notes.Text);
    Updates.Text         := Diff(Self.Updates.Text, Other.Updates.Text);
    //NOTE: will not consider  Self.LinkedTreeNode
  end;


  procedure TTaskEventData.ToGlobalFormat(SL : TStringList);
  (*  Planned format:   Will copy the data structure from FM file
      IEN#^0^PatientDFN^DateCreated^Status^ActionDate^ParentIEN^ResponsiblePersonIEN^CreateByPersonIEN
      IEN#^1^Description
      IEN#^2^sub#^0^NOTES WP lines
      IEN#^10^sub#^0^Child IEN#                                              *)

    function DTStr(value: TFMDateTime) : string;
    begin
      Result := IfThen(value > 0, FloatToStr(value), '');
    end;

    function IENStr(value : string) : string;
    begin
      if value = '' then begin
        Result := '';
      end else if value = '@' then begin
        Result := '@';
      end else if StrToIntDef(value,0)>0 then begin
        Result := '`' + value;
      end else begin
        Result := '';
      end;
    end;

  var
    s : string;
    i : integer;
  begin
    if not Assigned(SL) then exit;
    s := IEN+'^0^'+IENStr(PatientDFN)+'^'+DTStr(DateCreated)+'^'+Status+'^'+DTStr(ActionDate)+'^'
         +IENStr(ParentIEN)+'^'+IENStr(ResponsiblePersonIEN)+'^'+IENStr(Self.CreatedByPersonIEN);
    SL.Add(s);
    s := IEN+'^1^'+Description;
    SL.Add(s);
    for i := 0 to Self.Notes.Count - 1 do begin
      s := IEN+'^2^' + IntToStr(i+1)+'^'+Self.Notes.Strings[i];
      SL.Add(s);
    end;
    for i := 0 to Self.Updates.Count - 1 do begin
      s := IEN+'^10^' + IntToStr(i+1)+'^'+Self.Updates.Strings[i];
      SL.Add(s);
    end;
  end;

  function TTaskEventData.HasData : boolean;
  begin
    //When getting ready to post, unchanged info is removed.
    //This function will return if any data is left, that will need to be posted.
    //Don't change or consider .IEN or .PatientDFN
    Result := true;
    if DateCreated          <> -1 then exit;
    if ActionDate           <> -1 then exit;
    if Description          <> '' then exit;
    if Status               <> '' then exit;
    if ParentIEN            <> '' then exit;
    if ResponsiblePerson    <> '' then exit;
    if ResponsiblePersonIEN <> '' then exit;
    if CreatedByPerson      <> '' then exit;
    if CreatedByPersonIEN   <> '' then exit;
    if Notes.Text           <> '' then exit;
    if Updates.Text         <> '' then exit;
  end;


//========================================================================

constructor TfrmEditTaskEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DataList := TTaskEventDataList.Create;
  ServerUnmodifiedData := TTaskEventDataList.Create;;
  SetInfo := TStringList.Create;
  DataInGUI := nil;
  AddedIndex := 0;
end;

destructor TfrmEditTaskEvents.Destroy();
begin
  ServerUnmodifiedData.FreeAndClearAll;  //frees contained itesm
  ServerUnmodifiedData.Free;             //frees the list itself
  DataList.FreeAndClearAll;              //frees contained itesm
  DataList.Free;                         //frees the list itself
  SetInfo.Free;
  inherited Destroy();
end;

procedure TfrmEditTaskEvents.cboResponsiblePersonNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmEditTaskEvents.ClearData(ADataList : TTaskEventDataList);
var i: integer;
begin
  for i := 0 to ADataList.Count - 1 do begin
    TTaskEventData(ADataList[i]).Free;
  end;
  ADataList.clear;
end;

procedure TfrmEditTaskEvents.Data2Form(Data: TTaskEventData);
begin
  DataInGUI := Data;
  LoadingGUI := true;
  try
    if Assigned(Data) then begin
      leDateCreated.Enabled := true;
      leDateCreated.Caption := 'Date Created: ' + FormatFMDateTime('mmm d, yyyy', Data.DateCreated) + ' by ' + Data.CreatedByPerson;
      lblStatus.Enabled := true;
      cboStatus.Enabled := true;
      SetStatus(Data.Status);
      lblActionDate.Enabled := true;
      ordtActionDate.Enabled := true;
      ordtActionDate.FMDateTime := Data.ActionDate;
      cboResponsiblePerson.Enabled := true;
      lblResponsiblePerson.Enabled := true;
      cboResponsiblePerson.InitLongList(Data.ResponsiblePerson);
      cboResponsiblePerson.SelectByIEN(StrToIntDef(Data.ResponsiblePersonIEN,0));
      leDescription.Enabled := true;
      leDescription.Text := Data.Description;
      memNotes.Enabled := true;
      memNotes.Lines.Assign(Data.Notes);
    end else begin
      // set all controls to empty and disabled.
      leDateCreated.Enabled := false;
      leDateCreated.Caption := '';
      lblStatus.Enabled := false;
      cboStatus.Enabled := false;
      cboStatus.ItemIndex := -1;
      lblActionDate.Enabled := false;
      ordtActionDate.Enabled := false;
      ordtActionDate.FMDateTime := 0;
      lblResponsiblePerson.Enabled := false;
      cboResponsiblePerson.Enabled := false;
      leDescription.Enabled := false;
      leDescription.Text := '';
      memNotes.Enabled := false;
      memNotes.Lines.Clear;
    end;
  finally
    LoadingGUI := false;
  end;
  SetButtonEnableStatus('check');
end;

procedure TfrmEditTaskEvents.SetButtonEnableStatus(mode : string);
var Modified : boolean;
begin
  if mode = 'check' then begin
    modified := DataList.IsModified;  // <-- this may be computationally expensive
  end else if mode = 'true' then begin
    modified := true;
  end;
  btnApply.Enabled := Modified;
  //btnCancel.Enabled := Modified;
  btnCancel.Enabled := true;
  btnDone.Enabled := true;
  if DataInGUI = nil then begin
    btnAddFollowup.Enabled := false;
    //btnCancel.Enabled      := false;
    btnDelete.Enabled      := false;
  end else begin
    btnAddFollowup.Enabled := true;
    btnDelete.Enabled      := true;
  end;
end;

procedure TfrmEditTaskEvents.SetStatus(Value: String);
//NOTE: The input will be the internal form of the data, e.g. 'P' for 'Pending'
var i : integer;
    found : boolean;
    s : string;
begin
  found := false;
  for i := 0 to SetInfo.Count - 1 do begin
    s := SetInfo.Names[i];
    if s <> Value then continue;
    found := true;
    cboStatus.ItemIndex := i;
    break;
  end;
  if not found then cboStatus.ItemIndex := -1;  
end;

procedure TfrmEditTaskEvents.tvTaskEventListChange(Sender: TObject; Node: TTreeNode);
var Data : TTaskEventData;
begin
  if assigned(Node) then begin
    Data := TTaskEventData(Node.Data);
  end else begin
    Data := nil;
  end;
  if Data <> DataInGUI then begin
    Data2Form(Data);
  end;
end;

procedure TfrmEditTaskEvents.Initialize(InitialIEN: string = '');
//InitialIEN is IEN in TMG TASK EVENTS (#22750) file .  If provided, then selected.
var i : integer;
    StatusName : string;
    InitialNode : TTreeNode;
    InitialData : TTaskEventData;
begin
  Self.Caption := 'Task Events for ' + Patient.Name + ' (' + FormatFMDateTime('mm/dd/yyyy', Patient.DOB) + ')';
  ServerUnmodifiedData.FreeAndClearAll;  //frees contained itesm
  DataList.FreeAndClearAll;              //frees contained itesm
  LoadFromServer(ServerUnmodifiedData, SetInfo);
  CopyDataList(ServerUnmodifiedData, DataList);
  //load status set info
  cboStatus.Items.Clear;
  for i := 0 to SetInfo.Count - 1 do begin
    StatusName := SetInfo.ValueFromIndex[i];
    cboStatus.Items.Add(StatusName);  //NOTICE: index order of cboStatus.Items should be same as SetInfo
  end;
  cboStatus.ItemIndex := 0;
  cboResponsiblePerson.InitLongList('A');
  LoadTreeView(DataList);
  InitialData := nil;
  InitialNode := GetTreeNodeByIEN(InitialIEN);  //OK to pass '', will return nil
  if Assigned(InitialNode) then InitialData := TTaskEventData(InitialNode.Data);
  if Assigned(InitialData) then begin
    SelectTreeNodeByData(InitialData); //Should effect a Data2Form via tvTaskEventListChange
  end else begin
    Data2Form(nil);
  end;
end;

procedure TfrmEditTaskEvents.CopyDataList(Source, Dest : TTaskEventDataList);
var i : integer;
    AData, CopyData: TTaskEventData;
begin
  ClearData(Dest);
  for i := 0 to Source.Count - 1 do begin
    AData := TTaskEventData(Source[i]);
    CopyData := TTaskEventData.Create(AData);
    CopyData.ServerUnmodifiedData := AData;
    Dest.Add(CopyData);
  end;
end;

procedure TfrmEditTaskEvents.LoadFromServer(ADataList: TTaskEventDataList;  SetInfo : TStringList);
(*  Format:   Will copy the data structure from FM file, with extra in first 0^ node.
    0^Status Set info, e.g. P:Pending,C:Completed....   <--- get from ^DD(22750,.03,0)
    IEN#^0^Name^DateCreated^Status^ActionDate^ParentIEN^ResponsiblePersonIEN^CreateByPersonIEN
    IEN#^1^Description
    IEN#^2^line#^0^NOTES WP lines
    IEN#^10^sub#^0^Child IEN#                                                                  *)

var i : integer;
    OneSL : TStringList;
    Line, LineIEN, CurrentIEN : string;
    Results : TStringList;
    AData : TTaskEventData; //pointed-to object(s) will be owned by DataList
    SDT, EDT : TFMDateTime;
begin
  Results := TStringList.Create;
  SDT := 0;
  EDT := 9999999;
  CallReadPRC(Results, SDT, EDT);
  OneSL := TStringList.Create;
  CurrentIEN := '-1';
  for i := 0 to Results.Count - 1 do begin
    Line := Results.Strings[i];
    LineIEN := piece(Line,'^', 1); if LineIEN = '' then continue;
    if LineIEN = '0' then begin
      ParseStatusSetInfo(SetInfo, Line);  //loads information info self.SetInfo
      continue;
    end;
    if LineIEN <> CurrentIEN then begin
      if OneSL.Count > 0 then begin
        AData := ParseOneIEN(OneSL);  //creates new TTaskEventData
        ADataList.Add(AData);
        OneSL.Clear;
      end;
      CurrentIEN := LineIEN;
    end;
    OneSL.Add(Line);
  end;
  if OneSL.Count > 0 then begin
    AData := ParseOneIEN(OneSL);  //creates new TTaskEventData
    ADataList.Add(AData);
  end;
  OneSL.Free;
  Results.Free;
end;

procedure TfrmEditTaskEvents.ParseStatusSetInfo(SetInfo : TStringList; Line : string);
//Expected input: 0^StatusSetInfo
//           e.g. 0^P:Pending;U:Urgent;C:Completed;
var Info, value : string;
    i : integer;
begin
  SetInfo.Clear;
  Info := piece(Line,'^',2);
  i := 1;
  repeat
    value := piece(Info,';',i); //format example:  P:Pending
    if value <> '' then begin
      SetInfo.Add(value);
      inc(i);
    end;
  until value = '';
  SetInfo.NameValueSeparator := ':';
end;

function TfrmEditTaskEvents.ParseOneIEN(SL: TStringList) : TTaskEventData;
(*  Planned format:   Will copy the data structure from FM file
    IEN#^0^PatientIEN^DateCreated^Status^ActionDate^ParentIEN^ResponsiblePersonIEN|Name^CreateByPersonIEN|name
    IEN#^1^Description
    IEN#^2^sub#^0^NOTES WP lines
    IEN#^10^sub#^0^Child IEN#                                              *)

var i,j : integer;
    Line, node, value : string;
begin
  Result := TTaskEventData.Create();
  for i := 0 to SL.Count - 1 do begin
    Line := SL.Strings[i];
    if Result.IEN = '' then Result.IEN := piece(Line,'^',1);
    node := piece(Line,'^',2);
    if node = '0' then begin
      for j := 4 to 9 do begin
        value := piece(Line,'^',j);
        case j of
          4 : Result.DateCreated := FMDTStrToFMDT(value);
          5 : Result.Status := value;
          6 : Result.ActionDate := FMDTStrToFMDT(value);
          7 : Result.ParentIEN := value;
          8 : begin
                Result.ResponsiblePersonIEN := piece(value,'|', 1);
                Result.ResponsiblePerson    := piece(value,'|', 2);
              end;
          9 : begin
                Result.CreatedByPersonIEN := piece(value, '|', 1);
                Result.CreatedByPerson    := piece(value, '|', 2);
              end;
          //NOTE: if extra cases added above, be sure to extend params of j for loop.
        end;
      end;
    end else if node = '1' then begin
      Result.Description := piece(Line,'^',3);
    end else if node = '2' then begin
      Result.Notes.Add(piece(Line,'^',5));
    end else if node = '10' then begin
      Result.Updates.Add(piece(Line,'^',5));
    end;
  end;
end;

function TfrmEditTaskEvents.AddTE(ParentData: TTaskEventData) : TTaskEventData;
var AData : TTaskEventData;
begin
  AData := TTaskEventData.Create();   //empty, default item.
  AData.PatientDFN           := Patient.DFN;
  AData.DateCreated          := FMDTNow;
  AData.ResponsiblePerson    := User.Name;
  AData.ResponsiblePersonIEN := IntToStr(User.DUZ);
  AData.CreatedByPerson      := User.Name;
  AData.CreatedByPersonIEN   := IntToStr(User.DUZ);
  Inc(AddedIndex);
  AData.IEN := '+' + IntToStr(AddedIndex);
  if Assigned(ParentData) then begin
    //If ParentData object has a parent, set AData's parent to that grandparent IEN
    AData.ParentIEN := IfThen(ParentData.ParentIEN <> '', ParentData.ParentIEN, ParentData.IEN);
  end;
  DataList.Add(AData);
  //LoadTreeView(DataList);
  //SelectTreeNodeByData(AData);
  Result := AData;
end;

procedure TfrmEditTaskEvents.btnAddClick(Sender: TObject);
var AData := TTaskEventData;
begin
  AData := AddTE(nil);
  LoadTreeView(DataList);
  SelectTreeNodeByData(AData);

end;

procedure TfrmEditTaskEvents.btnAddFollowupClick(Sender: TObject);
var AData := TTaskEventData;
begin
  AData := AddTE(DataInGUI);
  LoadTreeView(DataList);
  SelectTreeNodeByData(AData);
  SetButtonEnableStatus('true');
end;

procedure TfrmEditTaskEvents.leDescriptionChange(Sender: TObject);
var  ANode : TTreeNode;
begin
  if LoadingGUI then exit;
  if not Assigned(DataInGUI) then exit;
  DataInGUI.Description := leDescription.Text;
  ANode := DataInGUI.LinkedTreeNode;
  if Assigned(ANode) then begin
    tvTaskEventList.Items.BeginUpdate;
    ANode.Text := TreeNodeStr(DataInGUI);
    tvTaskEventList.Items.EndUpdate;
  end;
end;


procedure TfrmEditTaskEvents.SelectTreeNodeByData(Data : TTaskEventData);
var i : integer;
    Node : TTreeNode;
begin
  if not Assigned(Data) then exit;
  for i := 0 to tvTaskEventList.Items.Count - 1 do begin
    Node := tvTaskEventList.Items.Item[i];
    if Node.Data <> Data then continue;
    tvTaskEventList.Select(Node);
    tvTaskEventListChange(nil, Node);
    //tvTaskEventListClick(nil);
  end;
end;

procedure TfrmEditTaskEvents.LoadTreeView(DataList : TTaskEventDataList);
var i : integer;
    TE : TTaskEventData;
    Root, AParentNode, ANode : TTreeNode;

begin
  tvTaskEventList.Items.BeginUpdate;
  tvTaskEventList.Items.Clear;
  for i := 0 to DataList.Count - 1 do DataList.Items[i].LinkedTreeNode := nil;
  Root := tvTaskEventList.Items.Add(nil, 'Tasks/Events');
  //Load top-level items from DataList into TreeView
  for i := 0 to DataList.Count - 1 do begin
    TE := DataList.Items[i];
    if TE.ParentIEN <> '' then continue;  //will add children nodes later....
    //Str := FormatFMDateTime('mm/dd/yyyy', TE.DateCreated) + ' - ' + TE.Description;
    ANode := tvTaskEventList.Items.AddChildObject(Root, TreeNodeStr(TE), TE);
    TE.LinkedTreeNode := ANode;
  end;
  //Load children items from DataList into TreeView
  for i := 0 to DataList.Count - 1 do begin
    TE := DataList.Items[i];
    if TE.ParentIEN = '' then continue;  //only process children nodes....
    //Str := FormatFMDateTime('mm/dd/yyyy', TE.DateCreated) + ' - ' + TE.Description;
    AParentNode := GetTreeNodeByIEN(TE.ParentIEN);
    if not Assigned(AParentNode) then continue;
    ANode := tvTaskEventList.Items.AddChildObject(AParentNode, TreeNodeStr(TE), TE);
    TE.LinkedTreeNode := ANode;
  end;
  Root.Expand(true);
  tvTaskEventList.Items.EndUpdate;
end;

function TfrmEditTaskEvents.GetTreeNodeByIEN(IEN : string) : TTreeNode;
var i : integer;
    Node : TTreeNode;
    TE : TTaskEventData;
begin
  Result := nil;
  if IEN = '' then exit;
  //Note: The Delphi documentation states that using .Items[i] can be time intensive, esp if tree has many nodes
  //      Later, if this becomes a problem, I could establish a TStringList with .strings = IEN and .object = pointer to TTreeNode
  //      And this list could be established at the time the tree is loaded.
  for i := 0 to tvTaskEventList.Items.Count - 1 do begin
    Node := tvTaskEventList.Items[i];
    TE := TTaskEventData(Node.Data);
    if not assigned(TE) then continue;
    if TE.IEN <> IEN then continue;
    Result := Node;
    break;
  end;
end;

function TfrmEditTaskEvents.TreeNodeStr(Data : TTaskEventData) : string;
begin
  Result := FormatFMDateTime('mm/dd/yyyy', Data.DateCreated) + ' - ' + Data.Description;
end;

procedure TfrmEditTaskEvents.memNotesChange(Sender: TObject);
begin
  if LoadingGUI then exit;
  if not Assigned(DataInGUI) then exit;
  DataInGUI.Notes.Assign(memNotes.Lines);
  SetButtonEnableStatus('true');
end;

procedure TfrmEditTaskEvents.ordtActionDateChange(Sender: TObject);
begin
  if LoadingGUI then exit;
  if not Assigned(DataInGUI) then exit;
  DataInGUI.ActionDate := ordtActionDate.FMDateTime;
  SetButtonEnableStatus('true');
end;

procedure TfrmEditTaskEvents.cboResponsiblePersonChange(Sender: TObject);
var Index : integer;
    cboData : string;
begin
  if LoadingGUI then exit;
  if not Assigned(DataInGUI) then exit;
  Index := cboResponsiblePerson.ItemIndex;
  cboData := cboResponsiblePerson.Items[Index];
  DataInGUI.ResponsiblePerson := piece(cboData,'^',2);
  DataInGUI.ResponsiblePersonIEN := piece(cboData,'^',1);
  SetButtonEnableStatus('true');
end;

procedure TfrmEditTaskEvents.cboStatusChange(Sender: TObject);
var i : integer;
    index : integer;
    cboData : string;
begin
  if LoadingGUI then exit;
  if not Assigned(DataInGUI) then exit;
  Index := cboStatus.ItemIndex;
  if Index > -1 then begin
    cboData := cboStatus.Items[Index];
    for i := 0 to SetInfo.Count - 1 do begin
      if SetInfo.ValueFromIndex[i] <> cboData then continue;
      DataInGUI.Status := SetInfo.Names[i];
      break;
    end;
  end else begin
    cboData := '';
    DataInGUI.Status := '';
    DataInGUI.Description := leDescription.Text;
  end;
  SetButtonEnableStatus('true');
end;

procedure TfrmEditTaskEvents.PostDataIfNeeded();
var TempData: TTaskEventData;
    SL : TStringList;
    i : integer;
    Data: TTaskEventData;
    Str,Action : string;
    
begin
  SL := TStringList.Create;
  TempData := TTaskEventData.Create;
  try
    for i := 0 to DataList.Count - 1 do begin
      Data := DataList.Items[i];
      if Data.IsModified = false then continue;
      TempData.Assign(Data);
      TempData.Subtract(TempData.ServerUnmodifiedData);
      if TempData.HasData = false then continue;  //i.e. no changes left needing posting
      TempData.ToGlobalFormat(SL);  //add each entry to same SL, and post all at once.
    end;
    Str := CallPostPRC(SL);
    Action := piece(Str,'^',2);
    if Contains(Action,'ADDED') then FixAddedData(piece(Str,'^',3));
  finally
    SL.Free;
    TempData.Free;
  end;
  SetButtonEnableStatus('check');
end;

procedure TfrmEditTaskEvents.FixAddedData(InfoIENStr : string);
//HANDLE GETTING RESULT BACK AND LOADING IENS BACK INTO DATA RECORD
//  AND CREATING AN UNMODIFIED SERVER RECORD
var
  APiece, PlusIndex,AddedIEN : string;
  i : integer;
  Data, MasterData: TTaskEventData;
begin
  i := 1;
  repeat
    APiece := piece(InfoIENStr,',',i); inc(i);
    if APiece = '' then continue;
    PlusIndex := piece(APiece,'=',1);
    if LeftStr(PlusIndex,1) <> '+' then begin
      ShowMessage('Error: Expected "+<number>", but got['+PlusIndex+']');
      continue;
    end;
    AddedIEN  := piece(APiece,'=',2);
    if StrToIntDef(AddedIEN,-1) = -1 then begin
      ShowMessage('Error: Expected an IEN <number>, but got['+AddedIEN+']');
      continue;
    end;
    Data := DataList.GetByIEN(PlusIndex);
    if not Assigned(Data) then begin
      ShowMessage('Unable to find record for ['+PlusIndex+']');
      continue;
    end;
    Data.IEN := AddedIEN;
    MasterData := TTaskEventData.Create(Data);  //Data here is exactly the same as stored on server
    Data.ServerUnmodifiedData := MasterData;
    ServerUnmodifiedData.Add(MasterData); //ServerUnmodifiedData will own object
  until APiece='';
end;

procedure TfrmEditTaskEvents.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btnDoneClick(Sender);
end;

procedure TfrmEditTaskEvents.btnApplyClick(Sender: TObject);
begin
  PostDataIfNeeded();
end;

procedure TfrmEditTaskEvents.btnCancelClick(Sender: TObject);
var Response:integer;
begin
  if DataList.IsModified then begin
    Response := MessageDlg('Some tasks have been changed.'+CRLF+'Are you sure you want to close without saving these changes?',mtConfirmation, [mbYes, mbCancel], 0);
    case Response of
      mrCancel:exit;
    end;
  end;
  ModalResult := mrCancel;
end;

procedure TfrmEditTaskEvents.btnDeleteClick(Sender: TObject);
begin
  if not Assigned(DataInGUI) then exit;
  if DataInGUI.LinkedTreeNode.HasChildren then begin
    ShowMessage('NOTE: This task has updates.'+CRLF+'You must delete the updates before deleting the task.');
    exit;
  end;
  if MessageDlg('Delete current Task / Event?'+CRLF+'NOTE: This can not be undone.',mtConfirmation, [mbYes, mbCancel], 0) = mrYes then begin
    DataInGUI.PatientDFN := '@';
    PostDataIfNeeded();
    Initialize();
  end;
end;

procedure TfrmEditTaskEvents.btnDoneClick(Sender: TObject);
var Response:integer;
begin
  if ModalResult=mrCancel then exit; //Don't execute if form is actively closing due to cancel   
  if DataList.IsModified then begin
      Response := MessageDlg('Some tasks have been changed.'+CRLF+'Would you like to save before closing?',mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      case Response of
        mrYes:PostDataIfNeeded();
        mrCancel:exit;
      end;
    end;
  ModalResult := mrOk;
end;

procedure TfrmEditTaskEvents.CallReadPRC(Results : TStringList; SDT, EDT : TFMDateTime);
begin
  CallV('TMG TASK EVENT GET LIST', [Patient.DFN, SDT, EDT]);
  Results.assign(RPCBrokerV.Results);
end;

function TfrmEditTaskEvents.CallPostPRC(DataSL : TStringList) : string;
var RPCResults:string;
begin
  Result := sCallV('TMG TASK EVENT POST DATA', [DataSL]);
  if piece(Result,'^',1)='-1' then ShowMessage(piece(RPCResults,'^',2));
end;


end.
