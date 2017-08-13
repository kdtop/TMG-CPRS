unit uCarePlan;
//VEFA-261 2added entire unit.  Copied from uTemplates and then modified.
//  I couldn't simply inherit from uTemplates without secondary issues arising.
//  Also code from dShared included.

interface

  uses StdCtrls, MSXML_TLB, ComCtrls, StrUtils, Menus,
      ORCtrls, fFrame, fNotes,
      Classes, Controls, SysUtils, Forms, ORFn, ORNet, Dialogs, uTIU, uDCSumm, Variants, uTemplates;


type
  TCPProblemData = class(TObject)
  private
  public
    ProbIEN          : string;
    Status           : string;
    Description      : string;
    ICD              : string;
    Onset            : string;
    LastModified     : string;
    SC               : string;
    SpExp            : string;
    Condition        : string;
    LOC              : string;
    LocType          : string;
    Prov             : string;
    Service          : string;
    procedure Initialize(LineData : string);
    procedure Clear;
  end;

  TCarePlanIconType = (tcpiNone,
                       tcpiExtra,
                       tcpiActive,
                       tcpiActiveExtra,
                       tcpiInactive,
                       tcpiInactiveExtra);

procedure CorrectCareplanFormat(Lines: TStrings);
procedure CheckForMultipleFieldsPerLine(Lines : TStrings);
function  CheckForOverlappingCarePlans(Text : string) : string;
function  GetHeaderName(P : integer; var Text : string): string;
function  GetFooterName(P : integer; var Text : string): string;
function  MoveBlockBack(HeaderStartP, FooterStartP, DestPos : integer; Text : string) : string;
function  MoveBlockForward(HeaderStartP, FooterStartP, DestPos : integer; Text : string) : string;
function  AfterHeaderPos(HeaderStartP : integer; Var Text : string) : integer;
function  AfterFooterPos(FooterStartP : integer; Var Text : string) : integer;
function  GetTextBetween(P1, P2 : integer; var Text : string) : string;
function  DelTextBetween(P1, P2 : integer; var Text : string) : string;
function  InsertBlockAt(BlockText : string; P : integer; Var Text : string) : string;

function  GetCarePlanTemplate(IEN8927 : string; EditMode : TcpteMode = cptemCarePlan) : TTemplate;  //VEFA-261 added
function  GetOneCPTemplate(IEN8927 : string; EditMode : TcpteMode = cptemCarePlan) : TTemplate;
procedure GetProbInfo(DataSL : TStringList);  //VEFA-261
procedure GetLinkedDxs(NeededDxs : TStringList); forward;

procedure CheckWrapForCPResult(var NewTxt : string);  //VEFA-261
function  StripNamespacePartOfName(Name : string; EditMode : TcpteMode = cptemCarePlan) : string; //VEFA-261
function  CheckNamespaceName(Name : string; EditMode : TcpteMode = cptemNormal; CurrentlyEditing : boolean = false) : string; //VEFA-261
function  TemplateNameisCP(Name : string; EditMode : TcpteMode = cptemCarePlan) : boolean; //VEFA-261
function  CarePlanTagCoreHeader(Name : string) : string; //VEFA-261
function  CarePlanTagCoreFooter(Name : string) : string;  //VEFA-261
function  CarePlanTagHeader(Name : string) : string; //VEFA-261
function  CarePlanTagFooter (Name : string) : string; //VEFA-261
procedure WrapCPSection(SL : TStrings; Name : string); //VEFA-261
function  TestTemplateForLinkedDx(Template:TTemplate) : boolean ;  //VEFA-261
function  NodeMatchesMode(Node : TTreeNode; OKIfChild : boolean; EditMode : TcpteMode = cptemCarePlan) : boolean;  //VEFA-261
function  TemplateIsCarePlan(Name : string) : boolean;  //VEFA-261
procedure HandleTemplateIfCarePlan(Template: TTemplate);  //VEFA-261
Procedure IndentMemoTextIfCarePlan(TemplatePrintName: string; var Text : string; FRichEditControl : TRichEdit);  //VEFA-261
function  AvoidDuplicateDataIfCarePlan(RE : TRichEdit; CPName : string) : boolean;  //VEFA-261
function  FindCarePlanTemplateNode(CPT: TTemplate; StartNode : TTreeNode): TTreeNode;  //VEFA-261
//function  NumPieces(const s : string; ADelim : char) : integer;  //VEFA-261
//function  Piece(const S: string; Delim: char; PieceNum: Integer): string;  overload;     //VEFA-261
//function  Piece(const S: string; Delim: string; PieceNum: Integer): string; overload;    //VEFA-261
//function  PieceNCS(const S: string; Delim: string; PieceNum: Integer): string; overload; //VEFA-261
//function  Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string; overload;     //VEFA-261
//function  Pieces(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string; overload; //VEFA-261
//function  PiecesNCS(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string;        //VEFA-261
function  FilterControlChars(s : string) : string; //VEFA-261


