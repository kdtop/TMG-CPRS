unit uTMGPtInfo;
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
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  BoolUC = (bucFalse, bucTrue, bucUnchanged);

  TPatientInfo = class(TObject)
  public
    DFN : string;
    LName: String;
    FName: String;
    MName: String;
    CombinedName: String;
    Prefix: String;
    Suffix: String;
    Degree: String;
    DOB: String;
    Sex: String;
    SSNum: String;
    EMail: String;
    MaxAliasIEN : LongInt;
    AliasInfo : TStringList;  //format: s=IEN#, Object is ^tAlias
    AddressLine1: String;
    AddressLine2: String;
    AddressLine3: String;
    City: String;
    State: String;
    Zip4: String;
    BadAddress: BoolUC;
    PhoneNumResidence: String;
    PhoneNumWork: String;
    PhoneNumCell: String;
    PhoneNumTemp: String;
    Skype: string;

    TempAddressLine1: String;
    TempAddressLine2: String;
    TempAddressLine3: String;
    TempCity: String;
    TempState: String;
    TempZip4: String;
    TempStartingDate : String;
    TempEndingDate : String;
    TempAddressActive: BoolUC;

    ConfidentalAddressLine1: String;
    ConfidentalAddressLine2: String;
    ConfidentalAddressLine3: String;
    ConfidentalCity: String;
    ConfidentalState: String;
    ConfidentalZip: String;
    ConfidentalStartingDate : String;
    ConfidentalEndingDate : String;
    ConfAddressActive : BoolUC;

    Modified : boolean;

    constructor Create;
    destructor Destroy; override;
    procedure ClearAliasInfo;
    procedure Clear;
    procedure Assign(Source : TPatientInfo);
    procedure RemoveUnchanged(OldInfo : TPatientInfo);
    procedure LoadFromServer(DFNToLoad : string);
    function PostChangedInfo : boolean;
  end;

  tAlias= class
    Name : string;
    SSN : string;
    procedure Assign(Source: tAlias);
  end;


implementation

uses IniFiles, Trpcb, ORNet, mfunstr;

procedure tAlias.Assign(Source : tAlias);
begin
  Name := Source.Name;
  SSN := Source.SSN;
end;

//=========================================================
//=========================================================
//=========================================================

constructor TPatientInfo.Create;
begin
  AliasInfo := TStringList.Create;
  
  Clear;
end;

destructor TPatientInfo.Destroy;
begin
  ClearAliasInfo;
  AliasInfo.Free;
  inherited Destroy;
End;

procedure TPatientInfo.ClearAliasInfo;
var i : integer;
    pAlias : tAlias;
begin
  for i := 0 to AliasInfo.Count-1 do begin
    pAlias := tAlias(AliasInfo.Objects[i]);
    pAlias.Free;
  end;
  AliasInfo.Clear;
  MaxAliasIEN := 0;
End;

procedure TPatientInfo.Clear;
begin
  LName:= '';
  FName:= '';
  MName:= '';
  CombinedName:= '';
  Prefix:= '';
  Suffix:= '';
  Degree:= '';
  DOB:= '';
  SSNum:= '';
  EMail:= '';
  ClearAliasInfo;  
  AddressLine1:= '';
  AddressLine2:= '';
  AddressLine3:= '';
  City:= '';
  State:= '';
  Zip4:= '';
  Skype:= '';
  TempAddressLine1:= '';
  TempAddressLine2:= '';
  TempAddressLine3:= '';
  TempCity:= '';
  TempState:= '';
  TempZip4:= '';
  TempStartingDate := '';
  TempEndingDate := '';
  ConfidentalAddressLine1:= '';
  ConfidentalAddressLine2:= '';
  ConfidentalAddressLine3:= '';
  ConfidentalCity:= '';
  ConfidentalState:= '';
  ConfidentalZip:= '';
  ConfidentalStartingDate := '';
  ConfidentalEndingDate := '';
  BadAddress:= bucFalse;
  TempAddressActive:= bucFalse;
  ConfAddressActive := bucFalse;
  Modified := false;
  
  PhoneNumResidence:= '';
  PhoneNumWork:= '';
  PhoneNumCell:= '';
  PhoneNumTemp:= '';
  Sex:= '';

