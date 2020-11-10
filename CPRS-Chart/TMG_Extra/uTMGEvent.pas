unit uTMGEvent;
(*
 Copyright 10/29/2020 Kevin S. Toppenberg, MD
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
  ORNet, rCore, Classes,uCore,sysutils,ORFn,Dialogs,Controls,
  uTMGOptions;

procedure SaveEvent(Data:string;Event:integer);
procedure CheckForOpenEvent(Data:string;Event:integer);

implementation


//var                                 //  RV 05/11/04

const
  EVENT_TIMER_ON  =  1;
  EVENT_TIMER_OFF =  2;

procedure SaveEvent(Data:string;Event:integer);
var RPCResults : TStringList;
    EventData:string;
begin
   RPCResults := TStringList.Create;
   EventData := 'SAVE^'+inttostr(User.DUZ)+'^'+Patient.DFN+'^'+inttostr(Event)+'^'+DateTimeToFMDTStr(Now)+'^'+Data;
   tCallV(RPCResults,'TMG EVENT CHANNEL',[EventData]);
   //messagedlg(RPCResults.text+'-'+inttostr(Event),mtinformation,[mbOk],0);
   RPCResults.free;
end;

procedure CheckForOpenEvent(Data:string;Event:integer);
var RPCResults : TStringList;
    EventData:string;
    DateTime : TDateTime;
begin
   RPCResults := TStringList.Create;
   EventData := 'CHKOPEN^'+inttostr(User.DUZ)+'^'+Patient.DFN+'^'+inttostr(Event)+'^'+DateTimeToFMDTStr(Now)+'^'+Data;
   tCallV(RPCResults,'TMG EVENT CHANNEL',[EventData]);
   if piece(RPCResults.Text,'^',1)='-1' then begin
      if messagedlg(RPCResults.text+#13#10+#13#10+'Would you like to set an close time for this timer?',mtinformation,[mbYes,mbNo],0)=mrYes then begin
         //messagedlg('Here I will ask to set the time');
         DateTime := strToDateTime(InputBox('Please enter the time','Enter the time for the last event to stop',DateTimeToStr(now)));
         EventData := 'SAVE^'+inttostr(User.DUZ)+'^'+Patient.DFN+'^2^'+DateTimeToFMDTStr(DateTime)+'^'+Data;
         tCallV(RPCResults,'TMG EVENT CHANNEL',[EventData]);
      end;
   end;
   RPCResults.free;
end;

end.