const
  TEMPLATE_MODE_NAME : ARRAY[cptemNormal..cptemCarePlan] of string = ('Template', 'Letter', 'Care Plan');
  NAMESPACE_TAG_FOR_MODE : ARRAY[cptemNormal..cptemCarePlan] of string     = ('(none)<VEFA>', 'Letter<VEFA>', 'CarePlan<VEFA>');
  EmptyNodeText = '<^Empty Node^>';
  CAREPLAN_TAG = 'CarePlan<VEFA>';

  ENDOF_TAG = 'End of ';
  CP_RESULT_TAG_OPEN = '-=[';   // -=[xxx]=- or  .{xx}.  or :{xxx}: or [<xxx>]  or [[xxx]]
  CP_RESULT_TAG_CLOSE = ']=-';
  CP_SECTION_LINE_TAG = '';  // '---------';
  CP_SECTION_SPACING = '';  // '     ';
  CP_BRACKET_OPEN = '{';
  CP_BRACKET_CLOSE = '}';
  CP_SECTION_HDR_TAG_OPEN = CP_SECTION_SPACING + CP_SECTION_LINE_TAG + '---' + CP_BRACKET_OPEN;
  CP_SECTION_HDR_TAG_CLOSE = CP_BRACKET_CLOSE + '--' + CP_SECTION_LINE_TAG;
  CP_SECTION_FOOTER_TAG_CORE_OPEN = CP_BRACKET_OPEN + ENDOF_TAG;
  CP_SECTION_FOOTER_TAG_OPEN = CP_SECTION_SPACING + CP_SECTION_LINE_TAG + CP_SECTION_FOOTER_TAG_CORE_OPEN;
  CP_SECTION_FOOTER_TAG_CLOSE = CP_BRACKET_CLOSE + CP_SECTION_LINE_TAG;
  CP_TEMPLATE_TAG = CAREPLAN_TAG + '-';
  CP_SECTION_OPEN = '{'+CP_TEMPLATE_TAG;
  HeaderMarkerEnd = '}--';
  MAX_STR_LEN = 9999999;
  HeaderMarkerStart = '---{CarePlan<VEFA>-';
  FooterMarkerStart = '{End of CarePlan<VEFA>-';
var
  ProblemIconsTopList : TList = nil; //VEFA-261  will act as list of integers holding Top value
  ProblemIconLeftList : TList = nil; //VEFA-261 will act as list of integers holding Left value
  ProblemIconHeight : integer; //VEFA-261
  ProblemIconWidth : Integer; //VEFA-261
  MaxProblemIconIndex : integer; //VEFA-261
  ProblemIconInfoSL : TStringList = nil; //VEFA-261
  CurrentDialogIsCarePlan : boolean; //VEFA-261
  boolECPRunning : boolean = false;
  ProblemFound : boolean;

implementation

uses
  Windows, rCarePlans, uCore, dShared,
  fCarePlanProbPicker, fCarePlan
  {,fCarePlanEditor};

const
  sLoading = 'Loading CarePlan Information...';  //VEFA-261 also defined in uTemplates


  // ------------------------------------------------------------------------------
  // ------------------------------------------------------------------------------


  procedure TCPProblemData.Initialize(LineData : string);
    //Format: ifn^Status^description^ICD^onset^Last modified^SC^SpExp^Condition^LOC^Loc.type^Prov^Service
    //NOTE: The above format is correct as it comes from the server. However, in fProbs.LoadPatientProblems the
    //      format is altered to:
    //      dfn^Status^description^onset^Last modified^SC^LOC^Prov^Service^RespProviderIEN^Loc.IEN^ServiceIEN^Loc.Type^ICD^Conditions^Service
    //NOTE: ifn=IEN in file PROBLEM (#900011)
  begin
    ProbIEN          := piece(LineData,'^',1);
    Status           := piece(LineData,'^',2);
    Description      := FilterControlChars(piece(LineData,'^',3));
    ICD              := piece(LineData,'^',14);   //formerly 4
    Onset            := piece(LineData,'^',4);    //formerly 5
    LastModified     := piece(LineData,'^',5);    //formerly 6
    SC               := piece(LineData,'^',6);    //formerly 7
    SpExp            := piece(LineData,'^',8);
    Condition        := piece(LineData,'^',9);
    LOC              := piece(LineData,'^',7);    //formerly 10
    LocType          := piece(LineData,'^',13);   //formerly 9
    Prov             := piece(LineData,'^',8);    //formerly 12
    Service          := piece(LineData,'^',9);    //formerly 13
    if ICD='' then begin
      ICD := GetProblemICD(ProbIEN);
      if piece(ICD,'^',1)='-1' then begin
        MessageDlg(piece(ICD,'^',2),mtError,[mbOK],0);
        ICD := '';
      end;
    end;
  end;

  procedure TCPProblemData.Clear;
  begin
    ProbIEN          := '';
    Status           := '';
    Description      := '';
    ICD              := '';
    Onset            := '';
    LastModified     := '';
    SC               := '';
    SpExp            := '';
    Condition        := '';
    LOC              := '';
    LocType          := '';
    Prov             := '';
    Service          := '';
  end;

  // ------------------------------------------------------------------------------
  // ------------------------------------------------------------------------------



function GetOneCPTemplate(IEN8927 : string; EditMode : TcpteMode = cptemCarePlan) : TTemplate;
var
  NeededDxs : TStringList;
  NewTemplate : TTemplate;
  DataStr : string;
