unit uTMGOptions;
//kt Added entire unit.  2/10/10
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
  IniFiles, SysUtils, Forms, uCore, ORFn,  ORNet, Trpcb;

var
  USE_SERVER_INI : boolean;
  Initialized : boolean;

  Procedure WriteBool(const Key: String; Value: Boolean; AsDefault : boolean = false);
  Procedure WriteInteger(const Key: String; Value: Integer; AsDefault : boolean = false);
  Procedure WriteString(const Key: String; Value: String; AsDefault : boolean = false);
  Function ReadBool(const Key: String; Default: Boolean): Boolean;
  Function ReadInteger(const Key: String; Default: Integer): Integer;
  Function ReadString(const Key: String; Default: String): String;

implementation

uses
  Classes;

const
  DEFAULT_SECTION = 'DEFAULT';

var
  StrList : TStringList;
  OptionsIniFile : TIniFile;  //kt 8/09
  
  procedure TMGOptionsInitialize;
  begin
    OptionsIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));  //kt
    StrList := TStringList.Create;

    //if RPC exists, use in lieu of INI file
    RPCBrokerV.remoteprocedure := 'XWB IS RPC AVAILABLE';
    RPCBrokerV.Param[0].Value := 'TMG INIFILE GET';
    RPCBrokerV.Param[0].ptype := literal;
    RPCBrokerV.Param[1].Value := 'R';
    RPCBrokerV.Param[1].ptype := literal;
    //RPCResult := RPCBrokerV.StrCall;
    CallBroker;
    if RPCBrokerV.Results.Count >0 then begin
      USE_SERVER_INI := StrToBool(RPCBrokerV.Results.Strings[0]);  {returns 1 if available, 0 if not available}
    end else begin
      USE_SERVER_INI := false;
    end;
    Initialized := true;
  end;

  procedure WriteRPCStr(const Section, Key: String; Value: String);
  begin
    RPCBrokerV.remoteprocedure := 'TMG INIFILE SET';
    RPCBrokerV.Param[0].Value := Section;
    RPCBrokerV.Param[0].ptype := literal;
    RPCBrokerV.Param[1].Value := Key;
    RPCBrokerV.Param[1].ptype := literal;
    RPCBrokerV.Param[2].Value := Value;
    RPCBrokerV.Param[2].ptype := literal;
    //RPCBrokerV.Call;
    CallBroker;
  end;

  function ReadRPCStr(const Section, Key, Default: String) : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG INIFILE GET';
    RPCBrokerV.param[0].ptype := literal;
    RPCBrokerV.param[0].value := Section;
    RPCBrokerV.Param[1].ptype := literal;
    RPCBrokerV.param[1].value := Key;
    RPCBrokerV.Param[2].ptype := literal;
    RPCBrokerV.param[2].value := Default;
    //Result := Piece(RPCBrokerV.StrCall,'^',2);
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      Result := Piece(RPCBrokerV.Results.Strings[0],'^',2);
    end else begin
      Result := Default;
    end;
  end;


  Procedure WriteBool(const Key: String; Value: Boolean; AsDefault : boolean = false);
  begin
    if Initialized = False then TMGOptionsInitialize;
    if AsDefault then begin
      if USE_SERVER_INI then begin
        WriteRPCStr(DEFAULT_SECTION,Key,BoolToStr(Value));
      end else begin
        OptionsIniFile.WriteBool(DEFAULT_SECTION,Key,Value);
      end;
    end else begin
      if USE_SERVER_INI then begin
        WriteRPCStr(User.Name,Key,BoolToStr(Value));
      end else begin
        OptionsIniFile.ReadSection(DEFAULT_SECTION,StrList);
        if (StrList.IndexOf(Key)=-1) or (OptionsIniFile.ReadBool(DEFAULT_SECTION,Key,false)<>Value) then begin
          OptionsIniFile.WriteBool(User.Name,Key,Value);  //Only write user value if differs from default value
        end;
      end;
    end;
  end;

  Procedure WriteInteger(const Key: String; Value: Integer; AsDefault : boolean = false);
  begin
   if Initialized = False then TMGOptionsInitialize;
    if AsDefault then begin
      if USE_SERVER_INI then begin
        WriteRPCStr(DEFAULT_SECTION,Key,IntToStr(Value));
      end else begin
        OptionsIniFile.WriteInteger(DEFAULT_SECTION,Key,Value);
      end;
    end else begin
      if USE_SERVER_INI then begin
        WriteRPCStr(User.Name,Key,IntToStr(Value));
      end else begin
        OptionsIniFile.ReadSection(DEFAULT_SECTION,StrList);
        if (StrList.IndexOf(Key)=-1) or (OptionsIniFile.ReadInteger(DEFAULT_SECTION,Key,-999)<>Value) then begin
          OptionsIniFile.WriteInteger(User.Name,Key,Value);  //Only write user value if differs from default value
        end;
      end;
    end;
  end;

  Procedure WriteString(const Key: String; Value: String; AsDefault : boolean = false);
  begin
    if Initialized = False then TMGOptionsInitialize;
    if AsDefault then begin
      if USE_SERVER_INI then begin
        WriteRPCStr(DEFAULT_SECTION,Key,Value);
      end else begin
        OptionsIniFile.WriteString(DEFAULT_SECTION,Key,Value);
      end;
    end else begin
      if USE_SERVER_INI then begin
        WriteRPCStr(User.Name,Key,Value);
      end else begin
        OptionsIniFile.ReadSection(DEFAULT_SECTION,StrList);
        if (StrList.IndexOf(Key)=-1) or (OptionsIniFile.ReadString(DEFAULT_SECTION,Key,'xxx')<>Value) then begin
          OptionsIniFile.WriteString(User.Name,Key,Value);  //Only write user value if differs from default value
        end;
      end;
    end;
  end;

  Function ReadBool(const Key: String; Default: Boolean): Boolean;
  begin
    if Initialized = False then TMGOptionsInitialize;
    if USE_SERVER_INI then begin
      Result := StrToBool(ReadRPCStr(User.Name,Key,BoolToStr(Default)));
    end else begin
      OptionsIniFile.ReadSection(User.Name,StrList);
      if StrList.IndexOf(Key) > -1 then begin
        Result := OptionsIniFile.ReadBool(User.Name,Key,Default);
      end else begin
        Result := OptionsIniFile.ReadBool(DEFAULT_SECTION,Key,Default);
      end;
    end;
  end;

  Function ReadInteger(const Key: String; Default: Integer): Integer;
  begin
    if Initialized = False then TMGOptionsInitialize;
    if USE_SERVER_INI then begin
      Result := StrToInt(ReadRPCStr(User.Name,Key,IntToStr(Default)));
    end else begin
      OptionsIniFile.ReadSection(User.Name,StrList);
      if StrList.IndexOf(Key) > -1 then begin
        Result := OptionsIniFile.ReadInteger(User.Name,Key,Default);
      end else begin
        Result := OptionsIniFile.ReadInteger(DEFAULT_SECTION,Key,Default);
      end;
    end;
  end;

  Function ReadString(const Key: String; Default: String): String;
  begin
    if Initialized = False then TMGOptionsInitialize;
    if USE_SERVER_INI then begin
      Result := ReadRPCStr(User.Name,Key,Default);
    end else begin
      OptionsIniFile.ReadSection(User.Name,StrList);
      if StrList.IndexOf(Key) > -1 then begin
        Result := OptionsIniFile.ReadString(User.Name,Key,Default);
      end else begin
        Result := OptionsIniFile.ReadString(DEFAULT_SECTION,Key,Default);
      end;
    end;
  end;


initialization
  Initialized := false;


finalization
  OptionsIniFile.Free;  //kt 8/09
  StrList.Free;

end.

