unit rTMGRPCs;

 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, StrUtils, ComCtrls, uTMGTypes,
  ORNet, ORFn, Trpcb, FMErrorU;

procedure GetAllSubRecordsRPC(SubFileNum, ParentIENS : string; SubRecsList : TStringList; OUT Map : string; Fields : string = ''; Identifier : string = '');
procedure ReminderTest(ReminderIEN, DFNorPtName, AsOfDate : string; DisplayAllTerms : boolean; Result : TStrings);
procedure TaxonomyInquire(IEN : string; Result : TStrings);
function  ExpandFileNumber(var FileNumberOrName : string) : string;
function  GetCurrentUserName : string;
procedure GetUsersList(UsersList : TStringList; HideInactive: boolean);
procedure GetRecordsList(RecordsList : TStringList; FileNum : string);
function  RPCGetRecordInfo(var RPCStringsResult : TStrings; FileNum, IENS : string; CmdName : string='') : boolean;  //RPCBroker owns result
function  DoCloneUser(SourceIENS, New01Field : String) : string;
function  DoCloneRecord(FileNum, SourceIENS, New01Field : String) : string;
function  FieldHelp(CachedHelp, CachedHelpIdx : TStringList; FileNum, IENS, FieldNum, HelpStyle : string) : string;
function  IsWPField(CachedWPField : TStringList; FileNum,FieldNum : string) : boolean;
Procedure GetBlankFileInfo(FileNum : string; BlankList : TStringList);
procedure GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
procedure GetWPField(FileNum, FieldNum, IENS : string; SL : TStringList);
function  PostWPField(Lines: TStrings; FileNum,FieldNum,IENS : string) : boolean;
function  PostChanges(ChangesList : TStringList) : Boolean;
function  MoveReminderElement(SourceNode, DestNode : TTreeNode) : boolean;
function  SubSetOfFile(FileNum: string; const StartFrom: string; Direction: Integer; Screen : string = ''): TStrings;
function  Find1Record(FileNum, Value : string; IENS: string = '';Flags: string = '';Indexes: string = '';Screen: string = '') : string;
function  FindRecord(Results: TStringList; FileNum: string;Value: string;IENS: string = '';Fields: string = '';Flags: string = '';Number: string = '*';Indexes: string = '';Screen: string = '';Identifier: string = '') : boolean;
procedure GetRemDialogItemTreeRoots(RemDlgItemIEN : string; Result : TStrings);
function  ReminderDlgCopyTree(SourceIEN, NameSpace, SponsorIEN : string; AcceptList: TStringList) : string;
function  GetReminderDlgChildList(IEN : string; ChildList: TStrings) : boolean;
procedure GetCodeRoutine(RoutineName : string; SL : TStrings);
function GetFunctionFindingArgumentSignature(FunctionName : string) : string;

var
  LastRPCHadError : boolean;

implementation

{uses
  MainU;}

function CallBrokerAndErrorCheck(var RPCResult : string) : boolean;
//NOTE: the RPC call must be set up prior to call this function.
//Result of this function: true  if all OK, or false if error.
//Also RPCResult is OUT parameter of the RPCBrokerV.Results[0] value
//ALSO LastRPCHadError variable (global scope) is set to error state call.
//Results of RPC Call itself will be in RPCBrokerV
var
  FMErrorForm: TFMErrorForm;

begin
  LastRPCHadError := false;
  Result := true;
  RPCBrokerV.Results.Clear;
  CallBroker;
  RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
  RPCBrokerV.Results.Delete(0);
  if piece(RPCResult,'^',1)='-1' then begin
    LastRPCHadError := true;
    Result := false;
    if RPCBrokerV.Results.Count = 0 then RPCBrokerV.Results.Add(RPCResult);
    FMErrorForm:= TFMErrorForm.Create(nil);
    FMErrorForm.Memo.Lines.Assign(RPCBrokerV.Results);
    FMErrorForm.PrepMessage;
    FMErrorForm.ShowModal;
    FMErrorForm.Free;
  end;
end;

procedure PrepRPC(FnName : string; StrArgs : Array of string);
var cmd : string;
    i : integer;
begin
  RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
  RPCBrokerV.Param[0].Value := '.X';  // not used
  RPCBrokerV.param[0].ptype := list;
  cmd := FnName;
  for i := 0 to High(StrArgs) do begin
    if cmd <> '' then cmd := cmd + '^';
    cmd := cmd + StrArgs[i];

  end;
  RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