end;


procedure TPatientInfo.Assign(Source : TPatientInfo);
var i : integer;
    pAlias : tAlias;
    OtherpAlias : tAlias;
begin
  DFN := Source.DFN;    //1-25-14  why was this not here?  elh
  LName:=Source.LName;
  FName:=Source.FName;
  MName:=Source.MName;
  CombinedName:=Source.CombinedName;
  Prefix:=Source.Prefix;
  Suffix:=Source.Suffix;
  Degree:=Source.Degree;
  DOB:=Source.DOB;
  SSNum:=Source.SSNum;
  EMail:=Source.EMail;
  Skype:=Source.Skype;

  ClearAliasInfo;
  //Copy pointed to tAlias entries, don't simply copy references
  for i := 0 to Source.AliasInfo.Count-1 do begin
    AliasInfo.Add(Source.AliasInfo.Strings[i]);
    OtherpAlias := tAlias(Source.AliasInfo.Objects[i]);
    if OtherpAlias<>nil then begin
      pAlias := tAlias.Create;
      pAlias.Name := OtherpAlias.Name;
      pAlias.SSN := OtherpAlias.SSN;
      AliasInfo.Objects[i]:=pAlias;    
    end;
  end;
  AddressLine1:=Source.AddressLine1;
  AddressLine2:=Source.AddressLine2;
  AddressLine3:=Source.AddressLine3;
  City:=Source.City;
  State:=Source.State;
  Zip4:=Source.Zip4;
  TempAddressLine1:=Source.TempAddressLine1;
  TempAddressLine2:=Source.TempAddressLine2;
  TempAddressLine3:=Source.TempAddressLine3;
  TempCity:=Source.TempCity;
  TempState:=Source.TempState;
  TempZip4:=Source.TempZip4;
  TempStartingDate :=Source.TempStartingDate ;
  TempEndingDate :=Source.TempEndingDate ;
  ConfidentalAddressLine1:=Source.ConfidentalAddressLine1;
  ConfidentalAddressLine2:=Source.ConfidentalAddressLine2;
  ConfidentalAddressLine3:=Source.ConfidentalAddressLine3;
  ConfidentalCity:=Source.ConfidentalCity;
  ConfidentalState:=Source.ConfidentalState;
  ConfidentalZip:=Source.ConfidentalZip;
  ConfidentalStartingDate :=Source.ConfidentalStartingDate ;
  ConfidentalEndingDate :=Source.ConfidentalEndingDate ;
  BadAddress:= Source.BadAddress;
  TempAddressActive:= Source.TempAddressActive;
  ConfAddressActive := Source.ConfAddressActive;
  PhoneNumResidence:=Source.PhoneNumResidence;
  PhoneNumWork:=Source.PhoneNumWork;
  PhoneNumCell:=Source.PhoneNumCell;
  PhoneNumTemp:=Source.PhoneNumTemp;
  Sex:=Source.Sex;
  EMail := Source.EMail;
end;


