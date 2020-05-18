unit fTemplateDialog;
 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TMGHTML2, uHTMLDlg, uTemplateFields, //kt 1/16
  StdCtrls, ExtCtrls, ORCtrls, ORFn, AppEvnts, uTemplates, fBase508Form, uConst,
  VA508AccessibilityManager, ComCtrls;

type
  TDialogMode = (tHTML, tPlain, tPreview);     //kt 1/16
  TDialogModesSet = set of TDialogMode;  //kt 1/16

  TfrmTemplateDialog = class(TfrmBase508Form)
    sbMain: TScrollBox;
    pnlBottom: TScrollBox;
    btnCancel: TButton;
    btnOK: TButton;
    btnAll: TButton;
    btnNone: TButton;
    lblFootnote: TStaticText;
    btnPreview: TButton;
    pcDlg: TPageControl;
    tsPlainDlg: TTabSheet;
    tsHTMLDlg: TTabSheet;
    pnlHoldWebBrowser: TPanel;
    procedure btnAllClick(Sender: TObject);
    procedure btnNoneClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FFirstBuild: boolean;
    SL: TStrings;
    BuildIdx: TStringList;
    FEntries: TStringList;  //kt renamed Entries -> FEntries.  This is a list of Dlg entries: String=ID, Obj=TTemplateDialogEntry
    NoTextID: TStringList;
    Index: string;
    OneOnly: boolean;
    Count: integer;
    RepaintBuild: boolean;
    FirstIndent: integer;
    FBuilding: boolean;
    FOldHintEvent: TShowHintEvent;
    FMaxPnlWidth: integer;
    FTabPos: integer;
    FCheck4Required: boolean;
    FSilent: boolean;
    FAnswerOpenTag : string;      //kt 9/11 added
    FAnswerCloseTag : string;     //kt 9/11 added
    NameToObjID : TStringList;    //kt 9/11 added
    Formulas  : TStringList;      //kt 9/11 added
    TxtObjects  : TStringList;    //kt 9/11 added
    HtmlEditor : THtmlObj;        //kt
    HTMLDlg : THTMLDlg;           //kt
    InternalFormulaCount, TMGTxtObjCount : integer;  //kt 3/16
    procedure SizeFormToCancelBtn();
    procedure ChkAll(Chk: boolean);
    procedure BuildCB(CBidx: integer; var Y: integer; FirstTime: boolean);
    procedure ItemChecked(Sender: TObject);
    procedure BuildAllControls;
    procedure AppShowHint(var HintStr: string; var CanShow: Boolean;
                          var HintInfo: THintInfo);
    procedure FieldChanged(Sender: TObject);
    procedure EntryDestroyed(Sender: TObject);
    function GetObjectID( Control: TControl): string;
    function GetParentID( Control: TControl): string;
    function FindObjectByID( id: string): TControl;
    function IsAncestor( OldID: string; NewID: string): boolean;
    procedure ParentCBEnter(Sender: TObject);
    procedure ParentCBExit(Sender: TObject);
    procedure UMScreenReaderInit(var Message: TMessage); message UM_MISC;
    procedure InitScreenReaderSetup;
    function  GetHTMLTargetMode:boolean;  //kt 12/27/12
    procedure GetHTMLText(HTMLSL: TStrings; IncludeEmbeddedFields: Boolean);  //kt added 3/16
    procedure GetPlainText(SL: TStrings; IncludeEmbeddedFields: Boolean);  //kt added 3/16
  public
    DBControlData : TDBControlData;  //kt 5/16  Not owned by this object
    function  HTMLGUIMode : boolean; //kt 3/16
    procedure GetText(SL: TStrings; IncludeEmbeddedFields: Boolean);  //kt added into class 2/21/16
    procedure SetHTMLAnswerOpenCloseTags(OpenHTML, CloseHTML : string);
    procedure SetHTMLAnswerSimpleTag(Value : string); //kt 9/11
    property Silent: boolean read FSilent write FSilent ;
    //property HTMLGUIMode : boolean read FHTMLGUIMode write FHTMLGUIMode; //kt 1/16 added
    property HTMLTargetMode : boolean read GetHTMLTargetMode{ write FHTMLMode}; //kt 9/11 added
    property HTMLAnswerOpenTag : string read FAnswerOpenTag {write SetHTMLAnswerSimpleTag};  //kt 9/11 added  //kt 1/16
    property HTMLAnswerCloseTag : string read FAnswerCloseTag {write SetHTMLAnswerSimpleTag};  //kt 9/11 added //kt 1/16
    function DoTemplateDialog(SL: TStrings; const CaptionText: string; DlgMode : TDialogModesSet = []): boolean;
  published
  end;

// Returns True if Cancel button is pressed
//kt original 1/16 --> function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE): boolean;
function DoTemplateDialog(SL: TStrings; const CaptionText: string; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData = nil): boolean;
//function DoHTMLTemplateDialog(SL: TStrings; const CaptionText: string; DlgMode : TDialogModesSet = []): boolean;  //kt added 1/16
function RemoveHTMLTags(Txt : string) : string;
function FormatHTMLTags(Txt : string): string;
function RemoveImageTags(Txt : string) : string;
function FormatImageTags(Txt : string): string;
//kt 1/16 original --> procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; PreviewMode: boolean = FALSE); overload;
procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData = nil); overload;
//kt 1/16 original --> procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE); overload;
procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData= nil); overload;
//kt procedure ShutdownTemplateDialog;

//kt var
//kt   frmTemplateDialog: TfrmTemplateDialog;

implementation

uses dShared, fRptBox, uInit, rMisc, uDlgComponents,
  uTMGOptions, uTMGUtil, fNotes, StrUtils, uCarePlan, uTemplateMath, uHTMLTools, uCore, //kt, //kt-tm, //kt-cp
  rTIU, rTemplates,  //kt
  VA508AccessibilityRouter, VAUtils;

{$R *.DFM}

var
  uTemplateDialogRunning: boolean = false;

const
  Gap = 4;
  IndentGap = 18;


//kt original --> procedure GetText(SL: TStrings; IncludeEmbeddedFields: Boolean);
procedure TfrmTemplateDialog.GetPlainText(SL: TStrings; IncludeEmbeddedFields: Boolean);
//kt added into class 2/21/16
var
  i, p1, p2: integer;
  Txt, tmp: string;
  Save, Hidden: boolean;
  TmpCtrl: TStringList;
  TemplateText : string; //kt 1/16
  HTMLMode : boolean; //kt 9/11 added
  HTMLOpenTag,HTMLCloseTag : string; //kt 9/11 added
  Position: integer;  //kt