end;

procedure GetAllSubRecordsRPC(SubFileNum, ParentIENS : string;
                              SubRecsList : TStringList;
                              OUT Map : string;
                              Fields : string = '';
                              Identifier : string = '');
var  RPCResult : string;
begin
  SubRecsList.Clear;
  if Pos('^', Identifier)>0 then begin
    Identifier := StringReplace(Identifier, '^', '%', [rfReplaceAll]);  //This will be converted back in server RPC code.   
  end;
  PrepRPC('GET SUB RECS LIST', [SubFileNum, ParentIENS, Fields, Identifier]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Map := MidStr(RPCResult, Length('1^Success^')+1, Length(RPCResult));
    SubRecsList.Assign(RPCBrokerV.Results);
  end;
end;

procedure ReminderTest(ReminderIEN, DFNorPtName, AsOfDate : string;
                       DisplayAllTerms : boolean; Result : TStrings);
//ReminderIEN is IEN in file 811.9 (REMINDER DEFINITION)
var RPCResult : string;

begin
  Result.Clear;
  PrepRPC('GET REMINDER TEST',[ReminderIEN, DFNorPtName, AsOfDate, TF_TXT[DisplayAllTerms]]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Result.Assign(RPCBrokerV.Results);
  end;
end;

procedure GetRemDialogItemTreeRoots(RemDlgItemIEN : string; Result : TStrings);
//For a given Reminder dialog item, return list of the root item of
//   any tree that item is a member of.
//Resulting list format:  .Strings[x]='IEN^Name'
var RPCResult : string;
begin
  Result.Clear;
  PrepRPC('GET REMINDER DLG ITEM TREE ROOTS', [RemDlgItemIEN]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Result.Assign(RPCBrokerV.Results);
  end;
end;


procedure TaxonomyInquire(IEN : string; Result : TStrings);
var RPCResult : string;
begin
  Result.Clear;
  PrepRPC('GET REMINDER TAXONOMY INQUIRE', [IEN]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Result.Assign(RPCBrokerV.Results);
  end;
end;

function ExpandFileNumber(var FileNumberOrName : string) : string;  //Returns expanded file NAME
//NOTE: FileNumberOrName is also an OUT parameter.  File NUMBER is returned if no problems.
var RPCResult : string;
begin
  Result := '??'; //default result
  PrepRPC('GET EXPANDED FILENAME', [FileNumberOrName]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    if RPCBrokerV.Results.Count > 0 then begin
      Result := RPCBrokerV.Results[0];  //This was index 1 before 0 index was deleted above
      FileNumberOrName := piece(Result,'^',2);
      Result := piece(Result,'^',1);
    end;
  end;
end;


function GetCurrentUserName : string;
var RPCResult : string;
begin
  PrepRPC('GET CURRENT USER NAME',[]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    result := piece(RPCResult,'^',3);
  end;
end;

procedure GetUsersList(UsersList : TStringList; HideInactive: boolean);
var  RPCResult : string;
begin
  UsersList.Clear;
  PrepRPC('GET USER LIST', []);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    UsersList.Assign(RPCBrokerV.Results);
  end;
end;

procedure GetRecordsList(RecordsList : TStringList; FileNum : string);
//Format of Records list:
//  .01Value^IEN^FileNum
//  .01Value^IEN^FileNum
var  RPCResult : string;
begin
  RecordsList.Clear;
  PrepRPC('GET RECORDS LIST', [FileNum]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    RecordsList.Assign(RPCBrokerV.Results);
  end;
end;


function RPCGetRecordInfo(var RPCStringsResult : TStrings; FileNum, IENS : string; CmdName : string='') : boolean;  //RPCBroker owns result
var RPCResult : string;
begin
  Result := true;
  if CmdName = '' then CmdName := 'GET ONE RECORD';
  PrepRPC(CmdName, [FileNum, IENS]);
  Result := CallBrokerAndErrorCheck(RPCResult);
  RPCStringsResult := RPCBrokerV.Results;
  //RPCBrokerV passed out in RPCStringsResult
end;


function DoCloneUser(SourceIENS, New01Field : String) : string;
//Returns IENS of new record in FileNum, or '' if error
var  RPCResult : string;
begin
  Result := '';
  PrepRPC('CLONE USER', [SourceIENS, New01Field]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    result := piece(RPCResult,'^',3);
  end;
end;

function DoCloneRecord(FileNum, SourceIENS, New01Field : String) : string;
//Returns IENS of new record in FileNum, or '' if error
var  RPCResult : string;
begin
  Result := '';
  PrepRPC('CLONE RECORD', [FileNum, SourceIENS, New01Field]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    result := piece(RPCResult,'^',3);
  end;
end;

function FieldHelp(CachedHelp, CachedHelpIdx : TStringList; FileNum, IENS, FieldNum, HelpStyle : string) : string;
var
   RPCResult: string;
   SrchStr : string;
   Idx : integer;
begin
  Result := '';
  SrchStr := FileNum + '^' + FieldNum + '^' + HelpStyle + '^' + IENS;
  Idx := CachedHelpIdx.IndexOf(SrchStr);
  if Idx = -1 then begin
    PrepRPC('GET HELP MSG', [SrchStr]);
    if CallBrokerAndErrorCheck(RPCResult) then begin
      if RPCBrokerV.Results.Count > 0 then begin
        if RPCBrokerV.Results.Strings[RPCBrokerV.Results.Count-1]='' then begin
          RPCBrokerV.Results.Delete(RPCBrokerV.Results.Count-1);
        end;
      end;
      result := RPCBrokerV.Results.Text;
      if result = '' then result := ' ';
      //Maybe later replace text with "Enter F1 for more help."
      Result := ReplaceText(Result,'Enter ''??'' for more help.','');
      while Result[Length(Result)] in [#10,#13] do begin
        Result := LeftStr(Result,Length(Result)-1);
      end;
      Idx := CachedHelp.Add(result);
      CachedHelpIdx.AddObject(SrchStr,Pointer(Idx));  //Store index here to help stored in CachedHelp
    end;
  end else begin
    Idx := Integer(CachedHelpIdx.Objects[Idx]);
    if (Idx >= 0) and (Idx < CachedHelp.Count) then begin
      result := CachedHelp.Strings[Idx];
    end;
  end;
end;

Procedure GetBlankFileInfo(FileNum : string; BlankList : TStringList);
var   RPCResult: string;
//Returned format for BlankList is:
//FileNum^^FieldNum^^FieldName^More DDInfo
//FileNum^^FieldNum^^FieldName^More DDInfo
begin
  PrepRPC('GET EMPTY ENTRY', [FileNum]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    BlankList.Assign(RPCBrokerV.Results);
  end;
end;

function IsWPField(CachedWPField : TStringList; FileNum,FieldNum : string) : boolean;
var RPCResult : string;
    SrchStr : string;
    Idx: integer;
begin
  SrchStr := FileNum + '^' +  FieldNum + '^';
  Idx := CachedWPField.IndexOf(SrchStr + 'YES');
  if Idx > -1 then begin Result := true; exit; end;
  Idx := CachedWPField.IndexOf(SrchStr + 'NO');
  if Idx > -1 then begin Result := false; exit; end;

  result := false;
  PrepRPC('IS WP FIELD', [FileNum, FieldNum]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    RPCResult := piece(RPCResult,'^',3);
    result := (RPCResult = 'YES');
    CachedWPField.Add(SrchStr + RPCResult);
  end;
end;

procedure GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
//Data is an OUT parameter.

var RPCResult : string;
    i : integer;
    oneEntry : string;
begin
  Data.Clear;
  if (IENS='') then exit;
  if Pos('+',IENS)=0 then begin //don't ask server to load +1 records.
    PrepRPC('GET ONE RECORD', [FileNum, IENS]);
    if CallBrokerAndErrorCheck(RPCResult) then begin
      Data.Assign(RPCBrokerV.Results);
    end;
  end else begin
    //Data.Add('1^Success');  //to keep same as call to server
    if BlankFileInfo.Count = 0 then begin
      //Format is: FileNum^^FieldNum^^DDInfo...
      GetBlankFileInfo(FileNum,BlankFileInfo);
    end;
    for i := 0 to BlankFileInfo.Count-1 do begin
      oneEntry := BlankFileInfo.Strings[i];
      SetPiece(oneEntry,'^',2,IENS);
      Data.Add(oneEntry);
    end;
  end;
end;


procedure GetWPField(FileNum, FieldNum, IENS : string; SL : TStringList);
var   RPCResult: string;
      lastLine : string;
begin
  SL.Clear;
  RPCBrokerV.Results.Clear;
  if (FileNum <> '') and (FieldNum <> '') and (IENS <> '') then begin
    PrepRPC('GET ONE WP FIELD', [FileNum, FieldNum, IENS]);
    if CallBrokerAndErrorCheck(RPCResult) then begin
      SL.Assign(RPCBrokerV.Results);
      if SL.Count > 0 then begin
        lastLine := SL.Strings[SL.Count-1];
        //I can't figure out where these are coming from...
        if (lastLine='WORD-PROCESSING') or (lastLine = 'POINTER')
        or (lastLine='FREE TEXT') then begin
          SL.Delete(SL.Count-1);
        end;
      end;
    end;
  end;
end;


function PostWPField(Lines: TStrings; FileNum,FieldNum,IENS : string) : boolean;
//Returns true if successful.
var   RPCResult: string;
      i : integer;
begin
  Result := false; //default to failure.
  RPCBrokerV.Results.Clear;
  if (FileNum <> '') and (FieldNum <> '') and (IENS <> '') then begin
    PrepRPC('POST WP FIELD', [FileNum, FieldNum, IENS]);
    if Lines.Count > 0 then begin
      for i := 0 to Lines.Count-1 do begin
        RPCBrokerV.Param[0].Mult['"' + IntToStr(i+1) + '"'] := Lines.Strings[i];
      end;
    end else begin
      RPCBrokerV.Param[0].Mult['"1"'] := '';
    end;
    Result := CallBrokerAndErrorCheck(RPCResult)
  end;
end;

function PostChanges(ChangesList : TStringList) : Boolean;
//ChangesList Format:  .Strings[x]=FileNum^IENS^FieldNum^FieldName^newValue^oldValue
//Result: TRUE if no errors

var  RPCResult : string;
     i : integer;
begin
  PrepRPC('POST DATA', []);
  RPCBrokerV.Param[0].Mult.Sorted := false;
  for i := 0 to ChangesList.Count-1 do begin
    // FileNum^IENS^FieldNum^FieldName^newValue^oldValue
    RPCBrokerV.Param[0].Mult[IntToStr(i)] := ChangesList.Strings[i];
  end;
  Result := CallBrokerAndErrorCheck(RPCResult);
end;


function MoveReminderElement(SourceNode, DestNode : TTreeNode) : boolean;
//Returns TRUE if no error
var  RPCResult : string;
     SrcIEN,DestIEN,ParentIEN : String;
     SeqNum : string;
begin
  SrcIEN := IntToStr(Integer(SourceNode.Data));
  DestIEN := IntToStr(Integer(DestNode.Data));
  ParentIEN := IntToStr(Integer(SourceNode.Parent.Data));
  SeqNum := ''; //Later determine new sequence number...
  PrepRPC('REMINDER DIALOG MOVE ELEMENT', [SrcIEN, ParentIEN, DestIEN, SeqNum]);
  Result := CallBrokerAndErrorCheck(RPCResult);
  if Result then begin
    SourceNode.MoveTo(DestNode, naAddChild);  //**FINISH** change TNodeAttachMode to match Sequence
  end;
end;


function SubSetOfFile(FileNum: string; const StartFrom: string;
                      Direction: Integer; Screen : string = ''): TStrings;

{ returns a pointer to a list of file entries (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must
  be used BEFORE the next broker call! }
var
  RPCResult : string;
begin
  PrepRPC('FILE ENTRY SUBSET', [FileNum, StartFrom, IntToStr(Direction), '', '', Screen]);
  CallBroker; //RPCBrokerV.Call;
  RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
  if piece(RPCResult,'^',1)='-1' then begin
   // handle error...
  end else begin
    RPCBrokerV.Results.Delete(0);
    if RPCBrokerV.Results.Count=0 then begin
      //RPCBrokerV.Results.Add('0^<NO DATA>');
    end;
  end;
  Result := RPCBrokerV.Results;
end;


function Find1Record(FileNum, Value : string;
                     IENS    : string = '';
                     Flags   : string = '';
                     Indexes : string = '';
                     Screen  : string = ''    ) : string;
//Wrapper for $$FIND1^DIC.  See Fileman documentation regarding use of inputs.
//Note: Indexes MUST be delimited with ";", not "^"
//      Screen can not contain "^"
//Returns found IEN, or 0 if none
var   RPCResult: string;
      //i : integer;
begin
  Result := '0'; //default to failure.
  PrepRPC('FIND ONE RECORD', [FileNum, IENS, Value, Flags, Indexes, Screen]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Result := piece(RPCResult, '^',2);
    if Result = '' then Result := '0';
  end;
end;

function FindRecord(Results    : TStringList;
                    FileNum    : string;
                    Value      : string;
                    IENS       : string = '';
                    Fields     : string = '';
                    Flags      : string = '';
                    Number     : string = '*';
                    Indexes    : string = '';
                    Screen     : string = '';
                    Identifier : string = ''   ) : boolean;
//Wrapper for FIND^DIC.  See Fileman documentation regarding use of inputs.
//Note: Indexes MUST be delimited with ";", not "^"
//      Screen can not contain "^"
//Returns: true if successfule, or false if error.
//NOTE: Fills Results list from RPCBrokerV.Results
var   RPCResult: string;
      //i : integer;
begin
  Result := false;  //default
  if not assigned(Results) then exit;
  PrepRPC('FIND RECORDS', [FileNum, IENS, Value, Flags, Indexes, Screen]);
  Result := CallBrokerAndErrorCheck(RPCResult);
  Results.Assign(RPCBrokerV.Results);
end;


function ReminderDlgCopyTree(SourceIEN, NameSpace, SponsorIEN : string; AcceptList: TStringList) : string;
//IEN = IEN in 801.41
//Namespace = e.g. 'ZZ', or 'TMG'  Namespace for copied record(s)
//AcceptList (Optional) -- List of child names or namespaces to NOT copy.
//Result is IEN^NewName of newly copied record or '' if problem

var RPCResult : string;
    i : integer;
    AcceptListStr : string;
begin
  Result := '';
  if (SourceIEN='') then exit;
  AcceptListStr := '';
  if assigned(AcceptList) then for i := 0 to AcceptList.Count - 1 do begin
    AcceptListStr := AcceptListStr + AcceptList.Strings[i]+';';
  end;
  PrepRPC('REMINDER DIALOG COPY TREE', [SourceIEN, NameSpace, SponsorIEN, AcceptListStr]);
  //PrepRPC('REMINDER DIALOG COPY TREE', [SourceIEN, NameSpace, AcceptListStr]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    Result := pieces(RPCResult,'^',3,4);
  end;
end;


function GetReminderDlgChildList(IEN : string; ChildList: TStrings) : boolean;
//IEN = IEN in 801.41
//ChildList -- List to load children into.
//Result : True if OK, or false if problem.
var RPCResult : string;
begin
  Result := false;
  if not assigned(ChildList) then exit;
  ChildList.Clear;
  if (IEN='') then exit;
  PrepRPC('GET REMINDER DLG CHILD LIST', [IEN]);
  Result := CallBrokerAndErrorCheck(RPCResult);
  if Result then begin
    ChildList.Assign(RPCBrokerV.Results);
  end;
end;

procedure GetCodeRoutine(RoutineName : string; SL : TStrings);
var   RPCResult: string;
begin
  SL.Clear;
  RPCBrokerV.Results.Clear;
  PrepRPC('GET CODE ROUTINE', [RoutineName]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    SL.Assign(RPCBrokerV.Results);
  end;
end;

function GetFunctionFindingArgumentSignature(FunctionName : string) : string;
//Result:  X^X^X^X^X ....  or '' if not found / problem
//   'X' is code for argument types:  F=Finding, N=Number, S=String
//Note: Some functions (MAXDATE, MINDATE etc) will return a result with
//      99 pieces, because 1-99 args are allowed
var   RPCResult: string;
begin
  Result := '';
  RPCBrokerV.Results.Clear;
  PrepRPC('GET FUNC FINDING ARG SIGNATURE', [FunctionName]);
  if CallBrokerAndErrorCheck(RPCResult) then begin
    if RPCBrokerV.Results.Count>0 then begin
      Result := RPCBrokerV.Results.Strings[0];
    end;
  end;
end;

end.