begin
  Result := nil;
  StatusText(sLoading);
  NeededDxs := TStringList.Create;
  try
    DataStr := GetOneCarePlanTemplate(IEN8927);
    if DataStr = '' then exit;
    if TemplateNameisCP(Piece(DataStr,'^',4), EditMode) then begin
      DataStr := StripNamespacePartOfName(DataStr, EditMode);
    end;
    NewTemplate := AddTemplate(DataStr);
    NeededDxs.AddObject(piece(DataStr,'^',1),NewTemplate);  //ien list of templates for which linked Dx's are needed.
    Result := NewTemplate;
    GetLinkedDxs(NeededDxs);
  finally
    StatusText('');
    NeededDxs.Free;
  end;
end;



procedure GetProbInfo(DataSL : TStringList);
//Input:  DataSL[0]=ICDCode
//        DataSL[1]=ICDCode  ...
//Output: DataSL[0]=ICDCode=Status
//        DataSL[1]=ICDCode=Status  ...
  //Status: 0 -- no active careplans, no currently defined careplan templates for this problem
  //        1 -- no active careplans, but there are defined careplan templates for this problem
  //        2 -- An active careplan exits, but no additional careplan templates are defined for this problem.
  //        3 -- An active careplan exits, and additional careplan templates are defined for this problem.
  //        4 -- An inactive careplan exists, but no additional careplan templates are defined for this problem.
  //        5 -- An inactive careplan exists, and additional careplan templates are defined for this problem.

      function Status(NumActive,NumInactive,NumAvail : string) : string;
      begin
        Result := '0';
        if NumActive <> '0' then begin  //Active Careplan exists
          if NumAvail <> '0' then begin
            Result := '3'; //An active careplan exits, and additional careplan templates are defined for this problem.
          end else begin
            Result := '2'; //An active careplan exits, but no additional careplan templates are defined for this problem.
          end;
        end else begin  //NumActive='0'
          if NumInactive <> '0' then begin //Inactive Careplan exists.
            if NumAvail <> '0' then begin
              Result := '5'; //5 -- An inactive careplan exists, and additional careplan templates are defined for this problem.
            end else begin
              Result := '4';  //An inactive careplan exists, but no additional careplan templates are defined for this problem.
            end;
          end else begin  //no Inactive plans avail.
            if NumAvail <> '0' then begin
              Result := '1'; //no active careplans, but there are defined careplan templates for this problem
            end else begin
              Result := '0';  //no active careplans, no currently defined careplan templates for this problem
            end;
          end;
        end;
      end;

var   i: integer;
      ProbInfo: TStringlist;
      AddStr,DataStr : string;
      ICD,NumActive,NumInactive, NumAvail : string;

begin
  ProbInfo := TStringList.Create;
  try
     ProbInfo.Assign(GetProbListInfo(Patient.DFN,DataSL));
     DataSL.Clear;
     for i := 0 to ProbInfo.Count-1 do begin
       DataStr := ProbInfo.Strings[i];
       ICD := piece(DataStr,'=',1);
       DataStr := piece(DataStr,'=',2);
       NumActive := piece(DataStr,'^',1);
       NumInactive := piece(DataStr,'^',2);
       NumAvail := piece(DataStr,'^',3);
       AddStr := ICD+'='+Status(NumActive,NumInactive,NumAvail);
       DataSL.Add(AddStr);
     end;
  finally
     ProbInfo.Free;
  end;
end;


function TestTemplateForLinkedDx(Template: TTemplate) : boolean ;
//If TRUE returned, then template is processed.  If FALSE, then aborted.
var RPCResult: TstringList;
    RPCRst,Tmp:string;
    frmCarePlanProbPicker: TfrmCarePlanProbPicker;
    ModalResult : integer;
    tmpMenu : TMenuItem;

begin
  if LeftStr(Template.PrintName,StrLen(CP_TEMPLATE_TAG))<>CP_TEMPLATE_TAG then begin
     Result:=True;
  end else begin
     RPCResult := TStringList.Create;
     frmCarePlanProbPicker := TfrmCarePlanProbPicker.Create(Application);
     tmpMenu := nil;
     try
       Result := false;
       PatientHasLinkedDx(RPCResult,Patient.DFN,Template.ID);
       if RPCResult.Count=0 then exit;
       RPCRst:=Piece(RPCResult[0],'^',2);
       if AnsiUpperCase(RPCRst)='TRUE' then begin
         Result := True;
         exit;
       end;
       RPCResult.Delete(0);
       frmCarePlanProbPicker.Initialize(RPCResult);
       frmCarePlanProbPicker.lblCPName.Caption := Template.PrintName;
       ModalResult := frmCarePlanProbPicker.ShowModal;
       if ModalResult=mrRetry then begin  //Note: the "Go To Problems Tab" button returns modal result of "mrRetry"
         tmpMenu := TMenuItem.Create(nil);
         tmpMenu.Tag := 2; //2 is the Problem List Tab
         frmFrame.mnuChartTabClick(tmpMenu);  //simulate user clicking to change tabs.
       end else if ModalResult=mrOK then begin
         if frmCarePlanProbPicker.SelectionResult.Count > 0 then begin
           Tmp := UpdateCarePlanTemplateLinkedDxs(Template.ID,frmCarePlanProbPicker.SelectionResult,'1');   //Call PRC call to do store from here.
           if(Piece(Tmp,U,1) = '-1') then begin
             MessageDlg('Error: ' + Piece(Tmp,U,2),mtError,[mbOK],0);
           end;
         end;
         Result := true;
       end;
     finally
       RPCResult.Free;
       frmCarePlanProbPicker.Free;
       if assigned(tmpMenu) then tmpMenu.Free;
     end;
  end;