begin
  //kt 1/16 original --> Txt := SL.Text;
  //kt 1/16 original --> SL.Clear;
  //kt 1/16 begin mod --------------
  if assigned(SL) then Txt := SL.Text
  else Txt := '';
  if assigned(SL) then SL.Clear;
  HTMLMode := HTMLTargetMode;
  Position := pos(NO_FORMATTED_ANSWERS,txt);
  if Position>0 then begin
    HTMLOpenTag := '';
    HTMLCloseTag := '';
  end else begin
    HTMLOpenTag := HTMLAnswerOpenTag;
    HTMLCloseTag := HTMLAnswerCloseTag;
  end;
  //kt 1/16 end mod --------------
  TmpCtrl := TStringList.Create;
  try
    for i := 0 to sbMain.ControlCount-1 do begin
      with sbMain do begin
        tmp := IntToStr(Controls[i].Tag);
        tmp := StringOfChar('0', 7-length(tmp)) + tmp;
        TmpCtrl.AddObject(tmp, Controls[i]);
      end;
    end;
    TmpCtrl.Sort;
    for i := 0 to TmpCtrl.Count-1 do begin
      Save := FALSE;
      if(TmpCtrl.Objects[i] is TORCheckBox) and (TORCheckBox(TmpCtrl.Objects[i]).Checked) then begin
        Save := TRUE
      end else if(OneOnly and (TmpCtrl.Objects[i] is TPanel)) then begin
        Save := TRUE;
      end;
      if(Save) then begin
        tmp := Piece(Index,U,TControl(TmpCtrl.Objects[i]).Tag);  //e.g. '1~375~00100;0;-1.0;;0'
        p1 := StrToInt(Piece(tmp,'~',1));
        p2 := StrToInt(Piece(tmp,'~',2));
        Hidden := (copy(Piece(tmp,'~',3),2,1)=BOOLCHAR[TRUE]);
        //kt 1/16 begin mod --------
        TemplateText := ResolveTemplateFields(Copy(Txt,p1,p2), FALSE, Hidden, IncludeEmbeddedFields,
                                              HTMLMode, HTMLOpenTag, HTMLCloseTag, Self.DBControlData);
        if assigned(SL) then SL.Text := SL.Text + TemplateText
        //kt 1/16 end mod --------
        //kt 9/11 original --> SL.Text := SL.Text + ResolveTemplateFields(Copy(Txt,p1,p2), FALSE, Hidden, IncludeEmbeddedFields);
      end;
    end;
    if assigned(SL) then SL.Text := FixNoBRs(SL.Text);  //kt 3/16
  finally
    TmpCtrl.Free;
  end;
end;

procedure TfrmTemplateDialog.GetHTMLText(HTMLSL: TStrings; IncludeEmbeddedFields: Boolean);
//kt 2/20/16 added entire function
//Copied and heavily modified from .GetText() above
var
  i                        : integer;
  Save, Hidden,HTMLMode    : boolean;
  tmp, TemplateHTMLText    : string;
  HTMLOpenTag,HTMLCloseTag : string;
  OneBlock                 : string;
  TextBlocks               : TStringList;

begin
  TextBlocks := TStringList.Create;
  ORFN.PiecesToList2(HTMLSL.Text, ObjMarker, TextBlocks);
  //NOTE: Above assumes that text blocks are serial (one after the other), and not nested....
  HTMLMode := HTMLTargetMode;
  if pos(NO_FORMATTED_ANSWERS, HTMLSL.Text)>0 then begin
    HTMLOpenTag := '';                  HTMLCloseTag := '';
  end else begin
    HTMLOpenTag := HTMLAnswerOpenTag;   HTMLCloseTag := HTMLAnswerCloseTag;
  end;
  HTMLSL.Clear;
  try
    for i := 0 to TextBlocks.Count - 1 do begin
      OneBlock := TextBlocks.Strings[i];
      tmp := ORFN.Piece2(OneBlock, DlgPropMarker, 2);
      OneBlock := ORFN.Piece2(OneBlock, DlgPropMarker, 1);
      Hidden := (length(tmp)>= 2) and (tmp[2] = BOOLCHAR[TRUE]);
      TemplateHTMLText  := ResolveHTMLTemplateFields(OneBlock, FALSE, Hidden, IncludeEmbeddedFields,
                                                     HTMLMode, HTMLOpenTag, HTMLCloseTag );
      HTMLSL.Text := HTMLSL.Text + TemplateHTMLText;
    end;
    HTMLSL.Text := FixHTMLCRLF(HTMLSL.Text);
  finally
    TextBlocks.Free;
  end;
end;

procedure TfrmTemplateDialog.GetText(SL: TStrings; IncludeEmbeddedFields: Boolean);
//kt 3/16
//Original GetText renamed to GetPlainText
//This function switches to either GetHTMLText or GetPlainText
begin
  if HTMLGUIMode then begin
    GetHTMLText(SL, IncludeEmbeddedFields);
  end else begin
    GetPlainText(SL, IncludeEmbeddedFields);
  end;
end;

function TfrmTemplateDialog.HTMLGUIMode : boolean;
//kt added 3/16
begin
  Result := (pcDlg.ActivePage = tsHTMLDlg);
end;

//Returns True if Cancel button is pressed
//kt orinal 1/16 --> function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE): boolean;
function TfrmTemplateDialog.DoTemplateDialog(SL: TStrings; const CaptionText: string; DlgMode : TDialogModesSet = []): boolean;
//kt added into class, and split part out into stand-along function DoTemplateDialog()

