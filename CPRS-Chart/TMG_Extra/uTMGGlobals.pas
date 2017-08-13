unit uTMGGlobals;

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


  //Forked from GUI Config 12/20/13


interface
  uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, StrUtils,
    ORNet, ORFn, ComCtrls, Grids, ORCtrls, ExtCtrls, Buttons,
    uTMGTypes, SortStringGrid;


var
  ActivePopupEditForm : TVariantPopupEdit;
  TMG_Create_Dynamic_Dialog : boolean;
  TMG_Create_Dynamic_Dialog_XML_Filename : String;
  TMG_Auto_Press_Edit_Button_In_Detail_Dialog : boolean;

  DataForGrid : TStringList;   // Owns contained TGridInfo objects
  AdvancedDemographicsTemplate: TStringList;
 { RemDefGridList : TList;
  SettingsGridList : TList;
  PatientsGridList : TList;
  UsersGridList : TList;
  AnyFileGridList : TList;
  DlgsGridList : TList;          }
  CachedHelp : TStringList;
  CachedHelpIdx : TStringList;
  CachedWPField : TStringList;
  VisibleGridIdx : integer;

{  CurrentUsersData : TStringList;
  CurrentSettingsData : TStringList;
  CurrentPatientsData : TStringList; }
  CurrentAnyFileData : TStringList;
{  CurrentRemDlgFileData : TStringList;
  CurrentRemDefFileData : TStringList;

  SettingsFiles : TStringList;    }

  //forward declarations
  procedure FreeAndDeleteDataForGridListItem(i : integer);
  procedure ClearDataForGridList;

implementation

  procedure FreeAndDeleteDataForGridListItem(i : integer);
  var s : string;
      AGridInfo : TGridInfo;
      ACompleteGridInfo : TCompleteGridInfo; //kt 5/15/13
  begin
    if (i < 0) or (i >= DataForGrid.Count) then exit;
    AGridInfo := TGridInfo(DataForGrid.Objects[i]);
    //kt 5/15/13 -- DataForGrid now owns objects
    if AGridInfo is TCompleteGridInfo then begin         //kt 5/15/13
      ACompleteGridInfo := TCompleteGridInfo(AGridInfo); //kt 5/15/13
      FreeAndNil(ACompleteGridInfo);                     //kt 5/15/13
    end else begin
      FreeAndNil(AGridInfo);                             //kt 5/15/13
    end;
    DataForGrid.Delete(i);
  end;

  procedure ClearDataForGridList;
  var i : integer;
  begin
    for i := DataForGrid.Count-1 downto 0 do begin
      FreeAndDeleteDataForGridListItem(i);
    end;
  end;

//----------------------------------------------

initialization
  TMG_Auto_Press_Edit_Button_In_Detail_Dialog := false;

  DataForGrid := TStringList.Create;  //will own GridInfo objects.
{  RemDefGridList := TList.Create;
  SettingsGridList := TList.Create;
  PatientsGridList := TList.Create;
  UsersGridList := TList.Create;
  AnyFileGridList := TList.Create;
  DlgsGridList := TList.Create;   }
  CachedWPField := TStringList.Create;
  CachedHelp := TStringList.Create;
  CachedHelpIdx := TStringList.Create;
  AdvancedDemographicsTemplate := TStringList.Create;
{

  SettingsFiles := TStringList.Create;
  CurrentUsersData := TStringList.create;
  CurrentSettingsData := TStringList.Create;
  CurrentPatientsData := TStringList.Create; }
  CurrentAnyFileData := TStringList.Create;
{  CurrentRemDlgFileData := TStringList.Create;
  CurrentRemDefFileData := TStringList.Create;}



finalization
  ClearDataForGridList;
  DataForGrid.Free;
  CachedWPField.Free;
  CachedHelp.Free;
  CachedHelpIdx.Free;
  AdvancedDemographicsTemplate.Free;
{  RemDefGridList.Free;
  SettingsGridList.Free;
  PatientsGridList.Free;
  UsersGridList.Free;
  AnyFileGridList.Free;
  DlgsGridList.Free;



  CurrentUsersData.Free;
  CurrentSettingsData.Free;
  CurrentPatientsData.Free;}
  CurrentAnyFileData.Free;
{  CurrentRemDlgFileData.Free;
  CurrentRemDefFileData.Free;

  SettingsFiles.Free;}


end.
