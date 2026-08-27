unit uGMV_FileEntry;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/13/05 2:40p $
*       Developer:    dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  File Entry
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/uGMV_FileEntry.pas $
*
* $History: uGMV_FileEntry.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:18p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 *
================================================================================
}

interface

uses
  SysUtils
  , Classes
  , Dialogs
  ;

type

  TGMV_FileReference = class(TObject)
  private
    FTypes: TStringList;
    FDDNumber: string;
    FFileName: string;
    function GetName(Index: integer): string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure LoadEntries(FileNumber: string);
    procedure LoadEntriesConverted(FileNumber: string);//AAN 01/22/2003 sorting problem
    procedure Display;
    function IndexOfIEN(IEN: string): integer;
    function NameOfIEN(IEN:String):String;
    property Name[Index: integer]: string read GetName;
  published
    property Entries: TStringList read FTypes;
  end;

  TGMV_VitalType = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_VitalQual = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_VitalCat = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_WardLocation = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_Teams = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_Clinics = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_NursingUnit = class(TGMV_FileReference)
  public
    constructor Create; override;
  end;

  TGMV_FileEntry = class(TObject)
  private
    FDDNumber: string;
    FCaption: string;
    FIEN: string;
    FCaptionConverted:String;// AAN - sorting problem 01/21/2003
    procedure SetCaption(const Value: string);
    procedure SetCaptionConverted(const Value: string);// AAN - sorting problem 01/22/2003
    procedure SetDDNumber(const Value: string);
    procedure SetIEN(const Value: string);
    function GetIENS: string;
  public
    constructor Create;
    constructor CreateFromRPC(Data: string);
    destructor Destroy; override;
    function FieldData(FieldNumber: string): string;
  published
    property DDNumber: string read FDDNumber write SetDDNumber;
    property IEN: string read FIEN write SetIEN;
    property Caption: string read FCaption write SetCaption;
    property CaptionConverted: string read FCaptionConverted write SetCaptionConverted; // AAN - sorting problem 01/21/2003
    property IENS: string read GetIENS;
  end;

var
  GMVTypes: TGMV_VitalType;
  GMVQuals: TGMV_VitalQual;
  GMVCats: TGMV_VitalCat;
  GMVWardLocations: TGMV_WardLocation;
  GMVTeams: TGMV_Teams;
  GMVClinics: TGMV_CLinics;
  GMVNursingUnits: TGMV_NursingUnit;


procedure InitVitalsIENS;

implementation

uses uGMV_Common
  , uGMV_Utils
  , uGMV_VitalTypes
  , uGMV_Engine
;


{ GMV_VitalType }

constructor TGMV_FileReference.Create;
begin
  FTypes := TStringList.Create;
end;

destructor TGMV_FileReference.Destroy;
begin
  FreeAndNil(FTypes);
  inherited;
end;

procedure TGMV_FileReference.LoadEntries(FileNumber: string);
var
  i: integer;
  fe: TGMV_FileEntry;
  RetList: TStrings;
  j : Integer;  //kt
begin
  FDDNumber := FileNumber;
  //messagedlg('In TMGV_FileReference.LoadEntries.  Calling getFileEntries('+FileNumber+')',mtInformation,[mbOK],0);  //kt
  RetList := getFileEntries(FDDNumber);  //get IEN<-->Labels via RPC call
  //for j := 0 to RetList.Count-1 do begin  //kt  for debugging only
  //  messagedlg('RetList['+IntToStr(j)+']='+RetList.Strings[j],mtInformation,[mbOK],0);  //kt
  //end;
  if RetList.Count > 0 then
    begin
      FFileName := Copy(RetList[0], Pos('^', RetList[0]), Length(RetList[0]));
      FTypes.Sorted := True; //AAN 08/08/2002
      for i := 1 to RetList.Count - 1 do
        begin
          fe := TGMV_FileEntry.CreateFromRPC(RetList[i]);
          FTypes.AddObject(fe.Caption, fe);
        end;
    end;
  RetList.Free;
end;

procedure TGMV_FileReference.LoadEntriesConverted(FileNumber: string);
var
  i: integer;
  fe: TGMV_FileEntry;
  s: String;
  RetList: TStrings;
begin
  FDDNumber := FileNumber;
  // pulling records in several steps to avoid timeouts
  s := '0';
  repeat
    s := FileNumber + '^'+ s;
//    RetList := TStringList.Create;
//    if CallRemoteProc(FBroker, RPC_MANAGER, ['GETLIST', s], nil,[], RetList) then
      RetList := getFileEntries(s);
      if RetList.Count > 0 then
        begin
          FFileName := Copy(RetList[0], Pos('^', RetList[0]), Length(RetList[0]));
          FTypes.Sorted := True; //AAN 08/08/2002
          for i := 1 to RetList.Count - 1 do
            begin
              fe := TGMV_FileEntry.CreateFromRPC(RetList[i]);
              FTypes.AddObject(fe.CaptionConverted, fe);
              s := fe.FIEN;
            end;
          if RetList.Count < 12 then
            s := '';
        end;
    RetList.Free;
  until s = '';
end;