procedure TPatientInfo.RemoveUnchanged(OldInfo : TPatientInfo);
//Will remove entries that are unchanged from OldInfo
//ALSO, will change AliasInfo entries:
//     Other code adds "IEN" numbers that don't have any corresponding
//     true IEN on the server.  This will convert these to +1,+2 etc.
//     And, if there is an alias entry in the OldInfo that is not
//     in this info, then a matching @ entry for that IEN will be generated.

  procedure CompStrs(var newS, oldS : string);
  begin
    if newS = oldS then begin
      newS := '';  //no change, 
    end else begin
      if (newS = '') and (oldS <> '') then newS := '@' //delete symbol
    end;
  end;

  procedure CompBoolUC(var newBN, oldBN : BoolUC);
  begin
    if newBN=oldBN then begin
      newBN := bucUnchanged;  //Mark unchanged
    end;  
  end;

  const
    BOOL_STR : array[false..true] of string =('TRUE','FALSE');
    NO_CHANGE = 1;
    NEW_RECORD = 2;
    DELETED_RECORD = 3;
    CHANGED_RECORD = 4;

  function CompAliasRec(curAlias,oldAlias : tAlias) : integer;
  //Returns: NO_CHANGE = 1; NEW_RECORD = 2; DELETED_RECORD = 3; CHANGED_RECORD = 4;
  begin
    Result := NO_CHANGE;
    if (curAlias <> nil) and (oldAlias <> nil) then begin
      if curAlias.Name = '' then begin
        if oldAlias.Name <> '' then Result := DELETED_RECORD;
      end else if curAlias.Name <> oldAlias.Name then begin
        Result := CHANGED_RECORD;
      end;
      if Result = NO_CHANGE then begin
        if curAlias.SSN <> oldAlias.SSN then Result := CHANGED_RECORD;
      end;
    end;  
  end;
  
  function CompAlias(IEN : string; pAlias : tAlias; OldInfo : TPatientInfo) : integer;
  //format: s=IEN#, Object is ^tAlias  
  //Returns: NO_CHANGE = 1; NEW_RECORD = 2; DELETED_RECORD = 3; CHANGED_RECORD = 4;
  var i : integer;
      oldPAlias : tAlias;
  begin
    Result := NEW_RECORD;
    for i := 0 to OldInfo.AliasInfo.Count-1 do begin
      if OldInfo.AliasInfo.Strings[i] = IEN then begin
        oldPAlias := tAlias(OldInfo.AliasInfo.Objects[i]);
        Result :=  CompAliasRec(pAlias,oldPAlias);
        break;
      end;
    end;
  end;

  var i,j,AddCt : integer;  
      pAlias, tempPAlias : tAlias;
 
begin
  {if OldInfo = This Info, then remove entries}
  CompStrs(LName, OldInfo.LName);
  CompStrs(FName, OldInfo.FName);
  CompStrs(MName, OldInfo.MName);
  CompStrs(CombinedName, OldInfo.CombinedName);
  CompStrs(Prefix, OldInfo.Prefix);
  CompStrs(Suffix, OldInfo.Suffix);
  CompStrs(Degree, OldInfo.Degree);
  CompStrs(DOB, OldInfo.DOB);
  CompStrs(SSNum, OldInfo.SSNum);
  CompStrs(EMail, OldInfo.EMail);
  CompStrs(Skype, OldInfo.Skype);
  
  CompStrs(AddressLine1, OldInfo.AddressLine1);
  CompStrs(AddressLine2, OldInfo.AddressLine2);
  CompStrs(AddressLine3, OldInfo.AddressLine3);
  CompStrs(City, OldInfo.City);
  CompStrs(State, OldInfo.State);
  CompStrs(Zip4, OldInfo.Zip4);
  CompStrs(TempAddressLine1, OldInfo.TempAddressLine1);
  CompStrs(TempAddressLine2, OldInfo.TempAddressLine2);
  CompStrs(TempAddressLine3, OldInfo.TempAddressLine3);
  CompStrs(TempCity, OldInfo.TempCity);
  CompStrs(TempState, OldInfo.TempState);
  CompStrs(TempZip4, OldInfo.TempZip4);
  CompStrs(TempStartingDate , OldInfo.TempStartingDate );
  CompStrs(TempEndingDate , OldInfo.TempEndingDate );
  CompStrs(ConfidentalAddressLine1, OldInfo.ConfidentalAddressLine1);
  CompStrs(ConfidentalAddressLine2, OldInfo.ConfidentalAddressLine2);
  CompStrs(ConfidentalAddressLine3, OldInfo.ConfidentalAddressLine3);
  CompStrs(ConfidentalCity, OldInfo.ConfidentalCity);
  CompStrs(ConfidentalState, OldInfo.ConfidentalState);
  CompStrs(ConfidentalZip, OldInfo.ConfidentalZip);
  CompStrs(ConfidentalStartingDate , OldInfo.ConfidentalStartingDate );
  CompStrs(ConfidentalEndingDate , OldInfo.ConfidentalEndingDate );

  CompBoolUC(BadAddress, OldInfo.BadAddress);
  CompBoolUC(TempAddressActive, OldInfo.TempAddressActive);
  CompBoolUC(ConfAddressActive, OldInfo.ConfAddressActive);
  
  CompStrs(PhoneNumResidence, OldInfo.PhoneNumResidence);
  CompStrs(PhoneNumWork, OldInfo.PhoneNumWork);
  CompStrs(PhoneNumCell, OldInfo.PhoneNumCell);
  CompStrs(PhoneNumTemp, OldInfo.PhoneNumTemp);
  CompStrs(Sex, OldInfo.Sex);

  //Compare Aliases
  //format: s=IEN#, Object is ^tAlias  

  //first, see which entries in OldInfo are deleted in CurInfo.
  for i := 0 to OldInfo.AliasInfo.Count-1 do begin
    pAlias := tAlias(OldInfo.AliasInfo.Objects[i]);
    if CompAlias(OldInfo.AliasInfo.Strings[i], pAlias, self) = NEW_RECORD then begin
      //here we have an entry in OldInfo, not in CurInfo, so must represent a Delete
      //This needs to be posted to server with old IEN and @ symbol
      tempPAlias := tAlias.Create;
      tempPAlias.Name := '@';
      AliasInfo.AddObject(OldInfo.AliasInfo.Strings[i],tempPAlias);
    end;
  end;  
  
  AddCt := 0;
  //First, see which entries in New PatientInfo are new, or unchanged.
  for i := 0 to AliasInfo.Count-1 do begin
    pAlias := tAlias(AliasInfo.Objects[i]);
    if (pAlias=nil) then continue;
    if pAlias.Name= '@' then continue;   //skip those marked as deleted from OldInfo
    case CompAlias(AliasInfo.Strings[i], pAlias, OldInfo) of
      NO_CHANGE      : begin  //delete unchanged data (no need to repost to server)
                         pAlias.Destroy;
                         AliasInfo.Strings[i] :='<@>';  //mark for deletion below
                       end;
      NEW_RECORD :     begin  //mark as +1, +2 etc IEN
                         AddCt := AddCt + 1;
                         AliasInfo.Strings[i] := '+' + IntToStr(AddCt);
                       end;
     CHANGED_RECORD :  begin end;  // do nothing, leave changes in place
    end; {case}  
  end;

  for i := AliasInfo.Count-1 downto 0 do begin
    if AliasInfo.Strings[i] = '<@>' then AliasInfo.Delete(i);
  end;


