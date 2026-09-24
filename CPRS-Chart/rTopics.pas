unit rTopics;
//kt //codex 9/14/26 -- Added entire unit

interface

uses
  ORNet, ORFn, System.Classes, uCore, System.SysUtils, System.Generics.Collections; //kt //codex 9/22/26

type
  TTopicDataString = string[64];  //Limit of 64 chars emposed on server data.
  TTopicEntryChange = class //kt //codex 9/22/26
    HiddenChanged: Boolean; //kt //codex 9/22/26
    Hidden: string; //kt //codex 9/22/26
    UserDataChanged: Boolean; //kt //codex 9/22/26
    UserData: string; //kt //codex 9/22/26
  end;
  TTopicEntryChanges = class(TObjectDictionary<string, TTopicEntryChange>); //kt //codex 9/22/26
  TTopicChange = class //kt //codex 9/21/26
    PropertyID: string; //kt //codex 9/21/26
    HiddenChanged: Boolean; //kt //codex 9/21/26
    Hidden: string; //kt //codex 9/21/26
    UserDataChanged: Boolean; //kt //codex 9/21/26
    UserData: string; //kt //codex 9/21/26
    EntryChanges: TTopicEntryChanges; //kt //codex 9/22/26
    constructor Create; //kt //codex 9/22/26
    destructor Destroy; override; //kt //codex 9/22/26
  end;
  TTopicChanges = TObjectDictionary<string, TTopicChange>; //kt //codex 9/22/26

