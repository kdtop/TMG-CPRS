unit rProbs;

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

uses SysUtils, Classes, ORNet, ORFn, uCore;

function AddSave(PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
function AuditHistory(ProblemIFN: string): TStrings ;
function ClinicFilterList(LocList: TStringList): TStrings ;
function ClinicSearch(DummyArg:string): TStrings ;
function ProblemDelete(ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string): TStrings ;
{function ProblemDetail}
function EditLoad(ProblemIFN: string; ProviderID: int64; ptVAMC: string): TStrings ;
function EditSave(ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
function InitPt(const PatientDFN: string): TStrings ;  //*DFN*
function InitUser(ProviderID: int64): TStrings ;
function PatientProviders(const PatientDFN: string): TStrings ;  //*DFN*
function OldProblemLexiconSearch(SearchFor: string; Matches: integer; ADate: TFMDateTime = 0): TStrings ;
function ProblemList(const PatientDFN: string; Status:string; ADate: TFMDateTime): TStrings ;  //*DFN*
function ProblemLexiconSearch(SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): TStrings ;
function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
function ProviderFilterList(ProvList: TStringList): TStrings ;
function ProviderList(Flag:string; Number:integer; From,Part: string): TStrings ;
function ProblemReplace(ProblemIFN: string): TStrings ;
function ServiceFilterList(LocList: TStringList): TStrings ;
function ServiceSearch(const StartFrom: string; Direction: Integer; All: boolean = FALSE): TStrings;
function ProblemUpdate(AltProbFile: TStringList): TStrings ;
function UserProblemCategories(Provider: int64; Location: integer): TStrings ;
function UserProblemList(CategoryIEN: string): TStrings ;
function ProblemVerify(ProblemIFN: string): TStrings ;
function GetProblemComments(ProblemIFN: string): TStrings;
procedure SaveViewPreferences(ViewPref: string);
function CheckForDuplicateProblem(TermIEN, TermText: string): string;

implementation

function AddSave(PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
begin
   CallV('ORQQPL ADD SAVE',[PatientInfo, ProviderID, ptVAMC, ProbFile, SearchString]);
   Result := RPCBrokerV.Results ;
end ;

function AuditHistory(ProblemIFN: string): TStrings ;
begin
   CallV('ORQQPL AUDIT HIST',[ProblemIFN]);
   Result := RPCBrokerV.Results ;
end ;

function ClinicFilterList(LocList: TStringList): TStrings ;
begin
   CallV('ORQQPL CLIN FILTER LIST',[LocList]);
   MixedCaseList(RPCBrokerV.Results) ;
   Result := RPCBrokerV.Results;
end ;

function ClinicSearch(DummyArg:string): TStrings ;
begin
   CallV('ORQQPL CLIN SRCH',[DummyArg]);
   Result := RPCBrokerV.Results ;
end ;

function ProblemDelete(ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string): TStrings ;
begin
   CallV('ORQQPL DELETE',[ProblemIFN, ProviderID, ptVAMC, Comment]);
   Result := RPCBrokerV.Results ;
end ;

function EditLoad(ProblemIFN: string; ProviderID: int64; ptVAMC: string): TStrings ;
//kt NOTE: With patching of my system, it appears that the parameters ProviderID and ptVAMC has been REMOVED
//         Because server code (as of 4/26/2019) only accepts 1 parameters (beyone return parameter), not 3.
//         So will removed ProviderID and ptVAMC
begin
   //kt CallV('ORQQPL EDIT LOAD',[ProblemIFN, ProviderID, ptVAMC]);
   CallV('ORQQPL EDIT LOAD',[ProblemIFN]);  //kt mod  2/19/23
   Result := RPCBrokerV.Results ;
end ;

function EditSave(ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
begin
   CallV('ORQQPL EDIT SAVE',[ProblemIFN, ProviderID, ptVAMC, PrimUser, ProbFile, SearchString]);
   Result := RPCBrokerV.Results ;
end ;

function InitPt(const PatientDFN: string): TStrings ;  //*DFN*
begin
   CallV('ORQQPL INIT PT',[PatientDFN]);
   Result := RPCBrokerV.Results ;
end ;

function InitUser(ProviderID: int64): TStrings ;
begin
   CallV('ORQQPL INIT USER',[ProviderID]);
   Result := RPCBrokerV.Results ;
end ;

function PatientProviders(const PatientDFN: string): TStrings ;  //*DFN*
begin
   CallV('ORQPT PATIENT TEAM PROVIDERS',[PatientDFN]);
   Result := RPCBrokerV.Results ;
end ;

function ProblemLexiconSearch(SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): TStrings ;
var
  View: String;
begin
  if Extend then
    View := 'CLF'
  else
    View := 'PLS';
  CallV('ORQQPL4 LEX',[SearchFor, VIEW, ADate, True]);
  Result := RPCBrokerV.Results ;
end ;

function OldProblemLexiconSearch(SearchFor: string; Matches: integer; ADate: TFMDateTime = 0): TStrings ;
//kt documentation.  returns list of: <IEN757.01>^<.01Name>^<ICD Code>^<ICD IEN (in 80)>^<Coding System name>
const
  VIEW = '';
begin
   CallV('ORQQPL PROBLEM LEX SEARCH',[SearchFor, Matches, VIEW, ADate]);
   Result := RPCBrokerV.Results ;
end ;

function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
begin
  CallV('ORQQPL PROBLEM NTRT BULLETIN', [term, ProviderID, PatientID, comment]);
  result := RPCBrokerV.Results[0];
end ;

function ProblemList(const PatientDFN: string; Status:string; ADate: TFMDateTime): TStrings ;  //*DFN*
begin
   CallV('ORQQPL PROBLEM LIST',[PatientDFN, Status, ADate]);
   Result := RPCBrokerV.Results ;
end ;

function ProviderFilterList(ProvList: TStringList): TStrings ;
begin
   CallV('ORQQPL PROV FILTER LIST',[ProvList]);
   Result := RPCBrokerV.Results ;
end ;

function ProviderList(Flag:string; Number:integer; From,Part: string): TStrings ;
begin
   CallV('ORQQPL PROVIDER LIST',[Flag,Number,From,Part]);
   Result := RPCBrokerV.Results ;
end ;

function ProblemReplace(ProblemIFN: string): TStrings ;
begin
   CallV('ORQQPL REPLACE',[ProblemIFN]);
   Result := RPCBrokerV.Results ;
end ;

function ServiceFilterList(LocList: TStringList): TStrings ;
begin
   CallV('ORQQPL SERV FILTER LIST',[LocList]);
   MixedCaseList(RPCBrokerV.Results) ;
   Result := RPCBrokerV.Results;
end ;

function ServiceSearch(const StartFrom: string; Direction: Integer; All: boolean = FALSE): TStrings;
begin
   CallV('ORQQPL SRVC SRCH',[StartFrom, Direction, BoolChar[All]]);
   MixedCaseList(RPCBrokerV.Results) ;
   Result := RPCBrokerV.Results ;
end ;

function ProblemUpdate(AltProbFile: TStringList): TStrings ;
begin
   CallV('ORQQPL UPDATE',[AltProbFile]);
   Result := RPCBrokerV.Results ;
end ;

function ProblemVerify(ProblemIFN: string): TStrings ;
begin
   CallV('ORQQPL VERIFY',[ProblemIFN]);
   Result := RPCBrokerV.Results ;
end ;

function UserProblemCategories(Provider: int64; Location: integer): TStrings ;
begin
   CallV('ORQQPL USER PROB CATS',[Provider, Location]);
   Result := RPCBrokerV.Results ;
end ;

function UserProblemList(CategoryIEN: string): TStrings ;
begin
   CallV('ORQQPL USER PROB LIST',[CategoryIEN]);
   Result := RPCBrokerV.Results ;
end ;

function GetProblemComments(ProblemIFN: string): TStrings;
begin
   CallV('ORQQPL PROB COMMENTS',[ProblemIFN]);
   Result := RPCBrokerV.Results ;
end;

procedure SaveViewPreferences(ViewPref: string);
begin
  CallV('ORQQPL SAVEVIEW',[ViewPref]);
end;

function CheckForDuplicateProblem(TermIEN, TermText: string): string;
begin
  CallV('ORQQPL CHECK DUP',[Patient.DFN, TermIEN, TermText]);
  Result := RPCBrokerV.Results[0];
end;

end.