end;


function NodeMatchesMode(Node : TTreeNode; OKIfChild : boolean; EditMode : TcpteMode = cptemCarePlan) : boolean;  //VEFA-261
var DataStr : string;
    Name : string;
begin
  Result := false;
  if not Assigned(Node) then exit;
  DataStr := TORTreeNode(Node).StringData;
  Name := Piece(DataStr,'^',2);
  if (Name='') or (DataStr = '0^New Template') then begin
    Name := Node.Text;
  end;
  Result := uCarePlan.TemplateNameIsCP(Name,EditMode);
  if (Result = false) and OKIfChild and (Assigned(Node.Parent))  then begin
    Result := NodeMatchesMode(Node.Parent, true);
  end;
end;


function TemplateIsCarePlan(Name : string) : boolean;
begin
   Result := LeftStr(Name, Length(CP_TEMPLATE_TAG))=CP_TEMPLATE_TAG;
end;


function StripCarePlanTemplateTag(PrintName : string) : string;
begin
  if Pos(CP_TEMPLATE_TAG, PrintName) <> 1 then exit;
  Result := MidStr(PrintName,length(CP_TEMPLATE_TAG)+1,Length(PrintName));
end;

procedure HandleTemplateIfCarePlan(Template: TTemplate);
var RPCResult,FTargetDocIEN8925, GoalStr : string;
    CP: TCarePlan;
