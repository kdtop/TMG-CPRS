unit rTopics;
//kt //codex 9/14/26 -- Added entire unit

interface

uses
  ORNet, ORFn, System.Classes, uCore, System.SysUtils;

type
  TTopicDataString = string[64];  //Limit of 64 chars emposed on server data.

function TopicList(Dest: TStrings; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
function Get1Topic(Dest : TStrings; SubIEN : String; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
function SetTopicUserData(SubIEN : String; UserData : TTopicDataString) : string;
function SetTopicFMDTEntryHidenState(SubIEN : String; EntryFMDT : TFMDateTime; ShouldHide : boolean) : string;
function SetTopicFMDTEntryUserData(SubIEN : String; EntryFMDT : TFMDateTime; UserData : TTopicDataString) : string;


implementation

function TopicCommand(Dest: TStrings; DFN: String; Cmd : string; Data : string; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string; forward;

const BOOL_TO_YN : Array[false..true] of string=('', 'Y');

function TopicList(Dest: TStrings; SDT: TFMDateTime = 0; EDT: TFMDateTime=9999999) : string;
//Output:  Dest.Strings(#)='<topicSubIEN22719.21>^<topic name>^<HIDDEN>^<USER DATA>'
//Result: '1^OK' or '-1^Error Message'

begin
  Result := TopicCommand(Dest, Patient.DFN, 'LIST', '', SDT,EDT);
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
  Result := TopicCommand(Dest, Patient.DFN, 'GET1', SubIEN, SDT,EDT);

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


function TopicCommand(Dest: TStrings;   //Output object
                      DFN: String;
                      Cmd : string;        //A valid command, as defined in TOPICCMD^TMGTOPIC
                      Data : string;    //Data (^ delimited) to accompany Cmd, as defined in TOPICCMD^TMGTOPIC
                      SDT: TFMDateTime = 0;       //Start and end dates, for command.
                      EDT: TFMDateTime = 9999999  //Start and end dates, for command.
                     ) : string;
var Params : string;
begin
  Result := '-1^Unknown Error';
  if not Assigned(Dest) then exit;
  Params := Cmd + ':' + Data;
  Result := sCallV('TMG RPC THREAD/TOPIC CMD', [DFN, Params, SDT, EDT]);
  if Result = '1^OK' then begin
    if RPCBrokerV.Results.Count > 0 then RPCBrokerV.Results.Delete(0);
  end;
  Dest.Assign(RPCBrokerV.Results);

end;



end.