end;

//=========================================================
//=========================================================
//=========================================================

procedure TPatientInfo.LoadFromServer(DFNToLoad : string);
var  tempINI : TMemINIFile;  //I do this to make dealing with hash table read easier
     i,index : integer;
     IEN, Key,Value,s : string;
     pAlias : tAlias;

begin
  Self.Clear;
  Self.DFN := DFNToLoad;

  tempINI := TMemINIFile.Create('xxx.ini');

  RPCBrokerV.remoteprocedure := 'TMG GET PATIENT DEMOGRAPHICS';
  RPCBrokerV.param[0].value := DFN;
  RPCBrokerV.param[0].ptype := literal;
  //RPCBrokerV.Call;
  CallBroker;

  //Store results in a hash table for easier random access
  //Don't store Alias info in hash table, put directly into AliasInfo stringlist
  for i := 0 to RPCBrokerV.Results.Count-1 do begin
    s := RPCBrokerV.Results.Strings[i];
    if Pos('ALIAS',s)=0 then begin
      Key := piece(s,'=',1);
      Value := piece(s,'=',2);
      tempINI.WriteString('DATA',Key,Value);
    end else begin
      IEN := piece(s,' ',2);
      if StrToInt(IEN)>MaxAliasIEN then MaxAliasIEN := StrToInt(IEN);
      index := AliasInfo.IndexOf(IEN);
      if index <0 then begin
        pAlias := tAlias.Create;  //AliasInfo will own these.
        AliasInfo.AddObject(IEN,pAlias);
      end else begin
        pAlias := tAlias(AliasInfo.Objects[index]);
      end;
      if Pos('NAME=',s)>0 then begin
        pAlias.Name := piece(s,'=',2);
      end else if Pos('SSN=',s)>0 then begin
        pAlias.SSN := piece(s,'=',2);
      end;
    end;
  end;
  LName:=tempINI.ReadString('DATA','LNAME','');
  FName:=tempINI.ReadString('DATA','FNAME','');
  MName:=tempINI.ReadString('DATA','MNAME','');
  CombinedName:=tempINI.ReadString('DATA','COMBINED_NAME','');
  Prefix:=tempINI.ReadString('DATA','PREFIX','');
  Suffix:=tempINI.ReadString('DATA','SUFFIX','');
  Degree:=tempINI.ReadString('DATA','DEGREE','');
  DOB:= tempINI.ReadString('DATA','DOB','');
  Sex:= tempINI.ReadString('DATA','SEX','');
  SSNum:= tempINI.ReadString('DATA','SS_NUM','');
  EMail:= tempINI.ReadString('DATA','EMAIL','');
  Skype:= tempINI.ReadString('DATA','SKYPE','');
  AddressLine1:= tempINI.ReadString('DATA','ADDRESS_LINE_1','');
  AddressLine2:= tempINI.ReadString('DATA','ADDRESS_LINE_2','');
  AddressLine3:= tempINI.ReadString('DATA','ADDRESS_LINE_3','');
  City:= tempINI.ReadString('DATA','CITY','');
  State:= tempINI.ReadString('DATA','STATE','');
  Zip4:= tempINI.ReadString('DATA','ZIP4','');
  BadAddress:= BoolUC(tempINI.ReadString('DATA','BAD_ADDRESS','')<>'');
  TempAddressLine1:= tempINI.ReadString('DATA','TEMP_ADDRESS_LINE_1','');
  TempAddressLine2:= tempINI.ReadString('DATA','TEMP_ADDRESS_LINE_2','');
  TempAddressLine3:= tempINI.ReadString('DATA','TEMP_ADDRESS_LINE_3','');
  TempCity:= tempINI.ReadString('DATA','TEMP_CITY','');
  TempState:=tempINI.ReadString('DATA','TEMP_STATE','');
  TempZip4:= tempINI.ReadString('DATA','TEMP_ZIP4','');
  TempStartingDate :=tempINI.ReadString('DATA','TEMP_STARTING_DATE','');
  TempEndingDate := tempINI.ReadString('DATA','TEMP_ENDING_DATE','');
  TempAddressActive:= BoolUC(tempINI.ReadString('DATA','TEMP_ADDRESS_ACTIVE','')='YES');
  ConfidentalAddressLine1:= tempINI.ReadString('DATA','CONF_ADDRESS_LINE_1','');
  ConfidentalAddressLine2:= tempINI.ReadString('DATA','CONF_ADDRESS_LINE_2','');
  ConfidentalAddressLine3:= tempINI.ReadString('DATA','CONF_ADDRESS_LINE_3','');
  ConfidentalCity:= tempINI.ReadString('DATA','CONF_CITY','');
  ConfidentalState:= tempINI.ReadString('DATA','CONF_STATE','');
  ConfidentalZip:= tempINI.ReadString('DATA','CONF_ZIP','');
  ConfidentalStartingDate := tempINI.ReadString('DATA','CONG_STARTING_DATE','');
  ConfidentalEndingDate := tempINI.ReadString('DATA','CONF_ENDING_DATE','');
  ConfAddressActive:= BoolUC(tempINI.ReadString('DATA','CONF_ADDRESS_ACTIVE','')='YES');
  PhoneNumResidence:= tempINI.ReadString('DATA','PHONE_RESIDENCE','');
  PhoneNumWork:= tempINI.ReadString('DATA','PHONE_WORK','');
  PhoneNumCell:= tempINI.ReadString('DATA','PHONE_CELL','');
  PhoneNumTemp:= tempINI.ReadString('DATA','PHONE_TEMP','');

  tempINI.Free;  //I don't write out, so should never end up on disk.
