unit uTMGMods;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils,
  ORCtrls, ORFn, ORNet, Trpcb, uFlowsheet,
  uTypesACM, uUtility, uHTMLTools, TMGHTML2;

  procedure GenerateIntakeNote        (AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
  procedure GenerateInterimNote       (AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
  procedure GenerateDCNote            (AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
  procedure GenerateMissedApptNote    (AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
  procedure GenerateNoteForPatientNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
  procedure GenerateNote              (AppState : TAppState; AFlowsheet : TOneFlowsheet; TemplateIEN : string; HTMLObj: THtmlObj);

implementation

uses
  rRPCsACM, uParseBlocks;

//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------

procedure GetIENTemplate(AppState: TAppState; TemplateIEN: string; SL : TStringList);  forward;
procedure ResolveDataFields(AppState: TAppState; AFlowsheet : TOneFlowsheet; var Str : string);                    forward;
function  DataValue(AppState : TAppState; AFlowsheet : TOneFlowsheet; Field : string) : string;                    forward;
function  GetHelpText(AppState : TAppState; AFlowsheet : TOneFlowsheet): string;                                                       forward;

//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------

function DataValue(AppState : TAppState; AFlowsheet : TOneFlowsheet; Field : string) : string;
begin
  //If not found return input value.
  Result := Field;
  Field := UpperCase(Field);
  with AppState do begin
    if Field      = '%PRIMARYINDICATION%'       then Result := Patient.Indication_Text
    else if Field = '%PRIMARYINDICATIONCODE%'   then Result := Patient.Indication_ICDCode
    else if Field = '%SECONDARYINDICATION%'     then Result := Patient.RiskFactorsSL.Text
    else if Field = '%INCLUDESECONDARYINNOTE%'  then Result := BOOL_0or1[AppState.IncludeRisksInNote]

    else if Field = '%INRGOAL%'                 then Result := AFlowsheet.CurrentINRGoal
    else if Field = '%SITENAME%'                then Result := Parameters.SiteName
    else if Field = '%TREATMENTDURATION%'       then Result := Patient.ExpectedTreatmentDuration
    else if Field = '%DOSINGEDITED%'            then Result := BOOL_0or1[AFlowsheet.DosingEdited]
    else if Field = '%HILOORNORMAL%'            then Result := AFlowsheet.HiLoOrNormalNarrative

    else if Field = '%SUNTABS1%'                then Result := AFlowsheet.NumTabs1ForDay[daySun]
    else if Field = '%MONTABS1%'                then Result := AFlowsheet.NumTabs1ForDay[dayMon]
    else if Field = '%TUETABS1%'                then Result := AFlowsheet.NumTabs1ForDay[dayTue]
    else if Field = '%WEDTABS1%'                then Result := AFlowsheet.NumTabs1ForDay[dayWed]
    else if Field = '%THURTABS1%'               then Result := AFlowsheet.NumTabs1ForDay[dayThur]
    else if Field = '%FRITABS1%'                then Result := AFlowsheet.NumTabs1ForDay[dayFri]
    else if Field = '%SATTABS1%'                then Result := AFlowsheet.NumTabs1ForDay[daySat]

    else if Field = '%SUNTABS2%'                then Result := AFlowsheet.NumTabs2ForDay[daySun]
    else if Field = '%MONTABS2%'                then Result := AFlowsheet.NumTabs2ForDay[dayMon]
    else if Field = '%TUETABS2%'                then Result := AFlowsheet.NumTabs2ForDay[dayTue]
    else if Field = '%WEDTABS2%'                then Result := AFlowsheet.NumTabs2ForDay[dayWed]
    else if Field = '%THURTABS2%'               then Result := AFlowsheet.NumTabs2ForDay[dayThur]
    else if Field = '%FRITABS2%'                then Result := AFlowsheet.NumTabs2ForDay[dayFri]
    else if Field = '%SATTABS2%'                then Result := AFlowsheet.NumTabs2ForDay[daySat]

    else if Field = '%SUNMGS%'                  then Result := AFlowsheet.MgForDay[daySun]
    else if Field = '%MONMGS%'                  then Result := AFlowsheet.MgForDay[dayMon]
    else if Field = '%TUEMGS%'                  then Result := AFlowsheet.MgForDay[dayTue]
    else if Field = '%WEDMGS%'                  then Result := AFlowsheet.MgForDay[dayWed]
    else if Field = '%THURMGS%'                 then Result := AFlowsheet.MgForDay[dayThur]
    else if Field = '%FRIMGS%'                  then Result := AFlowsheet.MgForDay[dayFri]
    else if Field = '%SATMGS%'                  then Result := AFlowsheet.MgForDay[daySat]

    else if Field = '%DOSEINSTRSUN%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[daySun]
    else if Field = '%DOSEINSTRMON%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[dayMon]
    else if Field = '%DOSEINSTRTUE%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[dayTue]
    else if Field = '%DOSEINSTRWED%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[dayWed]
    else if Field = '%DOSEINSTRTHUR%'           then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[dayThur]
    else if Field = '%DOSEINSTRFRI%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[dayFri]
    else if Field = '%DOSEINSTRSAT%'            then Result := AFlowsheet.HumanReadableRegimenCombinedForDay[daySat]

    else if Field = '%TOTALMGS%'                then Result := AFlowsheet.TotalWeeklyDose
    else if Field = '%CURRENTINR%'              then Result := AFlowsheet.INR
    else if Field = '%ANEMIAVALUE%'             then Result := AFlowsheet.HctOrHgbValue
    //else if Field = '%PATIENTINSTRUCTION%'      then Result := AFlowsheet.PatientInstruction

    else if Field = '%USING2TABS%'              then Result := BOOL_0or1[AFlowsheet.UsingTwoPills]
    else if Field = '%TABSTRENGTH%'             then Result := AFlowsheet.PillStrength1 //TabStrength
    else if Field = '%TAB2STRENGTH%'            then Result := AFlowsheet.PillStrength2 //Tab2Strength
    else if Field = '%WARFARINSTARTDATE%'       then Result := Patient.StartDate

    else if Field = '%DOSEHOLDNUMOFDAYS%'       then Result := AFlowsheet.DoseHoldNumOfDays  //NOTICE -- Changed.  Was %DOCSHOLDNUMOFDAYS%
    else if Field = '%DOSETAKENUMMGTODAY%'      then Result := AFlowsheet.DoseTakeNumMgToday  //NOTICE -- CHANGED. Was %DOCSTAKENUMTABSTODAY%
    else if Field = '%DOCSPTMOVEDAWAY%'         then Result := BOOL_0or1[AFlowsheet.DocsPtMoved]
    else if Field = '%DOCSPTTRANSFERTO%'        then Result := AFlowsheet.DocsPtTransferTo
    else if Field = '%DOCSPTVIOLATEAGREEMENT%'  then Result := BOOL_0or1[Patient.ViolatedAgreement]
    else if Field = '%DOCSCOMMENTS%'            then Result := AFlowsheet.PatientInstructions.Text

    else if Field = '%PATNOTICE%'               then Result := AFlowsheet.PatientNotice   //added 6/11/18
    else if Field = '%PATCOMMENTS%'             then Result := AFlowsheet.Comments.Text        //added 6/11/18

    else if Field = '%NOSHOWDATE%'              then Result := IfThen(AppointmentNoShowDate<>0, DateToStr(AppointmentNoShowDate), '')
    else if Field = '%NEXTAPPT%'                then Result := IfThen(Patient.NextScheduledINRCheckDate<>0, DateToStr(Patient.NextScheduledINRCheckDate), '(none)')
    else if Field = '%NEXTAPPTTIME%'            then Result := IfThen(Patient.NextScheduledINRCheckTime<>0, TMGTimeToStr(Patient.NextScheduledINRCheckTime), '')
    else if Field = '%TIMENARRTOAPPT%'          then Result := LengthOfTimeNarrToDate(Patient.NextScheduledINRCheckDate)
    else if Field = '%DAYOFWEEKOFAPPT%'         then Result := LongDayNames[DayOfWeek(Patient.NextScheduledINRCheckDate)]

    else if Field = '%HELP%'                    then Result := GetHelpText(AppState,AFlowsheet);
  end;
  Result := StringReplace(Result, CRLF, '<BR>', [rfReplaceAll]);
end;



procedure ResolveDataFields(AppState: TAppState; AFlowsheet : TOneFlowsheet; var Str : string);
var P1,P2 : integer;
    StrA,StrB,StrC : string;
    FldValue : string;
begin
  P1 := 1;
  while P1 > 0 do begin
    P1 := PosEx('%', Str, P1);  //look for opening %
    if P1 = 0 then break;
    P2 := PosEx('%', Str, P1+1); //look for closing %
    if P2 = 0 then break;
    StrA := MidStr(Str, 1, P1-1);
    StrB := MidStr(Str, P1, P2-P1+1);
    StrC := MidStr(Str, P2+1, Length(Str));
    if (Pos(' ', StrB) = 0) then begin  //Screen out widely spaced %'s by checking for spaces in 'field name'
      FldValue := DataValue(AppState, AFlowsheet, StrB); //Try to convert into data value
      if FldValue <> StrB then begin
        Str := StrA + FldValue + StrC;
        P1 :=  Length(StrA) + Length(FldValue) + 1;
      end else begin
        P1 := P2+1;
      end;
    end else begin
      P1 := P1+1;
    end;
  end;
end;


procedure GetIENTemplate(AppState: TAppState; TemplateIEN: string; SL : TStringList);
begin GetTemplateText(TemplateIEN, AppState.Patient.DFN, '', SL); end;

procedure GenerateNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; TemplateIEN : string; HTMLObj: THtmlObj);
//NOTE: ScreenToDataRec(AppData.DosingData) <-- should be called upstream of this so data is current
var Text : string;
begin
  GetIENTemplate(AppState, TemplateIEN, AppState.NoteInfo.NoteSL);
  Text := AppState.NoteInfo.NoteSL.Text;
  ResolveDataFields(AppState, AFlowsheet, Text);
  Text := StringReplace(Text, #$D#$A,'', [rfReplaceAll]);
  ParseIfBlocks(Text);
  AppState.NoteInfo.NoteSL.Text := Text;
  SLToHTML(AppState.NoteInfo.NoteSL, HTMLObj, true);    //put into HTMLObj.  true --> erase prior
end;

procedure GenerateIntakeNote(AppState :TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
begin
  GenerateNote(AppState, AFlowsheet, AppState.Parameters.IENIntakeNoteTemplate, HTMLObj);
end;

procedure GenerateInterimNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
begin
  GenerateNote(AppState, AFlowsheet, AppState.Parameters.IENInterimNoteTemplate, HTMLObj);
end;

procedure GenerateDCNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
begin
  GenerateNote(AppState, AFlowsheet, AppState.Parameters.IENDCNoteTemplate, HTMLObj);
end;

procedure GenerateMissedApptNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
begin
  GenerateNote(AppState, AFlowsheet, AppState.Parameters.IENMissedApptNoteTemplate, HTMLObj);
end;

procedure GenerateNoteForPatientNote(AppState : TAppState; AFlowsheet : TOneFlowsheet; HTMLObj: THtmlObj);
begin
  GenerateNote(AppState, AFlowsheet, AppState.Parameters.IENNoteForPatientNoteTemplate, HTMLObj);
end;

function  GetHelpText(AppState : TAppState; AFlowsheet : TOneFlowsheet): string;
begin
  Result :=
  '<table style="border: 1px solid black;text-align:right;width=75%">'+
    '<tr class="TMGTableHeader"><th>Code</th><th>Example Value</th></tr>'+
    '<tr><td>&#37;PRIMARYINDICATION&#37;</td>'+      '<td>%PRIMARYINDICATION%</td></tr>'+
    '<tr><td>&#37;PRIMARYINDICATIONCODE&#37;</td>'+  '<td>%PRIMARYINDICATIONCODE%</td></tr>'+
    '<tr><td>&#37;SECONDARYINDICATION&#37</td>'+     '<td>%SECONDARYINDICATION%</td></tr>'+
    '<tr><td>&#37;INRGOAL&#37;</td>'+                '<td>%INRGOAL%</td></tr>'+
    '<tr><td>&#37;SITENAME&#37;</td>'+               '<td>%SITENAME%</td></tr>'+
    '<tr><td>&#37;TREATMENTDURATION&#37;</td>'+      '<td>%TREATMENTDURATION%</td></tr>'+
    '<tr><td>&#37;DOSINGEDITED&#37;</td>'+           '<td>%DOSINGEDITED%</td></tr>'+
    '<tr><td>&#37;HILOORNORMAL&#37;</td>'+           '<td>%HILOORNORMAL%</td></tr>'+
    '<tr><td>&#37;SUNTABS1&#37;</td>'+               '<td>%SUNTABS1%</td></tr>'+
    '<tr><td>&#37;MONTABS1&#37;</td>'+               '<td>%MONTABS1%</td></tr>'+
    '<tr><td>&#37;TUETABS1&#37;</td>'+               '<td>%TUETABS1%</td></tr>'+
    '<tr><td>&#37;WEDTABS1&#37;</td>'+               '<td>%WEDTABS1%</td></tr>'+
    '<tr><td>&#37;THURTABS1&#37;</td>'+              '<td>%THURTABS1%</td></tr>'+
    '<tr><td>&#37;FRITABS1&#37;</td>'+               '<td>%FRITABS1%</td></tr>'+
    '<tr><td>&#37;SATTABS1&#37;</td>'+               '<td>%SATTABS1%</td></tr>'+
    '<tr><td>&#37;SUNTABS2&#37;</td>'+               '<td>%SUNTABS2%</td></tr>'+
    '<tr><td>&#37;MONTABS2&#37;</td>'+               '<td>%MONTABS2%</td></tr>'+
    '<tr><td>&#37;TUETABS2&#37;</td>'+               '<td>%TUETABS2%</td></tr>'+
    '<tr><td>&#37;WEDTABS2&#37;</td>'+               '<td>%WEDTABS2%</td></tr>'+
    '<tr><td>&#37;THURTABS2&#37;</td>'+              '<td>%THURTABS2%</td></tr>'+
    '<tr><td>&#37;FRITABS2&#37;</td>'+               '<td>%FRITABS2%</td></tr>'+
    '<tr><td>&#37;SATTABS2&#37;</td>'+               '<td>%SATTABS2%</td></tr>'+
    '<tr><td>&#37;SUNMGS&#37;</td>'+                 '<td>%SUNMGS%</td></tr>'+
    '<tr><td>&#37;MONMGS&#37;</td>'+                 '<td>%MONMGS%</td></tr>'+
    '<tr><td>&#37;TUEMGS&#37;</td>'+                 '<td>%TUEMGS%</td></tr>'+
    '<tr><td>&#37;WEDMGS&#37;</td>'+                 '<td>%WEDMGS%</td></tr>'+
    '<tr><td>&#37;THURMGS&#37;</td>'+                '<td>%THURMGS%</td></tr>'+
    '<tr><td>&#37;FRIMGS&#37;</td>'+                 '<td>%FRIMGS%</td></tr>'+
    '<tr><td>&#37;SATMGS&#37;</td>'+                 '<td>%SATMGS%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRSUN&#37;</td>'+           '<td>%DOSEINSTRSUN%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRMON&#37;</td>'+           '<td>%DOSEINSTRMON%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRTUE&#37;</td>'+           '<td>%DOSEINSTRTUE%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRWED&#37;</td>'+           '<td>%DOSEINSTRWED%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRTHUR&#37;</td>'+          '<td>%DOSEINSTRTHUR%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRFRI&#37;</td>'+           '<td>%DOSEINSTRFRI%</td></tr>'+
    '<tr><td>&#37;DOSEINSTRSAT&#37;</td>'+           '<td>%DOSEINSTRSAT%</td></tr>'+
    '<tr><td>&#37;TOTALMGS&#37;</td>'+               '<td>%TOTALMGS%</td></tr>'+
    '<tr><td>&#37;CURRENTINR&#37;</td>'+             '<td>%CURRENTINR%</td></tr>'+
    '<tr><td>&#37;ANEMIAVALUE&#37;</td>'+            '<td>%ANEMIAVALUE%</td></tr>'+
    '<tr><td>&#37;USING2TABS&#37;</td>'+             '<td>%USING2TABS%</td></tr>'+
    '<tr><td>&#37;TABSTRENGTH&#37;</td>'+            '<td>%TABSTRENGTH%</td></tr>'+
    '<tr><td>&#37;TAB2STRENGTH&#37;</td>'+           '<td>%TAB2STRENGTH%</td></tr>'+
    '<tr><td>&#37;WARFARINSTARTDATE&#37;</td>'+      '<td>%WARFARINSTARTDATE%</td></tr>'+
    '<tr><td>&#37;DOSEHOLDNUMOFDAYS&#37;</td>'+      '<td>%DOSEHOLDNUMOFDAYS%</td></tr>'+
    '<tr><td>&#37;DOSETAKENUMMGTODAY&#37;</td>'+     '<td>%DOSETAKENUMMGTODAY%</td></tr>'+
    '<tr><td>&#37;DOCSPTMOVEDAWAY&#37;</td>'+        '<td>%DOCSPTMOVEDAWAY%</td></tr>'+
    '<tr><td>&#37;DOCSPTTRANSFERTO&#37;</td>'+       '<td>%DOCSPTTRANSFERTO%</td></tr>'+
    '<tr><td>&#37;DOCSPTVIOLATEAGREEMENT&#37;</td>'+ '<td>%DOCSPTVIOLATEAGREEMENT%</td></tr>'+
    '<tr><td>&#37;PATNOTICE&#37;</td>'+ '<td>%PATNOTICE%</td></tr>'+
    '<tr><td>&#37;PATCOMMENTS&#37;</td>'+ '<td>%PATCOMMENTS%</td></tr>'+
    '<tr><td>&#37;DOCSCOMMENTS&#37;</td>'+           '<td>%DOCSCOMMENTS%</td></tr>'+
    '<tr><td>&#37;NOSHOWDATE&#37;</td>'+             '<td>%NOSHOWDATE%</td></tr>'+
    '<tr><td>&#37;NEXTAPPT&#37;</td>'+               '<td>%NEXTAPPT%</td></tr>'+
    '<tr><td>&#37;NEXTAPPTTIME&#37;</td>'+           '<td>%NEXTAPPTTIME%</td></tr>'+
    '<tr><td>&#37;TIMENARRTOAPPT&#37;</td>'+         '<td>%TIMENARRTOAPPT%</td></tr>'+
    '<tr><td>&#37;DAYOFWEEKOFAPPT&#37;</td>'+        '<td>%DAYOFWEEKOFAPPT%</td></tr>'+
    '<tr><td>&#37;HELP&#37;</td>'+                   '<td>(this table)</td></tr>'+
  '</table>';
  //NOTE: Be sure not to include %HELP% here, or we will get endless recursive loop.
  ResolveDataFields(AppState, AFlowsheet, Result);
end;



end.