function TopicList(Dest: TStrings; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
function Get1Topic(Dest : TStrings; SubIEN : String; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
function RenameTopic(SubIEN, TopicName: string): string; //kt //codex 9/24/26
function SetTopicUserData(SubIEN : String; UserData : TTopicDataString) : string;
function SetTopicFMDTEntryHidenState(SubIEN : String; EntryFMDT : TFMDateTime; ShouldHide : boolean) : string;
function SetTopicFMDTEntryUserData(SubIEN : String; EntryFMDT : TFMDateTime; UserData : TTopicDataString) : string;
function SaveTopicChanges(Changes: TTopicChanges): string; //kt //codex 9/21/26
function MergeTopics(SrcSubIEN, DestSubIEN : string) : string;  overload;
function MergeTopics(SrcSubIENs : TStringList; DestSubIEN : string) : string; overload; //kt //codex 9/23/26


implementation

function TopicCommand(Dest: TStrings; DFN: String; Cmd : string; Data : string; DataSL : TStringList = nil; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string; forward;

const BOOL_TO_YN : Array[false..true] of string=('', 'Y');

constructor TTopicChange.Create;
//kt //codex added entire constructor 9/22/26
begin
  inherited Create;
  EntryChanges := TTopicEntryChanges.Create([doOwnsValues]);
end;

destructor TTopicChange.Destroy;
//kt //codex added entire destructor 9/22/26
begin
  EntryChanges.Free;
  inherited;
end;

function TopicList(Dest: TStrings; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
//Output:  Dest.Strings(#)='<topicSubIEN22719.21>^<LastUsed_FMDT>^<topic name>^<HIDDEN>^<USER DATA>'
//Result: '1^OK' or '-1^Error Message'

begin
  Result := TopicCommand(Dest, Patient.DFN, 'LIST', '', nil, SDT,EDT);
end;

function RenameTopic(SubIEN, TopicName: string): string;
//kt //codex added entire function 9/24/26
var
  TempSL: TStringList;
  Params: string;
begin
  TempSL := TStringList.Create;
  Params := SubIEN + '^' + TopicName;
  try
    Result := TopicCommand(TempSL, Patient.DFN, 'RENAME', Params);
  finally
    TempSL.Free;
  end;
end;

function MergeTopics(SrcSubIEN, DestSubIEN : string) : string; overload;
//note: SrcSubIEN and DESTSubIEN are really IEN22719.21
//Result: '1^OK' or '-1^Error Message'
var SrcSubIENs : TStringList;
begin
  SrcSubIENs := TStringList.Create;
  SrcSubIENs.Add(SrcSubIEN);
  try
    Result := MergeTopics(SrcSubIENs, DestSubIEN);
  finally
    SrcSubIENs.Free;
  end;
end;

function MergeTopics(SrcSubIENs : TStringList; DestSubIEN : String) : string;  overload;
//note: SrcSubIENs.Strings[i] and DESTSubIEN are really IEN22719.21
//Result: '1^OK' or '-1^Error Message'
var tempSL : TStringList;
    Params : string;
    i : integer;
begin
  tempSL := TStringList.Create;
  Params := DestSubIEN;
  for i := 0 to SrcSubIENs.count-1 do begin
    Params := Params + '^' + SrcSubIENs.Strings[i];
  end;
  try
    Result := TopicCommand(tempSL, Patient.DFN, 'MERGE TOPICS', Params);
  finally
    tempSL.free;
  end;
end;


function SetTopicHiddenState(Dest : TStrings; SubIEN : String; ShouldHide : boolean) : string;
//note: SubIEN is really IEN22719.21
//Result: '1^OK' or '-1^Error Message'
var tempSL : TStringList;
    Params : string;
begin
  tempSL := TStringList.Create;
  Params := SubIEN+'^'+BOOL_TO_YN[ShouldHide];
  try
    Result := TopicCommand(tempSL, Patient.DFN, 'SET TOPIC HIDDEN', Params);
  finally
    tempSL.free;
  end;

end;

function Get1Topic(Dest : TStrings; SubIEN : String; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
//note: SubIEN is really IEN22719.21
//Output:  TMGRESULT(#)=0^<TOPIC NAME>^<HIDDEN>^<USER DATA>
//         TMGRESULT(#)=1^<FMDT>^<IEN8925>^<HIDDEN>^<USER DATA>    <-- '1' indicates start of document text
//         TMGRESULT(#)=2^<line of text>    <-- '2' (may be multiple) gives lines of text until next '1' node
//Result: '1^OK' or '-1^Error Message'
begin
  Result := TopicCommand(Dest, Patient.DFN, 'GET1', SubIEN, nil, SDT,EDT);
end;


function SetTopicUserData(SubIEN : String; UserData : TTopicDataString) : string;
//note: SubIEN is really IEN22719.21
//Result: '1^OK' or '-1^Error Message'
var tempSL : TStringList;
    Params : string;
begin
  tempSL := TStringList.Create;
  Params := SubIEN +'^'+ String(UserData);
  try
    Result := TopicCommand(tempSL, Patient.DFN, 'SET TOPIC USER DATA', Params);
  finally
    tempSL.free;
  end;

end;

function SetTopicMult(Changes: TTopicChanges): string; //kt //codex 9/22/26
var
  DataSL: TStringList; //kt //codex 9/22/26
  ResultSL: TStringList; //kt //codex 9/22/26
  Pair: TPair<string, TTopicChange>; //kt //codex 9/22/26
  TopicChange: TTopicChange; //kt //codex 9/22/26
  EntryPair: TPair<string, TTopicEntryChange>; //kt //codex 9/22/26
  EntryChange: TTopicEntryChange; //kt //codex 9/22/26
  HasTopicChanges: Boolean; //kt //codex 9/22/26
begin
  Result := '1^OK'; //kt //codex 9/22/26
  if (not Assigned(Changes)) or (Changes.Count = 0) then Exit; //kt //codex 9/22/26
  DataSL := TStringList.Create; //kt //codex 9/22/26
  ResultSL := TStringList.Create; //kt //codex 9/22/26
  try
    for Pair in Changes do begin //kt //codex 9/22/26
      TopicChange := Pair.Value; //kt //codex 9/22/26
      if not Assigned(TopicChange) then Continue; //kt //codex 9/22/26
      HasTopicChanges := TopicChange.HiddenChanged or TopicChange.UserDataChanged; //kt //codex 9/22/26
      if not HasTopicChanges then begin //kt //codex 9/22/26
        for EntryPair in TopicChange.EntryChanges do begin //kt //codex 9/22/26
          EntryChange := EntryPair.Value; //kt //codex 9/22/26
          if Assigned(EntryChange) and (EntryChange.HiddenChanged or EntryChange.UserDataChanged) then begin //kt //codex 9/22/26
            HasTopicChanges := True; //kt //codex 9/22/26
            Break;
          end;
        end;
      end;
      if not HasTopicChanges then Continue; //kt //codex 9/22/26
      DataSL.Add('IEN=' + Pair.Key); //kt //codex 9/22/26
      if TopicChange.HiddenChanged then DataSL.Add('HIDDEN=' + TopicChange.Hidden); //kt //codex 9/22/26
      if TopicChange.UserDataChanged then DataSL.Add('USER DATA=' + TopicChange.UserData); //kt //codex 9/22/26
      for EntryPair in TopicChange.EntryChanges do begin //kt //codex 9/22/26
        EntryChange := EntryPair.Value; //kt //codex 9/22/26
        if (not Assigned(EntryChange)) or ((not EntryChange.HiddenChanged) and (not EntryChange.UserDataChanged)) then Continue; //kt //codex 9/22/26
        DataSL.Add('FMDT=' + EntryPair.Key); //kt //codex 9/22/26
        if EntryChange.HiddenChanged then DataSL.Add('HIDDEN=' + EntryChange.Hidden); //kt //codex 9/22/26
        if EntryChange.UserDataChanged then DataSL.Add('USER DATA=' + EntryChange.UserData); //kt //codex 9/22/26
      end;
    end;
    if DataSL.Count > 0 then Result := TopicCommand(ResultSL, Patient.DFN, 'SET TOPIC MULTI', '', DataSL); //kt //codex 9/22/26
  finally
    ResultSL.Free; //kt //codex 9/22/26
    DataSL.Free; //kt //codex 9/22/26
  end;
end;

function SetTopicFMDTEntryHidenState(SubIEN : String; EntryFMDT : TFMDateTime; ShouldHide : boolean) : string;
//note: SubIEN is really IEN22719.21
var tempSL : TStringList;
    Params : string;
begin
  tempSL := TStringList.Create;
  Params := SubIEN +'^'+ FloatToStr(EntryFMDT) + '^' + BOOL_TO_YN[ShouldHide];
  try
    Result := TopicCommand(tempSL, Patient.DFN, 'SET TOPIC FMDT ENTRY HIDDEN', Params);
  finally
    tempSL.free;
  end;

end;

function SetTopicFMDTEntryUserData(SubIEN : String; EntryFMDT : TFMDateTime; UserData : TTopicDataString) : string;
//note: SubIEN is really IEN22719.21
//Result: '1^OK' or '-1^Error Message'
var tempSL : TStringList;
    Params : string;
begin
  tempSL := TStringList.Create;
  Params := SubIEN +'^'+ FloatToStr(EntryFMDT) + '^' + String(UserData);
  try
    Result := TopicCommand(tempSL, Patient.DFN, 'SET TOPIC FMDT ENTRY HIDDEN', Params);
  finally
    tempSL.free;
  end;

end;

function SaveTopicChanges(Changes: TTopicChanges): string;
//kt //codex added entire function 9/21/26
begin
  if not Assigned(Changes) then
    Result := '1^OK'
  else
    //kt //codex original --> Result := '-1^Topic change RPC saving is not implemented.';
    Result := SetTopicMult(Changes); //kt //codex 9/22/26
end;


function TopicCommand(Dest: TStrings;   //Output object
                      DFN: String;      //Patient IEN
                      Cmd : string;     //A valid command, as defined in TOPICCMD^TMGTOPIC
                      Data : string;    //Data (^ delimited) to accompany Cmd, as defined in TOPICCMD^TMGTOPIC
                      DataSL : TStringList = nil; //Additional data in TStringList (optional)
                      SDT: TFMDateTime = 0;       //Start and end dates, for command.
                      EDT: TFMDateTime = 9999999  //Start and end dates, for command.
                     ) : string;
var Params : string;
begin
  Result := '-1^Unknown Error';
  if not Assigned(Dest) then exit;
  Params := Cmd + ':' + Data;
  if assigned(DataSL) then begin
    Result := sCallV('TMG RPC THREAD/TOPIC CMD', [DFN, Params, SDT, EDT, DataSL]);
  end else begin
    Result := sCallV('TMG RPC THREAD/TOPIC CMD', [DFN, Params, SDT, EDT]);
  end;
  if Result = '1^OK' then begin
    if RPCBrokerV.Results.Count > 0 then RPCBrokerV.Results.Delete(0);
  end;
  Dest.Assign(RPCBrokerV.Results);

end;



end.