function TGMV_FileReference.IndexOfIEN(IEN: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FTypes.Count - 1 do begin
    if TGMV_FileEntry(FTypes.Objects[i]).IEN = IEN then begin
      Result := i;
      Exit;
    end;
  end;
end;

function TGMV_FileReference.NameOfIEN(IEN:String):String;
begin
  try
    result := FTypes[IndexOfIEN(IEN)];
  except
    Result := '';
  end;
end;

procedure TGMV_FileReference.Display;
var
  x: string;
  i: integer;
begin
  x := Self.ClassName + ' display' + #13 +
    'FileName: ' + FFileName + #13 +
    'Data Dictionary: ' + FDDNumber;
  for i := 0 to FTypes.Count - 1 do
    x := x + #13 + 'IEN: ' + TGMV_FileEntry(FTypes.Objects[i]).IEN + #9 + FTypes[i];
  ShowMessage(x); {Debug tool!}
end;

function TGMV_FileReference.GetName(Index: integer): string;
var
  i: integer;
begin
  if Index = 0 then
    Result := ''
  else
    begin
      Result := '*No Such Entry*';
      for i := 0 to FTypes.Count - 1 do
        if integer(FTypes.Objects[i]) = Index then
          begin
            Result := FTypes[i];
            Exit;
          end;
    end;
end;

{ TGMV_VitalType }

constructor TGMV_VitalType.Create;
begin
  inherited Create;
  LoadEntries('120.51');
end;

{ TGMV_VitalQual }

constructor TGMV_VitalQual.Create;
begin
  inherited Create;
  LoadEntries('120.52');
end;

{ TGMV_VitalCat }

constructor TGMV_VitalCat.Create;
begin
  inherited Create;
  LoadEntries('120.53');
end;

{ TGMV_WardLocation }

constructor TGMV_WardLocation.Create;
begin
  inherited  Create;
  //LoadEntries('42');
end;

{ TGMV_Teams }

constructor TGMV_Teams.Create;
begin
  inherited  Create;
  //LoadEntries('100.21');
end;

{ TGMV_CLinics }

constructor TGMV_Clinics.Create;
begin
  inherited  Create;
  //LoadEntries('44');
end;

{ TGMV_NursingUnit }

constructor TGMV_NursingUnit.Create;
begin
  inherited  Create;
  //LoadEntries('211.4');
end;

{ TGMV_FileEntry }

constructor TGMV_FileEntry.Create;
begin
  inherited;
end;

constructor TGMV_FileEntry.CreateFromRPC(Data: string);
begin
  inherited Create;
  FDDNumber := Piece(Data, ';', 1);
  FIEN := Piece(Piece(Data, ';', 2), '^', 1);
  FCaption := Piece(Data, '^', 2);
  FCaptionConverted := ReplacePunctuation(FCaption)+' ('+FIEN+')'; //AAN 01/21/2003 - Sorting Problem
  FCaptionConverted := ReplacePunctuation(FCaption)                ; //AAN 05/21/2003 - hiding IENS
end;

destructor TGMV_FileEntry.Destroy;
begin
  inherited;
end;

procedure TGMV_FileEntry.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TGMV_FileEntry.SetCaptionConverted(const Value: string); // AAN - sorting problem 01/22/2003
begin
  FCaptionConverted := Value;
end;

procedure TGMV_FileEntry.SetDDNumber(const Value: string);
begin
  FDDNumber := Value;
end;

procedure TGMV_FileEntry.SetIEN(const Value: string);
begin
  FIEN := Value;
end;

function TGMV_FileEntry.GetIENS: string;
begin
  GetIENS := FIEN + ',';
end;

function TGMV_FileEntry.FieldData(FieldNumber: string): string;
begin
//  if CallRemoteProc(RPCBroker, RPC_MANAGER, ['GETDATA', FDDNumber + '^' + IENS + '^' + FieldNumber], nil,[],nil) then
//    Result := RPCBroker.Results[0]
//  else
//    Result := '';
  Result := getFileField(FDDNumber,FieldNumber,IENS);
end;

procedure InitVitalsIENS;
var
  SL : TStringList;
  i : integer; //kt
begin
  try
    SL := getVitalsIDList;
    //messagedlg('In InitVitalsIENS.uGMV_EFileEntry.  Count= '+ IntToStr(SL.Count),mtInformation,[mbOK],0);  //kt
    if SL.Count = 11 then begin  // the order of Vitals is fixed in the routine
      //for i := 0 to SL.Count-1 do begin     //kt for debugging
      //  messagedlg(IntToStr(i)+'/'+InttoStr(SL.Count)+': '+SL.Strings[i],mtInformation,[mbOK],0);  //kt
      //end;
      //kt make changes here...  However, I can't see that it is acutally used...
      GMVVitalTypeIEN[vtUnknown] := SL[0];
      GMVVitalTypeIEN[vtTemp] := SL[1];
      GMVVitalTypeIEN[vtPulse] := SL[2];
      GMVVitalTypeIEN[vtResp] := SL[3];
      GMVVitalTypeIEN[vtBP] := SL[4];
      GMVVitalTypeIEN[vtHeight] := SL[5];
      GMVVitalTypeIEN[vtWeight] := SL[6];
      GMVVitalTypeIEN[vtPain] := SL[7];
      GMVVitalTypeIEN[vtPO2] := SL[8];
      GMVVitalTypeIEN[vtCVP] := SL[9];
      GMVVitalTypeIEN[vtCircum] := SL[10];
    end;
    SL.Free;
  except
  end;
end;


end.