end;



function TPatientInfo.PostChangedInfo : boolean;
//Returns TRUE if changes posted, otherwise false.

  procedure CheckBUCPost(Title : string; Value : BoolUC);
  begin
    if Value <> bucUnchanged then begin
      if Value = bucTrue then RPCBrokerV.Param[1].Mult['"'+Title+'"'] := 'YES';
      if Value = bucFalse then RPCBrokerV.Param[1].Mult['"'+Title+'"'] := 'NO';
    end;
  end;

  procedure CheckPost(Title, Value : string);
  begin
    if Value <> '' then RPCBrokerV.Param[1].Mult['"'+Title+'"'] := Value;
  end;

  var i : integer;
      pAlias : tAlias;
begin
  Result := False;
  RPCBrokerV.remoteprocedure := 'TMG SET PATIENT DEMOGRAPHICS';
  RPCBrokerV.param[0].value := DFN;
  RPCBrokerV.param[0].ptype := literal;

  RPCBrokerV.Param[1].PType := list;
  CheckPost('COMBINED_NAME',CombinedName);
  //CheckPost('LNAME', LName);    //Don't send because data is in COMBINED NAME
  //CheckPost('FNAME',FName);
  //CheckPost('MNAME',MName);
  //CheckPost('PREFIX',Prefix);
  //CheckPost('SUFFIX',Suffix);
  //CheckPost('DEGREE',Degree);
  CheckPost('DOB',DOB);
  CheckPost('SEX',Sex);
  CheckPost('SS_NUM',SSNum);
  CheckPost('EMAIL',EMail);
  CheckPost('SKYPE',Skype);
  CheckPost('ADDRESS_LINE_1',AddressLine1);
  CheckPost('ADDRESS_LINE_2',AddressLine2);
  CheckPost('ADDRESS_LINE_3',AddressLine3);
  CheckPost('CITY',City);
  CheckPost('STATE',State);
  CheckPost('ZIP4',Zip4);

  CheckPost('TEMP_ADDRESS_LINE_1',TempAddressLine1);
  CheckPost('TEMP_ADDRESS_LINE_2',TempAddressLine2);
  CheckPost('TEMP_ADDRESS_LINE_3',TempAddressLine3);
  CheckPost('TEMP_CITY',TempCity);
  CheckPost('TEMP_STATE',TempState);
  CheckPost('TEMP_ZIP4',TempZip4);
  CheckPost('TEMP_STARTING_DATE',TempStartingDate );
  CheckPost('TEMP_ENDING_DATE',TempEndingDate );
  CheckPost('CONF_ADDRESS_LINE_1',ConfidentalAddressLine1);
  CheckPost('CONF_ADDRESS_LINE_2',ConfidentalAddressLine2);
  CheckPost('CONF_ADDRESS_LINE_3',ConfidentalAddressLine3);
  CheckPost('CONF_CITY',ConfidentalCity);
  CheckPost('CONF_STATE',ConfidentalState);
  CheckPost('CONF_ZIP',ConfidentalZip);
  CheckPost('CONG_STARTING_DATE',ConfidentalStartingDate );
  CheckPost('CONF_ENDING_DATE',ConfidentalEndingDate );
  CheckPost('PHONE_RESIDENCE',PhoneNumResidence);
  CheckPost('PHONE_WORK',PhoneNumWork);
  CheckPost('PHONE_CELL',PhoneNumCell);
  CheckPost('PHONE_TEMP',PhoneNumTemp);

  case BadAddress of
    bucTrue:  RPCBrokerV.Param[1].Mult['"BAD_ADDRESS"'] := 'UNDELIVERABLE';
    bucFalse: RPCBrokerV.Param[1].Mult['"BAD_ADDRESS"'] := '@';
  end; {case}
  CheckBUCPost('TEMP_ADDRESS_ACTIVE', TempAddressActive);
  CheckBUCPost('CONF_ADDRESS_ACTIVE', ConfAddressActive);

  for i := 0 to AliasInfo.Count-1 do begin
    pAlias := tAlias(AliasInfo.Objects[i]);
    if (pAlias=nil) then continue;
    RPCBrokerV.Param[1].Mult['"ALIAS ' + AliasInfo.Strings[i] +  ' NAME"'] := pAlias.Name;
    if pAlias.Name <> '@' then begin
      RPCBrokerV.Param[1].Mult['"ALIAS ' + AliasInfo.Strings[i] +  ' SSN"'] := pAlias.SSN;
    end;
  end;

  CallBroker;
  if RPCBrokerV.Results.Strings[0]<>'1' then begin
    MessageDlg(RPCBrokerV.Results.Strings[0],mtError,[mbOK],0);
  end else begin
    Result := true;
  end;
end;




end.