var
  i, j, idx, Indent: integer;
  DlgProps, Txt: string;
  DlgIDCounts: TStringList;
  DlgInt: TIntStruc;
  CancelDlg: Boolean;
  CancelMsg: String;
  Temp : string;                               //kt 9/11
  Changed : boolean;                           //kt 9/11
  PreviewMode : boolean;                       //kt 1/16
  SLWithTransformedFormulas : TStringList;     //kt 3/16
  SLWithFormulasAndObjsRemoved : TStringList;  //kt 3/16
  DummyInt : integer;                          //kt
  RPCErrStr : string;                          //kt 5/16

  procedure LoadValuesForDBControls;
  //kt 5/16 added sub-procedure
  type  //I have change programming approach.  Probably could do away with this record...
    TDBControlInfo = record  //kt added 5/16
      TemplateField: TTemplateField;
      InitServerValue : string;
      ValueAfterUserInteraction : string;
      ControlID : integer;
    end;
    TDBControlInfoArray = array of TDBControlInfo;  //kt 5/16

  var i, j : integer;
      ATmplFld: TTemplateField;  //kt 5/16
      SL, LineArr : TStringList;
      s, AVisitStr : string;
      Arr : TDBControlInfoArray;    //kt 5/16
      //uses in global scope: VEFANameToObjID -- format: SL.String[i] = Field Name,  Integer(SL.Object[i]) = fieldID
  begin
    AVisitStr := VisitStrForNote(0);  //<-- TO DO!!!  replace 0 with IEN of target note
    SL := nil;
    try;
      for i := 0 to VEFANameToObjID.Count - 1 do begin  //kt added block 5/16
        ATmplFld := GetTemplateField(VEFANameToObjID[i], FALSE); // TmplFld is TTemplateField.  Uses uTmplFlds in global scope.
        if not assigned(ATmplFld) or not ATmplFld.IsDBControl then continue;
        if not assigned(SL) then SL := TStringList.Create;
        j := Length(Arr);
        SetLength(Arr, j+1); //add record
        Arr[j].TemplateField := ATmplFld;
        Arr[j].ControlID := Integer(VEFANameToObjID.Objects[i]);
        SL.Add('GET^' +ATmplFld.ID+ '^' + IntToStr(j));  //format: 'GET^<TEMPLATE IEN>^<Index>'
      end;
      if assigned(SL) then begin
        //call RPC to get values.
        //NOTE: I am doing a batch read here of ALL the DB controls for this dialog at once.
        //      This will reduce chatter communication to the server, with delay when there
        //      are network latencies.  HOWEVER, I am not going to use the values
        //      that are read right now.  Will have each field cache the values, which
        //      will remain valid for ~2 seconds.  That should be long enough to
        //      generate the dialog.  If not long enough, then fields will simply
        //      ask the server for updated values.
        if DBDialogFieldValuesGet(Patient.DFN, AVisitStr, SL, RPCErrStr) then begin
          // expected format back:  RESULT[#]'VALUE^<Template IEN>^<value of db control>^<any tag value>
          LineArr := TStringList.Create;
          for i := 0 to SL.Count - 1 do begin
            PiecesToList(SL.Strings[i], '^', LineArr);
            if LineArr.Count < 4 then continue;
            if LineArr.Strings[0] <> 'VALUE' then continue;
            j := StrToIntDef(LineArr.Strings[3], -1);
            if j < 0 then continue;
            if LineArr.Strings[1] <> Arr[j].TemplateField.ID then continue;
            Arr[j].InitServerValue := LineArr.Strings[2]; //not used, delete?
            Arr[j].TemplateField.CacheDBValue(Patient.DFN, LineArr.Strings[2]);
          end;
        end else begin
          MessageDlg(RPCErrStr, mtError, [mbOK], 0);
        end;
      end;
    finally
      SetLength(Arr, 0);
      SL.Free;
      LineArr.Free;
    end;
  end;

  procedure IncDlgID(var id: string); //Appends an item count in the form of id.0, id.1, id.2, etc
  var                                 //based on what is in the StringList for id.
    k: integer;
  begin
    k := DlgIDCounts.IndexOf(id);
    if (k >= 0) then begin
      DlgInt := TIntStruc(DlgIDCounts.Objects[k]);
      DlgInt.x := DlgInt.x + 1;
      id := id + '.' + InttoStr(DlgInt.x);
    end else begin
      DlgInt := TIntStruc.Create;
      DlgInt.x := 0;
      DlgIDCounts.AddObject(id, DlgInt);
      id := id + '.0';
    end;
  end;

  procedure CountDlgProps(var DlgID: string);  //Updates the item and parent item id's with the count
  var                                          // value id.0, id.1, id.2, id.3, etc.  The input dialog
    x: integer;                                // id is in the form 'a;b;c;d;c', where c is the item id,
    id, pid: string;                           // d is the parent item id, c is indent
  begin
    id  := piece(DlgID,';',3);
    pid := piece(DlgID,';',4);
    if length(pid) > 0 then
      x := DlgIDCounts.IndexOf(pid)
    else
      x := -1;
    if (x >= 0) then begin
      DlgInt := TIntStruc(DlgIDCounts.Objects[x]);
      pid := pid + '.' + InttoStr(DlgInt.x);
    end;
    if length(id) > 0 then
      IncDlgID(id);
    SetPiece(DlgID,';',3,id);
    SetPiece(DlgID,';',4,pid);
  end;