begin
  if not TemplateIsCarePlan(Template.PrintName) then exit;
  CP := TCarePlan.Create(True);
  GoalStr := StripCarePlanTemplateTag(Template.PrintName);
  RPCResult := FindOrCreateCarePlan(Patient.DFN, GoalStr, Template.ID,'');     //Result is VEFA19008IEN^GoalName^SUCCESSFUL, or -1^Message
  CP.VEFA19008 := Piece(RPCResult,'^',1);
  if CP.VEFA19008 = '-1' then begin
    MessageDlg('Error Finding or Creating New Care Plan: ' + Piece(RPCResult,'^',2),mtError,[mbOK],0);
    exit;
  end;
  FTargetDocIEN8925 := IntToStr(frmNotes.ActiveEditIEN);
  if FTargetDocIEN8925 = '' then begin
    MessageDlg('Error Finding Attachable Note For CarePlan.',mtError,[mbOK],0);
    exit;
  end;
  RPCResult := UpdateCarePlan(CP.VEFA19008,FTargetDocIEN8925);
  if Piece(RPCResult,'^',1) = '-1' then begin
    MessageDlg('Error Attaching Note To CarePlan:'+#13#13+Piece(RPCResult,'^',2),mtError,[mbOK],0);
    exit;
  end;
end;

Procedure IndentMemoTextIfCarePlan(TemplatePrintName: string; var Text : string; FRichEditControl : TRichEdit);  //VEFA-261
//Purpose: Indent text such that subsequent lines will align in text with first line.
//Input: Text -- the is the .text property of a TString object.  Lines are separated by line feeds.
//       IndentPos -- the number of characters the cursor is from the left margin.
var SL : TStringList;
    IndentStr : string;
    i : integer;
    IndentPos : integer;
    CurLineNum : integer;
    CurLine : string;
begin
  if not assigned(FRichEditControl) then exit;
  IndentPos := FRichEditControl.CaretPos.X;
  if IndentPos<2 then exit;
  if not TemplateIsCarePlan(TemplatePrintName) then exit;
  CurLineNum := FRichEditControl.CaretPos.Y;
  if CurLineNum <= FRichEditControl.Lines.count-1 then begin
    CurLine := FRichEditControl.Lines.Strings[CurLineNum];
    for i := 1 to IndentPos do begin
      if CurLine[i]=#9 then begin  //#9 = TAB character
        IndentPos := IndentPos + 7;  //TAB is 8 chars wide in RichEdit, - 1 for TAB character itself already there.
      end;
    end;
  end;
  IndentStr := '';
  for i := 1 to IndentPos do IndentStr := IndentStr + ' ';
  SL := TStringList.Create;
  try
    SL.Text := Text;
    for i := 1 to SL.Count - 1 do begin
      SL.Strings[i] := IndentStr + SL.Strings[i];
    end;
  finally
    Text := SL.Text;
    SL.Free;
  end;
end;

function AvoidDuplicateDataIfCarePlan(RE : TRichEdit; CPName : string) : boolean;
var Header, Footer : string;
    i : integer;
    startLine, endLine : integer;
begin
  //** Implement **
  //Check RE for data section for CPName.
  //if found, then ask if user wants to delete prior data entry. <--- Means that names must be unique!
  //If user doesn't want to delete, then return FALSE to abort updating careplan.
  Header := CarePlanTagCoreHeader(CPName);
  Footer := CarePlanTagCoreFooter(CPName);
  startLine := -1;
  endLine := -1;
  Result := true;
  if not assigned(RE) then exit; //kt 2/17
  //Scan for header of section data.
  for i := 0 to RE.Lines.Count - 1 do begin
    if (startLine=-1) and (Pos(Header,RE.Lines.Strings[i])>0) then begin
      startLine := i;
      result := false;
    end;
    if (startLine<>-1) and (endLine=-1) and (Pos(Footer,RE.Lines.Strings[i])>0) then begin
      endLine := i;
      break;
    end;
  end;
  if (result=true) then exit;
  if MessageDlg('WARNING: Note already contains care plan ['+CPName+']' + #13#10 +
                'If you continue, the results of that care plan will be replaced.' + #13#10 +
                #13#10 +
                'Replace unsigned care plan with new one?',
                mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
    if endLine=-1 then endLine := startLine;  //will just take out header.
    for i := endLine downto startLine do begin
      RE.Lines.Delete(i);
    end;
    Result := true;
  end;
end;


function FindCarePlanTemplateNode(CPT: TTemplate; StartNode : TTreeNode): TTreeNode;
var
  Node: TTreeNode;
  i : integer;

    function MatchFound(Node : TTreeNode) : boolean;
    begin
      result := false;
      if Assigned(Node.Data) then begin
        Result := TTemplate(Node.Data) = CPT;
      end;
    end;

begin
  Result := nil;
  for i := 0 to StartNode.Count - 1 do begin
    Node := StartNode.Item[i];
    if MatchFound(Node) then begin
      Result := Node;
      break;
    end;
    if Node.HasChildren then begin
      Result := FindCarePlanTemplateNode(CPT, Node);
      if assigned(Result) then break;
    end;
  end;
end;


function CarePlanTagCoreHeader(Name : string) : string;
begin
  if Pos(CAREPLAN_TAG,Name) <> 1 then Name := CAREPLAN_TAG + '-' + Name;
  Result := CP_BRACKET_OPEN + Name + CP_BRACKET_CLOSE;
end;

procedure WrapCPSection(SL : TStrings; Name : string);
begin
  if SL.Count = 0 then exit;  //down't wrap with header / footer if empty (i.e. user cancelled)
  if Pos('Template: ',Name)>0 then begin
    Name := MidStr(Name, length('Template: ')+1,Length(Name));
  end;
  if Pos(CarePlanTagHeader(Name),SL.Text)=0 then SL.Insert(0,CarePlanTagHeader(Name));
  if Pos(CarePlanTagFooter(Name),SL.Text)=0 then begin
    SL.Add(CarePlanTagFooter(Name));
    SL.Add(''); //blank line for spacing.
  end;
end;

procedure CheckWrapForCPResult(var NewTxt : string);
begin
  if CurrentDialogIsCarePlan then begin
    if rightstr(NewTxt,2)=#13#10 then NewTxt := LeftStr(NewTxt,Length(NewTxt)-2);
    NewTxt := CP_RESULT_TAG_OPEN + NewTxt + CP_RESULT_TAG_CLOSE;
  end;
end;


function GetCarePlanTemplate(IEN8927 : string; EditMode : TcpteMode = cptemCarePlan) : TTemplate;
//VEFA-261 added
var idx: integer;

begin
  Result := nil;
  if(not assigned(Templates)) then begin
    Templates := TStringList.Create;
  end;
  if(IEN8927 = '') or (IEN8927 = '0') then exit;
  idx := Templates.IndexOf(IEN8927);
  if (idx>=0) then begin
    Result := TTemplate(Templates.Objects[idx]);
  end else begin
    Result := GetOneCPTemplate(IEN8927, EditMode);
  end;
end;

function CarePlanTagCoreFooter(Name : string) : string;
begin
  if Pos(CAREPLAN_TAG,Name) <> 1 then Name := CAREPLAN_TAG + '-' + Name;
  Result := CP_SECTION_FOOTER_TAG_CORE_OPEN + Name + CP_BRACKET_CLOSE;
end;

function CarePlanTagHeader(Name : string) : string;
begin
  Result := CP_SECTION_HDR_TAG_OPEN + Name + CP_SECTION_HDR_TAG_CLOSE;
end;

function CarePlanTagFooter (Name : string) : string;
begin
  Result := CP_SECTION_FOOTER_TAG_OPEN + Name + CP_SECTION_FOOTER_TAG_CLOSE;
end;

function StripNamespacePartOfName(Name : string; EditMode : TcpteMode = cptemCarePlan) : string; //VEFA-261
//Purpose: to strip off leading CarePlan tag.
begin
  Result := StringReplace(Name, NAMESPACE_TAG_FOR_MODE[EditMode]+'-', '',[rfReplaceAll,rfIgnoreCase]);  //VEFA-261
end;

function CheckNamespaceName(Name : string;EditMode : TcpteMode = cptemNormal; CurrentlyEditing : boolean = false) : string; //VEFA-261
//purpose: If user tried to edit name, to take off starting CarePlan marker, then restore it.
//VEFA-261 Added
//var NumPces : integer;
const
  FRAGMENT='<VEFA>-';
begin
  Result := Name;
  if EditMode = cptemNormal then exit;
  if (Name='My Templates') or (Name='Shared Templates') then exit;
  if Pos(FRAGMENT,Name)>0 then begin
    Result := Piece2(Name,FRAGMENT,2);
    if Result='CarePlan' then Result := '';
    if (Result='') and (not CurrentlyEditing) then begin
      Result := NewTemplateName(EditMode);
    end else begin
      Result := NAMESPACE_TAG_FOR_MODE[EditMode] + '-' + Result;
    end;
  end else begin
    Result := NAMESPACE_TAG_FOR_MODE[EditMode] + '-' + Name;
  end;
end;

function TemplateNameisCP(Name : string; EditMode : TcpteMode = cptemCarePlan) : boolean;
//VEFA-261 Added
var temp : string;
begin
  temp := Piece(Name,'-',1);
  if Pos('Template: ',temp)>0 then begin
    temp := MidStr(temp, length('Template: ')+1,Length(temp));
  end;
  Result := (temp = NAMESPACE_TAG_FOR_MODE[EditMode]);
end;


procedure GetLinkedDxs(NeededDxs : TStringList);
var i : integer;
    DataStr,s2,s : string;
    NewCarePlan : TTemplate;
begin
  GetCarePlanLinkedDx(NeededDxs);  //NeededDxs is altered to include results from RPC call.
  for i := 0 to NeededDxs.Count - 1 do begin
    // DataStr format is: <IEN of careplan>^ICD Code~ICD Name^ICD Code~ICD Name^ICD Code~ICD Name^.. (repeat as many times as needed.
    DataStr := pieces(NeededDxs.Strings[i],'^',2,128) ; //discard first piece.  Limits to 128 linked diagnoses per care plan.
    NewCarePlan := TTemplate(NeededDxs.Objects[i]);
    if not assigned(NewCarePlan) then continue;
    Repeat
      s2 := piece(DataStr,'^',1);  //format: ICD Code~ICD Name
      DataStr := pieces(DataStr,'^',2,128);
      s := StringReplace(s2,'~','^',[rfReplaceAll, rfIgnoreCase]);
      if s2 <> '' then NewCarePlan.LinkedDxsAdd(s);  //Add: ICD Code^ICD Name
    until s2='';
  end;
end;



//--------------------------------------------------------------------------------------------------
//The following would be best put into ORFN.  But I will put them here to avoid impacting CPRS code
//--------------------------------------------------------------------------------------------------
{
function NumPieces(const s : string; ADelim : char) : integer;
var SL : TStringList;
begin
  SL := TStringList.Create;
  Result := 0;
  try
    PiecesToList(s, ADelim, SL);
    Result := SL.Count;
  finally
    SL.Free;
  end;
end;

function Piece(const S: string; Delim: char; PieceNum: Integer): string; overload; //VEFA-261 8/09 added 'overload;'
// returns the Nth piece (PieceNum) of a string delimited by Delim
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
end;

function PieceNCS(const S: string; Delim: string; PieceNum: Integer): string; overload;
//VEFA-261 8/09  Name means Piece-Not-Case-Sensitive, meaning match for Delim is not case sensitive.
//VEFA-261 8/09 Added entire function
var tempS : string;
begin
  tempS := AnsiReplaceText(S,Delim,UpperCase(Delim));
  Result := Piece2(tempS,UpperCase(Delim),PieceNum);
end;


function Pieces(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string; overload;
//VEFA-261 8/09 Added entire function
var Remainder : String;
    PieceNum : integer;
    PieceLen,p : integer;
begin
  Remainder := S;
  Result := '';
  PieceLen := Length(Delim);
  PieceNum := PieceStart;
  while (PieceNum > 1) and (Length(Remainder) > 0) do begin
    p := Pos(Delim,Remainder);
    if p=0 then p := length(Remainder)+1;
    Result := MidStr(Remainder,1,p-1);
    Remainder := MidStr(Remainder,p+PieceLen,length(Remainder));
    Dec(PieceNum);
  end;
  PieceNum := PieceEnd-PieceStart+1;
  Result := '';
  while (PieceNum > 0) and (Length(Remainder) > 0) do begin
    p := Pos(Delim,Remainder);
    if p=0 then p := length(Remainder)+1;
    if Result <> '' then Result := Result + Delim;
    Result := Result + MidStr(Remainder,1,p-1);
    Remainder := MidStr(Remainder,p+PieceLen,Length(Remainder));
    Dec(PieceNum);
  end;
end;

//function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;
// returns several contiguous pieces
//var
//  PieceNum: Integer;
//begin
//  Result := '';
//  for PieceNum := FirstNum to LastNum do Result := Result + Piece(S, Delim, PieceNum) + Delim;
//  if Length(Result) > 0 then Delete(Result, Length(Result), 1);
//end;

function PiecesNCS(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string;
//VEFA-261 8/09  Name means Pieces-Not-Case-Sensitive, meaning match for Delim is not case sensitive.
//VEFA-261 8/09 Added entire function
var tempS : string;
begin
  tempS := AnsiReplaceText(S,Delim,UpperCase(Delim));
  Result := Pieces2(tempS,UpperCase(Delim),PieceStart,PieceEnd);
end;
}

function FilterControlChars(s : string) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to length(s) do begin
    if (ord(s[i]) >= 32) and (ord(s[i]) < 127) then Result := Result + s[i];
  end;
end;

//____________________________________________



{   Use the following as a template for initial call
    AText := Memo1.Lines.Text;
    AText := CheckForOverlappingCarePlans(AText);
    Memo2.Lines.Text := AText;
    CheckForMultipleFieldsPerLine(Memo2.Lines);     }

  procedure CorrectCareplanFormat(Lines: TStrings);
  var
     AText : string;
  begin
    AText := Lines.Text;
    AText := CheckForOverlappingCarePlans(AText);
    Lines.Text := AText;
    CheckForMultipleFieldsPerLine(Lines);
  end;


  procedure CheckForMultipleFieldsPerLine(Lines : TStrings);
  //This assumes that all possible problems with overlapping have been fixed already.
    function PadStr(Len : integer) : string;
    begin
      Result := '';
      while Len>0 do begin
        Result := Result + ' ';
        Dec(Len)
      end;
    end;
    procedure SplitLineAt(var s : string; i, p : integer);
    //Starting at position p, split line into two parts and insert second part into Lines (is in variable scope)
    var s2 : string;
        PadAmount : integer;
    begin
      PadAmount := Length(s) - Length(TrimLeft(s));
      s2 := TrimLeft(MidStr(s, p, MAX_STR_LEN));
      s := MidStr(s, 1, p-1);
      if s2 <> '' then begin
        Lines.Insert(i+1, PadStr(PadAmount) + s2);
      end;
      Lines.Strings[i] := s;
    end;

  var InCarePlan : boolean;
      p, i : integer;
      s, s2 : string;
  begin
    InCarePlan := false;
    i := 0;
    while (i < Lines.Count-1) do begin
      s := Lines.Strings[i];
      if InCarePlan then begin
        p := Pos(FooterMarkerStart,s);
        if p > 1 then begin
          s2 := Trim(MidStr(s, 1, p-1));
          if s2 <> '' then begin
            SplitLineAt(s, i, p);
            p := Pos(FooterMarkerStart,s);
          end;
        end;
        if p > 0 then begin
          InCarePlan := false;
          p := PosEx(CP_BRACKET_CLOSE,s,p);
          if p > 0 then begin
            p := p + length(CP_BRACKET_CLOSE);
          end else begin
            s := s + CP_BRACKET_CLOSE;
            p := length(s) + 1;
          end;
          SplitLineAt(s, i, p);
        end;
      end;
      p := Pos(HeaderMarkerStart,s);
      if p > 1 then begin
        s2 := Trim(MidStr(s, 1, p-1));
        if s2 <> '' then begin
          SplitLineAt(s, i, p);
          p := Pos(HeaderMarkerStart,s);
        end;
      end;
      if p > 0 then begin
        InCarePlan := true;
        p := PosEx(HeaderMarkerEnd,s,p);
        if p > 0 then begin
          p := p + length(HeaderMarkerEnd);
        end else begin
          s := s + HeaderMarkerEnd;
          p := length(s) + 1;
        end;
        SplitLineAt(s, i, p);
      end;
      if InCarePlan then begin;
        p := Pos(CP_RESULT_TAG_CLOSE, s);
        if p > 0 then SplitLineAt(s, i, p + length(CP_RESULT_TAG_CLOSE));
      end;
      inc(i)
    end;
  end;


  function CheckForOverlappingCarePlans(Text : string): string;
  type cLastFound = (lfNone, lfHeader, lfFooter);
  var //i : integer;
      P,HPos,FPos : integer;
      DestP : integer;
      //Header1Found, Header2Found : boolean;
      //Footer1Found, Footer2Found : boolean;
      Header1Pos, Header2Pos,PriorFooterPos : integer;
      HeaderName : string;
      Status : integer;
      LastFound : cLastFound;
      RescanNeeded : boolean;

  const
    OK = 0;
    UNEXPECTED_HEADER = 1;

  begin
    Result := '1^OK';
    repeat
      RescanNeeded := false;
      ProblemFound := false;
      Status := OK;
      Header1Pos := 0;
      Header2Pos := 0;
      PriorFooterPos := 0;
      LastFound := lfNone;
      P := 1;
      repeat
        //Scan forward in text until either a header or a footer is found.  P=Position in text
        HPos := PosEx(HeaderMarkerStart,Text,P);
        FPos := PosEx(FooterMarkerStart,Text,P);
        if ((HPos < FPos) and (HPos <> 0)) or ((HPos > FPos) and (FPos=0)) then begin
          //Header found next in sequence
          P := HPos + StrLen(HeaderMarkerStart);
          FPos := 0;
        end else if ((FPos < HPos) and (FPos <> 0)) or ((FPos > HPos) and (HPos=0)) then begin
          //Footer found next in sequence
          P := FPos + StrLen(FooterMarkerStart);
          HPos := 0;
        end;
        //------------------------------------------
        //Step through logical possibility tree....
        if (HPos > 0) then begin  //A header was found next
          if Status = UNEXPECTED_HEADER then begin
            //We have situation of 3 headers in a row --> can't salvage, so ABORT
            //Result := '-1^Three nested Care Plan headers found.  Can''t fix.';
            //break;
            RescanNeeded := true;
          end;
          HeaderName := GetHeaderName(HPos, Text);
          if (Header1Pos=0) or (LastFound = lfFooter) then begin  //no hold-over header found
            Header1Pos := HPos;
            PriorFooterPos := 0;  //finding header clears last footer.
            LastFound := lfHeader;
          end else begin
            //We have situation of 2 headers in a row.
            Header2Pos := HPos;
            Status := UNEXPECTED_HEADER;
            LastFound := lfHeader;
            continue;  //loop back to top
          end;
        end else if (FPos > 0) then begin  //A footer was found next
          if PriorFooterPos = 0 then begin
            if Header1Pos > 0 then begin  //A header preceeded this footer
              if GetFooterName(FPos, Text) <> HeaderName then begin
                //We have a situation where footer name doesn't match header name  --> can't salvage, so ABORT
                Result := '-1^Footer name does not match header name.  Can''t fix.';
                break;
              end else begin
                if Status = UNEXPECTED_HEADER then begin
                  //We have situation of Header --> Header --> Footer
                  Text := MoveBlockBack(Header2Pos,FPos,Header1Pos,Text); //Move this last [Header<->Footer] block in front of 1st header
                  P := Header1Pos; //reset P to that position
                  PriorFooterPos := 0;
                  Status := OK;
                  LastFound := lfFooter;
                  continue;  //loop back
                end else begin
                  Status := OK;
                  PriorFooterPos := FPos;
                  LastFound := lfFooter;
                  //This is the normal, correct state.  Nothing to be done.
                end;
              end;
            end else begin  //footer was NOT preceeded by header
              //we have a footer with no matching header --> can't salvage, so ABORT
              Result := '-1^Footer found without matching header name.  Can''t fix.';
              break;
            end;
          end else begin
            //We have a situation of 2 footers in a row.
            DestP := AfterFooterPos(FPos,Text);
            Text := MoveBlockForward(Header1Pos,PriorFooterPos,DestP,Text); //Move this last [Header<->Footer] block after 2nd footer
            //Start over from beginning of document, becuase it is unknowable how much to back up to look for bisected header1
            Status := OK;
            Header1Pos := 0;
            Header2Pos := 0;
            PriorFooterPos := 0;
            P := 1;
            LastFound := lfFooter;
            continue;
          end;
        end;
      until (HPos = 0) and (FPos = 0);
    until RescanNeeded = false;
    Result := Text;
  end;

  function AfterHeaderPos(HeaderStartP : integer; Var Text : string) : integer;
  //Return index of first character after Header
  var EndP : integer;
  begin
    Result := -1;
    EndP := PosEx(HeaderMarkerEnd,Text, HeaderStartP);
    if EndP=0 then exit;
    Result := EndP + Length(HeaderMarkerEnd);
  end;

  function AfterFooterPos(FooterStartP : integer; Var Text : string) : integer;
  //Return index of first character after Footer
  var EndP : integer;
  begin
    Result := -1;
    EndP := PosEx(CP_BRACKET_CLOSE,Text, FooterStartP);
    if EndP=0 then exit;
    EndP := EndP + Length(CP_BRACKET_CLOSE);
    while Text[EndP] in [#10,#13] do Inc(EndP);
    Result := EndP;
  end;

  function GetHeaderName(P : integer; var Text : string): string;
  //Return name of header, starting at position P (beginning of header marker)
  var EndP : integer;
  begin
    Result := '';
    EndP := PosEx(HeaderMarkerEnd,Text, P);
    if EndP=0 then exit;
    P := P+Length(HeaderMarkerStart);
    Result := MidStr(Text, P, EndP-P);
  end;

  function GetFooterName(P : integer; var Text : string): string;
  //Return name of footer, starting at position P (beginning of footer marker)
  var EndP : integer;
  begin
    Result := '';
    EndP := PosEx(CP_BRACKET_CLOSE,Text, P);
    if EndP=0 then exit;
    P := P+Length(FooterMarkerStart);
    Result := MidStr(Text, P, EndP-P);
  end;

  function MoveBlockBack(HeaderStartP, FooterStartP, DestPos : integer; Text : string) : string;
  var P1,P2 : integer;
      BlockText: string;
  begin
    P1 := HeaderStartP;
    P2 := AfterFooterPos(FooterStartP, Text)-1;
    BlockText := #13#10 + #13#10 + GetTextBetween(P1, P2, Text) + #13#10 + #13#10;
    Text := DelTextBetween(P1, P2, Text);
    Text := InsertBlockAt(BlockText,DestPos, Text);
    Result := Text;
  end;

  function MoveBlockForward(HeaderStartP, FooterStartP, DestPos : integer; Text : string) : string;
  var P1,P2 : integer;
      BlockText: string;
  begin
    P1 := HeaderStartP;
    P2 := AfterFooterPos(FooterStartP, Text)-1;
    BlockText := #13#10 + #13#10 + GetTextBetween(P1, P2, Text) + #13#10;
    Text := InsertBlockAt(BlockText,DestPos, Text);
    Text := DelTextBetween(P1, P2, Text);
    Result := Text;
  end;

  function GetTextBetween(P1, P2 : integer; var Text : string) : string;
  var count : integer;
  begin
    count := (P2-P1)+1;
    Result := MidStr(Text, P1, count);
  end;


  function DelTextBetween(P1, P2 : integer; var Text : string) : string;
  var StrA,StrB : string;
  begin
    StrA := LeftStr(Text, P1-1);
    StrB := RightStr(Text, Length(Text)-P2);
    Result := StrA + StrB;
  end;

  function InsertBlockAt(BlockText : string; P : integer; Var Text : string) : string;
  var StrA,StrB : string;
  begin
    StrA := LeftStr(Text, P-1);
    StrB := RightStr(Text, (Length(Text)-P)+1);
    Result := StrA + BlockText + StrB;
  end;


//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------

initialization
  ProblemIconsTopList := TList.Create;
  ProblemIconLeftList := TList.Create;
  ProblemIconInfoSL := TStringList.Create;

finalization
  ProblemIconsTopList.Free;
  ProblemIconLeftList.Free;
  ProblemIconInfoSL.Free;
end.

