unit rRxHistory;
//kt //codex 11/2/26 -- Added entire unit

interface

uses
  System.Classes, uCore, ORFn, ORNet;

function ListRxHistory(Dest: TStrings; SDT: TFMDateTime = 0; EDT: TFMDateTime = 9999999): string;
function ListRxHistorySummary(Dest: TStrings; UseParsedText: Boolean = False; SDT: TFMDateTime = 0; EDT: TFMDateTime = 9999999): string;
function ListRxHistoryNotes(Dest: TStrings; const MedicationIEN: string; SDT: TFMDateTime = 0; EDT: TFMDateTime = 9999999): string;

implementation

function RxHistoryCommand(Dest: TStrings; const Params: string; SDT, EDT: TFMDateTime): string;
var
  Index: Integer;
begin
  Result := '-1^A destination for medication history was not supplied.';
  if not Assigned(Dest) then begin
    Exit;
  end;
  Dest.Clear;
  Result := sCallV('TMG RPC RXHX CMD', [Patient.DFN, Params, SDT, EDT]);
  if Result = '' then begin
    Result := '-1^The medication history RPC returned no status.';
    Exit;
  end;
  if Result = '1^OK' then begin
    for Index := 1 to RPCBrokerV.Results.Count - 1 do begin
      Dest.Add(RPCBrokerV.Results[Index]);
    end;
  end;
end;

function ListRxHistory(Dest: TStrings; SDT, EDT: TFMDateTime): string;
// TMGRESULT(#)="0^<TIU document IEN>^<document FMDT>" -- table metadata.
//     NOTE: Each 0 line applies to subsequent medication lines until the next 0 line.
// TMGRESULT(#)="1^<medication line>" -- 1 line entry from an incoming table.  (repeat for each line of the med list)
// TMGRESULT(#)="2^<medication line>" -- 1 line entry from final table.        (repeat for each line of the med list)
// Each Medication line syntax-> original text^parsed text^medication IEN^name^strength^units.
begin
  Result := RxHistoryCommand(Dest, 'LIST ALL', SDT, EDT);
end;

function ListRxHistorySummary(Dest: TStrings; UseParsedText: Boolean; SDT, EDT: TFMDateTime): string;
//Get grouped info, by drug name, summarized over potentially many notes.
//If UserParseText=TRUE, then a parse version of text is returned.  If FALSE, then raw text as found in note returned.
//NOTE: observations of identical text, not proof of continuous use.

 // TMGRESULT(#)="0^<medication name>" <-- heading; blank for unmatched lines.
 // TMGRESULT(#)="1^<medication text>^<first FMDT>^<last FMDT>".
 // TMGRESULT(#)="2^<medication IEN>^<name>^<strength>^<units>".
 // Type 2 lines apply to the preceding type 1 line and may be repeated.
 // Incoming and final observations are combined; dates are first and last

var
  Params: string;
begin
  Params := 'LIST SUMMARY';
  if UseParsedText then begin
    Params := Params + ':PARSED';
  end;
  Result := RxHistoryCommand(Dest, Params, SDT, EDT);
end;

function ListRxHistoryNotes(Dest: TStrings; const MedicationIEN: string; SDT, EDT: TFMDateTime): string;
//Return a list of TIU notes that contain the specified medication.

  //  TMGRESULT(#)="<TIU document IEN>^<document FMDT>".
  //  Each matching note is returned once, even if multiple table lines match.

begin
  Result := RxHistoryCommand(Dest, 'LIST TIU:' + MedicationIEN, SDT, EDT);
end;

end.