begin //DoTemplateDialog
  Result := FALSE;
  CancelDlg := FALSE;
  PreviewMode := (tPreview in DlgMode); //kt 1/16
  VEFANameToObjID.Clear;  //kt added 5/16
  SetTemplateDialogCanceled(FALSE);
  //kt 3/16 AfrmTemplateDialog := TfrmTemplateDialog.Create(Application);
  try
    DlgIDCounts := TStringList.Create;
    DlgIDCounts.Sorted := TRUE;
    DlgIDCounts.Duplicates := dupError;
    Caption := CaptionText;
    SLWithTransformedFormulas := TStringList.Create;  //kt 3/16
    SLWithFormulasAndObjsRemoved := TStringList.Create;  //kt 3/16
    //kt 12/27/12 frmTemplateDialog.HTMLMode := uTemplates.UsingHTMLMode; //kt 9/11
    if AtIntracareLoc() then begin
      SetHTMLAnswerOpenCloseTags('<B><I><font size="+1" face="Arial">', '</B></I></font>');
    end else begin
      SetHTMLAnswerOpenCloseTags('<B><I>', '</B></I>');
    end;
    //SL.Text := RemoveHTMLTags(SL.Text);  //kt 9/11
    AssignFieldIDs(SL,VEFANameToObjID);   //kt 9/11 added NameToObjID param
    LoadValuesForDBControls; //kt added  5/16

    //AssignFieldIDs(SL,frmTemplateDialog.NameToObjID);   //kt 9/11 added NameToObjID param
    //-------------------------------------------------------------------------------------------------------------
    //kt NOTE: The original system was designed to replace the long formulas with something like this: %___% #1
    //         But even this looks awkward in the GUI.  So I am coming back to remove even this.  But the final
    //         processing system is looking for these codes.  So I will have one SL for display and one for processing.
    //-------------------------------------------------------------------------------------------------------------
    uTemplateMath.HideFormulas(SL, VEFAFormulas, InternalFormulaCount); //kt 9/11
    uTemplateMath.HideTxtObjects(SL, TxtObjects, TMGTxtObjCount); //kt 9/11

    SLWithFormulasAndObjsRemoved.Assign(SL);
    uTemplateMath.DeleteHiddenFormulas(SLWithFormulasAndObjsRemoved);
    uTemplateMath.DeleteHiddenTxtObjects(SLWithFormulasAndObjsRemoved); //kt 9/11

    SLWithTransformedFormulas.Assign(SL);  //this SL should have everything needed for processing after the user is done with GUI.
    SL.Assign(SLWithFormulasAndObjsRemoved);  //SL here should have formulas stripped, ready to set up for display
    Self.SL := SL;
    Index := '';
    Txt := SL.Text;
    OneOnly := (DelimCount(Txt, ObjMarker) = 1);
    Count := 0;
    idx := 1;
    FirstIndent := 99999;
    repeat
      i := pos(ObjMarker, Txt);
      if(i > 1) then begin
        j := pos(DlgPropMarker, Txt);
        if(j > 0) then begin
          DlgProps := copy(Txt, j + DlgPropMarkerLen, (i - j - DlgPropMarkerLen));
          CountDlgProps(DlgProps);
        end else begin
          DlgProps := '';
          j := i;
        end;
        inc(Count);
        Index := Index + IntToStr(idx)+'~'+IntToStr(j-1)+'~'+DlgProps+U;
        inc(idx,i+ObjMarkerLen-1);
        Indent := StrToIntDef(Piece(DlgProps, ';', 5),0);
        if(FirstIndent > Indent) then FirstIndent := Indent;
      end;
      if(i > 0) then
        delete(txt, 1, i + ObjMarkerLen - 1);
    until (i = 0);
    if(Count > 0) then begin
      if(OneOnly) then begin
        btnNone.Visible := FALSE;
        btnAll.Visible := FALSE;
      end;
      BuildAllControls;
      repeat
        if (assigned(frmNotes)) and (HTMLTargetMode) then frmNotes.HTMLEditor.SetMsgActive(False);  //kt 9/11
        pcDlg.ActivePage := tsPlainDlg;  //kt
        ShowModal;
        if (assigned(frmNotes)) and (HTMLTargetMode) then frmNotes.HTMLEditor.SetMsgActive(True);   //kt 9/11
        if(ModalResult = mrOK) then begin
          SL.Assign(SLWithTransformedFormulas);  //kt 3/16
          //kt 9/11 -- begin mod --
          Changed := uTemplateMath.RestoreTransformTxtObjects(SL);
          Changed := uTemplateMath.RestoreTransformFormulas(SL) or Changed;
          if Changed then begin
            Txt := SL.Text;
            i := pos(ObjMarker, Txt);
            if(i > 1) then begin
              j := pos(DlgPropMarker, Txt);
              if (j <= 0) then j := i;
              Temp := Index;
              SetPiece(Temp,'~',2,IntToStr(j-1));
              Index := Temp;
            end;
          end;
          GetText(SL, TRUE);     {TRUE = Include embedded fields}
        end else begin
          if (not PreviewMode) and (not Silent) and (not uInit.TimedOut) then begin
            CancelMsg := 'If you cancel, your changes will not be saved.  Are you sure you want to cancel?';
            if (InfoBox(CancelMsg, 'Cancel Dialog Processing', MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES) then begin
              SL.Clear;
              Result := TRUE;
              CancelDlg := TRUE;
            end else begin
              CancelDlg := FALSE;
            end;
          end else begin
            SL.Clear;
            Result := TRUE;
            CancelDlg := TRUE;
          end;
        end;
      until CancelDlg or (ModalResult = mrOK)
    end else
      SL.Clear;
  finally
    SLWithTransformedFormulas.Free;  //kt 3/16
    SLWithFormulasAndObjsRemoved.Free;  //kt 3/16
    //frmTemplateDialog.Free;    v22.11e RV
    //kt 3/16 frmTemplateDialog.Release;
    //frmTemplateDialog := nil;  access violation source?  removed 7/28/03 RV
    for i := 0 to DlgIDCounts.Count-1 do begin
      DlgIDCounts.Objects[i].Free;
    end;
    DlgIDCounts.Free;
  end;

  //kt 3/16 -- if Result then
  //kt 3/16 --   SetTemplateDialogCanceled(TRUE)
  //kt 3/16 -- else begin
  //kt 3/16 --   SetTemplateDialogCanceled(FALSE);
  //kt 3/16 --   CheckBoilerplate4Fields(SL, CaptionText, DlgMode);  //kt 1/16
  //kt 3/16 -- end;
end; //DoTemplateDialog

//Returns True if Cancel button is pressed
//kt orinal 1/16 --> function DoTemplateDialog(SL: TStrings; const CaptionText: string; PreviewMode: boolean = FALSE): boolean;
function DoTemplateDialog(SL: TStrings; const CaptionText: string; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData = nil): boolean;
//kt 3/16 split this function into this part, and a member of the class
var AfrmTemplateDialog : TfrmTemplateDialog; //kt 3/16

begin
  Result := FALSE;
  AfrmTemplateDialog := TfrmTemplateDialog.Create(Application);
  AfrmTemplateDialog.DBControlData := DBControlData; //kt added 5/16
  try
    Result := AfrmTemplateDialog.DoTemplateDialog(SL, CaptionText, DlgMode);
  finally
    AfrmTemplateDialog.Release;
  end;
  if Result then
    SetTemplateDialogCanceled(TRUE)
  else begin
    SetTemplateDialogCanceled(FALSE);
    //kt original --> CheckBoilerplate4Fields(SL, CaptionText, PreviewMode);
    CheckBoilerplate4Fields(SL, CaptionText, DlgMode, DBControlData);  //kt 1/16
  end;
end;



function RemoveHTMLTags(Txt : string): string;
//kt 9/11
var
  beginning,ending : integer;
  tempString,tempResult : string;
begin
  tempString := Txt;
  //here we will strip out all HTML formatting tags  //elh
  beginning := pos(HTML_BEGIN_TAG, tempString);
  if beginning = 0 then begin
     Result := Txt;
  end else begin
    while beginning > 0 do begin
      tempResult := tempResult + Leftstr(tempString, beginning-1);
      tempString := Rightstr(tempString,length(tempString)-beginning-HTML_BEGIN_TAGLEN+1);
      ending := pos(HTML_ENDING_TAG, tempString);
      tempString := Rightstr(tempString,length(tempString)-ending);
      beginning := pos(HTML_BEGIN_TAG, tempString);
  //    tempString := Midstr(Txt,i,HTML_BEGIN_TAGLEN);
    end;
    Result := tempResult + tempString;
  end;
end;


function FormatHTMLTags(Txt : string): string;
//kt 9/11
var
  beginning,ending : integer;
  tempString,tempResult : string;
begin
  tempString := Txt;
  //here we will strip out all HTML formatting tags  //elh
  beginning := pos(HTML_BEGIN_TAG, tempString);
  if beginning = 0 then begin
     Result := Txt;
  end else begin
    while beginning > 0 do begin
      tempResult := tempResult + Leftstr(tempString, beginning-1);
      tempString := Rightstr(tempString, length(tempString)-beginning-HTML_BEGIN_TAGLEN+1);
      ending := pos(HTML_ENDING_TAG, tempString);
      tempResult := tempResult + Leftstr(tempString,ending-1);
      tempString := Rightstr(tempString,length(tempString)-ending);
      beginning := pos(HTML_BEGIN_TAG, tempString);
  //    tempString := Midstr(Txt,i,HTML_BEGIN_TAGLEN);
    end;
    Result := tempResult + tempString;
  end;
end;


{//kt removed.  If needed, I will need to make a list of all running dialogs and shutdown from that
procedure ShutdownTemplateDialog;
begin
  if uTemplateDialogRunning and assigned(frmTemplateDialog) then
  begin
    frmTemplateDialog.Silent := True;
    frmTemplateDialog.ModalResult := mrCancel;
  end;
end;
}

function RemoveImageTags(Txt : string): string;
//kt 9/11
var
  beginning,ending : integer;
  tempString,tempResult : string;
begin
  tempString := Txt;
  //here we will strip out all HTML formatting tags  //elh
  beginning := pos(IMG_BEGIN_TAG, tempString);
  if beginning = 0 then begin
     Result := Txt;
  end else begin
    while beginning > 0 do
    begin
      tempResult := tempResult + Leftstr(tempString,beginning-1);
      tempString := Rightstr(tempString,length(tempString)-beginning-IMG_BEGIN_TAGLEN);
      ending := pos(IMG_END_TAG, tempString);
      tempString := Rightstr(tempString,length(tempString)-ending);
      beginning := pos(IMG_BEGIN_TAG, tempString);
  //    tempString := Midstr(Txt,i,HTML_BEGIN_TAGLEN);
    end;
    Result := tempResult + tempString;
  end;
end;

function FormatImageTags(Txt : string): string;
//kt 9/11
var
  beginning,ending : integer;
  tempString,tempResult,ImageFile : string;
begin
  tempString := Txt;
  //here we will strip out all HTML formatting tags  //elh
  beginning := pos(IMG_BEGIN_TAG, tempString);
  if beginning = 0 then begin
     Result := Txt;
  end else begin
    while beginning > 0 do
    begin
      tempResult := tempResult + Leftstr(tempString,beginning-1);
      tempString := Rightstr(tempString,length(tempString)-beginning-IMG_BEGIN_TAGLEN+1);
      ending := pos(IMG_END_TAG, tempString);
      ImageFile := frmNotes.GetNamedTemplateImageHTML(Leftstr(tempString,ending-1));
      tempResult := tempResult + ImageFile;
      tempString := Rightstr(tempString,length(tempString)-ending);
      beginning := pos(IMG_BEGIN_TAG, tempString);
  //    tempString := Midstr(Txt,i,HTML_BEGIN_TAGLEN);
    end;
    Result := tempResult + tempString;
  end;
end;

procedure CheckBoilerplate4Fields(SL: TStrings; const CaptionText: string = ''; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData = nil);
var partA, Macro, partC : string; //kt

begin
  //kt begin mod 10/16/14
  while (pos(MACRO_BEGIN_TAG,SL.Text) > 0) do begin  //elh  10/14/14
      //messagedlg('We will resolve macros here',mtInformation,[mbOk],0);
      partA := piece2(SL.Text, MACRO_BEGIN_TAG, 1);
      Macro := piece2(SL.Text, MACRO_BEGIN_TAG, 2);
      Macro := trim(piece2(Macro, MACRO_END_TAG, 1));
      partC := piece2(SL.Text, MACRO_END_TAG, 2);
      SL.Text := partA + frmNotes.HandleMacro(Macro) + partC;
  end;
  uCarePlan.CurrentDialogIsCarePlan := uCarePlan.TemplateNameIsCP(CaptionText,cptemCarePlan);  //kt 9/11 -- will affect if aswers are wrapped in tagged-text markers
  while(HasTemplateField(SL.Text)) do begin
    if (BoilerplateTemplateFieldsOK(SL.Text)) then begin
      SL[SL.Count-1] := SL[SL.Count-1] + DlgPropMarker + '00100;0;-1;;0' + ObjMarker;
      //kt 1/16 original --> DoTemplateDialog(SL, CaptionText, PreviewMode);
      DoTemplateDialog(SL, CaptionText, DlgMode, DBControlData);
    end else
      SL.Clear;
  end;
  StripScreenReaderCodes(SL);
  if uCarePlan.CurrentDialogIsCarePlan then uCarePlan.WrapCPSection(SL, CaptionText); //kt-cp
  uCarePlan.CurrentDialogIsCarePlan := false; //kt-cp -- variable no longer needed
end;

//kt original --> procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; PreviewMode: boolean = FALSE);
procedure CheckBoilerplate4Fields(var AText: string; const CaptionText: string = ''; DlgMode : TDialogModesSet = []; DBControlData : TDBControlData = nil);
var
  tmp: TStringList;
begin
  tmp := TStringList.Create;
  try
    if uTemplates.UsingHTMLTargetMode then begin   //elh   01/04/10
      tmp.text := FormatHTMLTags(AText);
      tmp.text := FormatImageTags(tmp.text);
    end else begin
      tmp.text := RemoveHTMLTags(AText);
      tmp.text := RemoveImageTags(tmp.text);
    end;
    //kt original --> CheckBoilerplate4Fields(tmp, CaptionText, PreviewMode);
    CheckBoilerplate4Fields(tmp, CaptionText, DlgMode, DBControlData);
    AText := tmp.text;
  finally
    tmp.free;
  end;
end;

procedure TfrmTemplateDialog.SetHTMLAnswerOpenCloseTags(OpenHTML, CloseHTML : string);
//kt 1/16 Added entire function
begin
  FAnswerOpenTag := OpenHTML;
  FAnswerCloseTag := CloseHTML;
end;

procedure TfrmTemplateDialog.SetHTMLAnswerSimpleTag(Value : string);
//kt 9/11 Added entire function
begin
  if Value='' then begin
    FAnswerOpenTag :='';
    FAnswerCloseTag := '';
  end else begin
    if Pos('<',Value)>0 then Value := Piece(Value,'<',2);
    if Pos('>',Value)>0 then Value := Piece(Value,'>',1);
    if Pos('/',Value)>0 then Value := Piece(Value,'/',2);
    FAnswerOpenTag := FAnswerOpenTag+'<'+Value+'>';
    FAnswerCloseTag := FAnswerCloseTag+'</' + Value + '>';
  end;
end;

procedure TfrmTemplateDialog.ChkAll(Chk: boolean);
var
  i: integer;

begin
  for i := 0 to sbMain.ControlCount-1 do
  begin
    if(sbMain.Controls[i] is TORCheckBox) then
      TORCheckBox(sbMain.Controls[i]).Checked := Chk;
  end;
end;

procedure TfrmTemplateDialog.btnAllClick(Sender: TObject);
begin
  ChkAll(TRUE);
end;

procedure TfrmTemplateDialog.btnNoneClick(Sender: TObject);
begin
  ChkAll(FALSE);
end;

function TfrmTemplateDialog.GetObjectID( Control: TControl): string;
var
  idx, idx2: integer;
begin
  result := '';
  if Assigned(Control) then
  begin
    idx := Control.Tag;
    if(idx > 0) then
    begin
      idx2 := BuildIdx.IndexOfObject(TObject(idx));
      if idx2 >= 0 then
        result := BuildIdx[idx2]
      else
        result := Piece(Piece(Piece(Index, U, idx),'~',3), ';', 3);
    end;
  end;
end;

function TfrmTemplateDialog.GetParentID( Control: TControl): string;
var
  idx: integer;
begin
  result := '';
  if Assigned(Control) then
  begin
    idx := Control.Tag;
    if(idx > 0) then
      result := Piece(Piece(Piece(Index, U, idx),'~',3), ';', 4);
  end;
end;

function TfrmTemplateDialog.FindObjectByID( id: string): TControl;
var
  i: integer;
  ObjID: string;
begin
  result := nil;
  if ID <> '' then
  begin
    for i := 0 to sbMain.ControlCount-1 do
    begin
      ObjID := GetObjectID(sbMain.Controls[i]);
      if(ObjID = ID) then
      begin
        result := sbMain.Controls[i];
        break;
      end;
    end;
  end;
end;

procedure TfrmTemplateDialog.InitScreenReaderSetup;
var
  ctrl: TWinControl;
  list: TList;
begin
  if ScreenReaderSystemActive then
  begin
    list := TList.Create;
    try
      sbMain.GetTabOrderList(list);
      if list.Count > 0 then
      begin
        ctrl := TWinControl(list[0]);
        PostMessage(Handle, UM_MISC, WParam(ctrl), 0);
      end;
    finally
      list.free;
    end;
  end;
end;

function TfrmTemplateDialog.IsAncestor( OldID: string; NewID: string): boolean;
begin
  if (OldID = '') or (NewID = '') then
    result := False
  else if OldID = NewID then
    result := True
  else
    result := IsAncestor(OldID, GetParentID(FindObjectByID(NewID)));
end;

procedure TfrmTemplateDialog.BuildCB(CBidx: integer; var Y: integer; FirstTime: boolean);
var
  bGap, Indent, i, idx, p1, p2: integer;
  EID, ID, PID, DlgProps, tmp, txt, tmpID: string;
  pctrl, ctrl: TControl;
  pnl: TPanel;
  KillCtrl, doHint, dsp, noTextParent: boolean;
  Entry: TTemplateDialogEntry;
//  StringIn, StringOut: string;
  cb: TCPRSDialogParentCheckBox;

  procedure NextTabCtrl(ACtrl: TControl);
  begin
    if(ACtrl is TWinControl) then
    begin
      inc(FTabPos);
      TWinControl(ACtrl).TabOrder := FTabPos;
    end;
  end;

begin
  tmp := Piece(Index, U, CBidx);
  p1 := StrToInt(Piece(tmp,'~',1));
  p2 := StrToInt(Piece(tmp,'~',2));
  DlgProps := Piece(tmp,'~',3);
  ID := Piece(DlgProps, ';', 3);
  PID := Piece(DlgProps, ';', 4);

  ctrl := nil;
  pctrl := nil;
  if(PID <> '') then begin
    noTextParent := (NoTextID.IndexOf(PID) < 0)
  end else begin
    noTextParent := TRUE;
  end;
  if not FirstTime then begin
    ctrl := FindObjectByID(ID);
  end;
  if noTextParent and (PID <> '') then begin
    pctrl := FindObjectByID(PID);
  end;
  if(PID = '') then begin
    KillCtrl := FALSE
  end else begin
    if(assigned(pctrl)) then begin
      if(not (pctrl is TORCheckBox)) or
        (copy(DlgProps,3,1) = BOOLCHAR[TRUE]) then // show if parent is unchecked
        KillCtrl := FALSE
      else
        KillCtrl := (not TORCheckBox(pctrl).Checked);
    end else
      KillCtrl := noTextParent;
  end;
  if KillCtrl then begin
    if(assigned(ctrl)) then begin
      if(ctrl is TORCheckBox) and (assigned(TORCheckBox(ctrl).Associate)) then begin
        TORCheckBox(ctrl).Associate.Hide;
      end;
      idx := BuildIdx.IndexOfObject(TObject(ctrl.Tag));
      if idx >= 0 then begin
        BuildIdx.delete(idx);
      end;
      ctrl.Free;
    end;
    exit;
  end;
  tmp := copy(SL.Text, p1, p2);
  tmp := FixNoBRs(tmp); //kt added 3/1/16
  //kt 1/16 moved further downstream --> tmp := RemoveHTMLTags(tmp);  //kt added 9/11
  if(copy(tmp, length(tmp)-1, 2) = CRLF) then begin
    delete(tmp, length(tmp)-1, 2);
  end;
  bGap := StrToIntDef(copy(DlgProps,5,1),0);
  while bGap > 0 do begin
    if(copy(tmp, 1, 2) = CRLF) then begin
      delete(tmp, 1, 2);
      dec(bGap);
    end else begin
      bGap := 0;
    end;
  end;
  if(tmp = NoTextMarker) then begin
    if(NoTextID.IndexOf(ID) < 0) then begin
      NoTextID.Add(ID);
    end;
    exit;
  end;
  if(not assigned(ctrl)) then begin
    dsp := (copy(DlgProps,1,1)=BOOLCHAR[TRUE]);
    EID := 'DLG' + IntToStr(CBIdx);
    idx := FEntries.IndexOf(EID);
    doHint := FALSE;
    txt := tmp;
    if(idx < 0) then begin
      if(copy(DlgProps,2,1)=BOOLCHAR[TRUE]) then begin// First Line Only
        i := pos(CRLF, tmp);
        if(i > 0) then begin
          dec(i);
          if i > 70 then begin
            i := 71;
            while (i > 0) and (tmp[i] <> ' ') do dec(i);
            if i = 0 then
              i := 70
            else
              dec(i);
          end;
          doHint := TRUE;
          tmp := copy(tmp, 1, i) + ' ...';
        end;
      end;
      if not (dsp or OneOnly) then begin  //kt added block
        tmp := HTML_BEGIN_TAG+'<ENABLECB>'+ HTML_ENDING_TAG + tmp +
               HTML_BEGIN_TAG + '</ENABLECB>' + HTML_ENDING_TAG;
      end;
      Entry := GetDialogEntry(sbMain, EID, tmp, DBcontrolData);  //kt 1/16 -- parses text in tmp into FControl (and FHTMLControls)
      //kt original --> Entry := GetDialogEntry(sbMain, EID, tmp);  //kt 1/16 -- parses text in tmp into FControl (and FHTMLControls)
      Entry.AutoDestroyOnPanelFree := TRUE;
      Entry.OnDestroy := EntryDestroyed;
      FEntries.AddObject(EID, Entry);
    end else
      Entry := TTemplateDialogEntry(FEntries.Objects[idx]);

    if(dsp or OneOnly) then
      cb := nil
    else
      cb := TCPRSDialogParentCheckBox.Create(Self);
    Entry.AddToCumulativeHTML(HTMLDlg); //kt added 1/16  NOTE: Browser Loaded() not called yet, so too early to put into web browser
    pnl := Entry.GetPanel(FMaxPnlWidth, sbMain, cb);  //kt doc -- This is where control layout is set up in panel
    pnl.Show;
    if(doHint and (not pnl.ShowHint)) then begin
      pnl.ShowHint := TRUE;
      Entry.Obj := pnl;
      Entry.Text := txt;
      pnl.hint := Entry.GetText;
      Entry.OnChange := FieldChanged;
    end;
    if not assigned(cb) then
      ctrl := pnl
    else begin
      ctrl := cb;
      ctrl.Parent := sbMain;

      //kt TORCheckbox(ctrl).OnEnter := frmTemplateDialog.ParentCBEnter;
      //kt TORCheckbox(ctrl).OnExit := frmTemplateDialog.ParentCBExit;
      TORCheckbox(ctrl).OnEnter := ParentCBEnter;
      TORCheckbox(ctrl).OnExit := ParentCBExit;

      TORCheckBox(ctrl).Height := TORCheckBox(ctrl).Height + 5;
      TORCheckBox(ctrl).Width := 17;

    {Insert next line when focus fixed}
    //  ctrl.Width := IndentGap;
    {Remove next line when focus fixed}
      TORCheckBox(ctrl).AutoSize := false;
      TORCheckBox(ctrl).Associate := pnl;
      pnl.Tag := Integer(ctrl);
      tmpID := copy(ID, 1, (pos('.', ID) - 1)); {copy the ID without the decimal place}
//      if Templates.IndexOf(tmpID) > -1 then
//        StringIn := 'Sub-Template: ' + TTemplate(Templates.Objects[Templates.IndexOf(tmpID)]).PrintName
//      else
//        StringIn := 'Sub-Template:';
//      StringOut := StringReplace(StringIn, '&', '&&', [rfReplaceAll]);
//      TORCheckBox(ctrl).Caption := StringOut;
      UpdateColorsFor508Compliance(ctrl);

    end;
    ctrl.Tag := CBIdx;

    Indent := StrToIntDef(Piece(DlgProps, ';', 5),0) - FirstIndent;
    if dsp then inc(Indent);
    ctrl.Left := Gap + (Indent * IndentGap);
    //ctrl.Width := sbMain.ClientWidth - Gap - ctrl.Left - ScrollBarWidth;
    if(ctrl is TORCheckBox) then
      pnl.Left := ctrl.Left + IndentGap;

    if(ctrl is TORCheckBox) then with TORCheckBox(ctrl) do
    begin
      GroupIndex := StrToIntDef(Piece(DlgProps, ';', 2),0);
      if(GroupIndex <> 0) then
        RadioStyle := TRUE;
      OnClick := ItemChecked;
      StringData := DlgProps;
    end;
    if BuildIdx.IndexOfObject(TObject(CBIdx)) < 0 then
      BuildIdx.AddObject(Piece(Piece(Piece(Index, U, CBIdx),'~',3), ';', 3), TObject(CBIdx));
  end;
  ctrl.Top := Y;
  NextTabCtrl(ctrl);
  if(ctrl is TORCheckBox) then begin
    TORCheckBox(ctrl).Associate.Top := Y;
    NextTabCtrl(TORCheckBox(ctrl).Associate);
    inc(Y, TORCheckBox(ctrl).Associate.Height+1);
  end else
    inc(Y, ctrl.Height+1);
end;

procedure TfrmTemplateDialog.ParentCBEnter(Sender: TObject);
begin
  (Sender as TORCheckbox).FocusOnBox := true;
end;

procedure TfrmTemplateDialog.ParentCBExit(Sender: TObject);
begin
  (Sender as TORCheckbox).FocusOnBox := false;

end;

procedure TfrmTemplateDialog.ItemChecked(Sender: TObject);
begin
  if(copy(TORCheckBox(Sender).StringData,4,1) = '1') then
  begin
    RepaintBuild := TRUE;
    Invalidate;
  end;
end;

procedure TfrmTemplateDialog.BuildAllControls;
var
  i, Y: integer;
  FirstTime: boolean;

begin
  if FBuilding then exit;
  FBuilding := TRUE;
  try
    FTabPos := 0;
    FirstTime := (sbMain.ControlCount = 0);
    NoTextID.Clear;
    Y := Gap - sbMain.VertScrollBar.Position;
    for i := 1 to Count do
      BuildCB(i, Y, FirstTime);
    if ScreenReaderSystemActive then begin
      amgrMain.RefreshComponents;
      Application.ProcessMessages;
    end;
  finally
    FBuilding := FALSE;
  end;
end;

procedure TfrmTemplateDialog.FormPaint(Sender: TObject);
begin
  if RepaintBuild then
  begin
    RepaintBuild := FALSE;
    BuildAllControls;
    InitScreenReaderSetup;
  end;
end;

procedure TfrmTemplateDialog.FormShow(Sender: TObject);
var HTMLText : string;  //kt
    InitialTab : integer;
begin
  inherited;
  if FFirstBuild then begin
    FFirstBuild := FALSE;
    InitScreenReaderSetup;
  end;
  //kt mod 3/16 ----------
  HtmlEditor.Loaded;
  HTMLText := HTMLDlg.HTML.Text;
  HTMLText := FixNoBRs(HTMLText);
  HTMLEditor.HTMLText := HTMLText;
  InitialTab := uTMGOptions.ReadInteger('CPRS Template Inital Tab',0);
  if InitialTab<0 then InitialTab := 0;
  if InitialTab>pcDlg.PageCount-1 then InitialTab := pcDlg.PageCount-1;  
  pcDlg.ActivePageIndex := InitialTab
  //kt end mod 3/16 ----------
end;

procedure TfrmTemplateDialog.FormCreate(Sender: TObject);
begin
  uTemplateDialogRunning := True;
  FFirstBuild := TRUE;
  BuildIdx := TStringList.Create;
  FEntries := TStringList.Create;
  NoTextID := TStringList.Create;
  NameToObjID := TStringList.Create ; //kt 9/11
  Formulas  := TStringList.Create ;   //kt 9/11
  TxtObjects  := TStringList.Create;  //kt 9/11
  //FHTMLGUIMode := false; //kt 1/16
  FOldHintEvent := Application.OnShowHint;
  Application.OnShowHint := AppShowHint;
  //ResizeAnchoredFormToFont(Self);
  FMaxPnlWidth := FontWidthPixel(sbMain.Font.Handle) * MAX_ENTRY_WIDTH; //AGP change Template Dialog to wrap at 80 instead of 74
  SetFormPosition(Self);
  ResizeAnchoredFormToFont(Self);
  SizeFormToCancelBtn();


  //kt  Note: On creation, THtmlObj will remember Application.OnMessage.  But if
  //          another object (say a prior THtmlObj) has become active and already
  //          changed the handler, then there will be a problem.  So probably best
  //          to create them all at once.
  HtmlEditor := THtmlObj.Create(pnlHoldWebBrowser,Application);
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmNotes has been
  //      assigned a parent.  So done elsewhere.
  TWinControl(HtmlEditor).Parent := pnlHoldWebBrowser;
  TWinControl(HtmlEditor).Align:=alClient;
  HTMLDlg := THTMLDlg.Create(HtmlEditor);
end;

procedure TfrmTemplateDialog.AppShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
const
  HistHintDelay = 1200000; // 20 minutes

begin
//  if(HintInfo.HintControl.Parent = sbMain) then
    HintInfo.HideTimeout := HistHintDelay;
  if(assigned(FOldHintEvent)) then
    FOldHintEvent(HintStr, CanShow, HintInfo);
end;

procedure TfrmTemplateDialog.FormDestroy(Sender: TObject);
begin
  //Application.OnShowHint := FOldHintEvent;   v22.11f - RV - moved to OnClose
  NoTextID.Free;
  FreeEntries(FEntries);
  FEntries.Free;
  BuildIdx.Free;
  uTemplateDialogRunning := False;
  NameToObjID.Free; //kt 9/11
  Formulas.Free;    //kt 9/11
  TxtObjects.Free;  //kt 9/11
  HTMLDlg.Free;     //kt 1/16
  HtmlEditor.Free;  //kt 1/16
end;

procedure TfrmTemplateDialog.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  If RectContains(sbMain.BoundsRect, SbMain.ScreenToClient(MousePos)) then
  begin
    ScrollControl(sbMain, (WheelDelta > 0));
    Handled := True;
  end;
end;

procedure TfrmTemplateDialog.FieldChanged(Sender: TObject);
begin
  with TTemplateDialogEntry(Sender) do
    TPanel(Obj).hint := GetText;
end;

procedure TfrmTemplateDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Txt, tmp: string;
  i, p1, p2: integer;
  Save: boolean;

begin
  CanClose := TRUE;
  if FCheck4Required then begin
    FCheck4Required := FALSE;
    Txt := SL.Text;
    //kt begin mod 3/16 ----
    if HTMLGUIMode then begin
      //kt NOTE: here I need to complete looking for required fields in HTML GUI
    end else begin
    //kt end mod ----
      for i := 0 to sbMain.ControlCount-1 do begin
        Save := FALSE;
        if(sbMain.Controls[i] is TORCheckBox) and
          (TORCheckBox(sbMain.Controls[i]).Checked) then begin
          Save := TRUE
        end else if(OneOnly and (sbMain.Controls[i] is TPanel)) then begin
          Save := TRUE;
        end;
        if(Save) then begin
          tmp := Piece(Index,U,sbMain.Controls[i].Tag);
          p1 := StrToInt(Piece(tmp,'~',1));
          p2 := StrToInt(Piece(tmp,'~',2));
          if AreTemplateFieldsRequired(Copy(Txt,p1,p2)) then
            CanClose := FALSE;
        end;
        if not CanClose then begin
          ShowMsg(MissingFieldsTxt);
          break;
        end;
      end;
    end;  //kt
  end;
end;

procedure TfrmTemplateDialog.btnOKClick(Sender: TObject);
begin
  FCheck4Required := TRUE;
end;

procedure TfrmTemplateDialog.btnPreviewClick(Sender: TObject);
var
  TmpSL: TStringList;

begin
  TmpSL := TStringList.Create;
  try
    FastAssign(SL, TmpSL);
    //kt 1/16 original --> GetText(TmpSL, FALSE);  {FALSE = Do not include embedded fields}
    //kt 1/16 begin mod ---------------
    if pcDlg.ActivePage = tsPlainDlg then begin
      GetText(TmpSL, FALSE);  {FALSE = Do not include embedded fields}
    end else if pcDlg.ActivePage = tsHTMLDlg then begin
      GetHTMLText(TmpSL, FALSE);  {FALSE = Do not include embedded fields}
    end;
    //kt 1/16 end mod ---------------
    StripScreenReaderCodes(TmpSL);
    ReportBox(TmpSL, 'Dialog Preview', FALSE);
  finally
    TmpSL.Free;
  end;
end;

procedure TfrmTemplateDialog.EntryDestroyed(Sender: TObject);
var
  idx: integer;

begin
  idx := FEntries.IndexOf(TTemplateDialogEntry(Sender).ID);
  if idx >= 0 then
    FEntries.delete(idx);
end;

procedure TfrmTemplateDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.OnShowHint := FOldHintEvent;
  SaveUserBounds(Self);
end;

procedure TfrmTemplateDialog.SizeFormToCancelBtn;
const
  RIGHT_MARGIN = 12;
var
  minWidth : integer;
begin
  minWidth := btnCancel.Left + btnCancel.Width + RIGHT_MARGIN;
  if minWidth > Self.Width then
    Self.Width := minWidth;
end;

procedure TfrmTemplateDialog.UMScreenReaderInit(var Message: TMessage);
var
  ctrl: TWinControl;
  item: TVA508AccessibilityItem;
begin
  ctrl := TWinControl(Message.WParam);
  // Refresh the accessibility manager entry -
  // fixes bug where first focusable check boxes weren't working correctly  
  if ctrl is TCPRSDialogParentCheckBox then
  begin
    item := amgrMain.AccessData.FindItem(ctrl, FALSE);
    if assigned(item) then
      item.free;
    amgrMain.AccessData.EnsureItemExists(ctrl);
  end;
end;

function TfrmTemplateDialog.GetHTMLTargetMode:boolean;
//kt added function  12/27/12
begin
  result := uTemplates.UsingHTMLTargetMode;
end;
end.

