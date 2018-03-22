unit uTMGDiffRecord;
//Added by K. Toppenberg 8/18/17

(*
  The purpose of this is to track sequential changes of a StringList (SL).
  The end goal is to take repeated snapshots of a HTML DOM from a single-page
  application, and monitor for changes.

  Output will be a series of HTML pages where the changes between the old
  and the new state are highlighted.  These will be saved into output directory.

  When ProcessSnapshot is called, the current state (the last SL passed) is compared
  to the new SL.  If there is no difference, then no output is saved.

*)

interface

uses
  Windows, Messages, SysUtils, StrUtils, ExtCtrls, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Diff_NP, uHTMLTools, TMGHtml2;

type
  TDiffRecorder = class(TObject)
  private
    FOutputDir : string;
    FWebBrowser : THtmlObj;
    Diff : TDiff;
    LocalTimer : TTimer;
    procedure GetDiffHTML(LastHTMLSL, SL2, HTMLChangesSL, ModOldSL, ModNewSL, TagDeltaSL : TStringList);
    procedure ProcessSnapshot(InputSL : TStringList; SaveToFile : boolean = false); overload;
    procedure ProcessSnapshot(InputStr : string; SaveToFile : boolean = false); overload;
    procedure Summarize(SL : TStringList; Kind: TChangeKind);
  public
    CurrentSL : TStringList;
    HTMLSL : TStringList;
    ModOldSL : TStringList;
    ModNewSL : TStringList;
    TagDeltaSL : TStringList;
    procedure MakeSnapshot(SaveToFile : boolean = false);
    constructor Create(WebBrowser : THtmlObj; OutputDir : string);
    destructor Destroy;
  end;

implementation
  type
      TTagPair = record
        Open, Close : string;
      end;

  const
      CRLF = #13#10;
      TOO_BIG = '---- TOO BIG ----';
      TAGS : ARRAY[ckNone .. ckModify] of TTagPair = (
        {ckNone}   (Open : ''; Close : ''),
        {ckAdd}    (Open : '<TMGAddSpan style="background-color: yellow">'; Close : '</TMGAddSpan>'),
        {ckDelete} (Open : '<TMGDelSpan style="background-color: red; text-decoration: line-through;">'; Close : '</TMGDelSpan>'),
        {ckModify} (Open : ''; Close : '')
      );
      PSEUDOTAGS : ARRAY[ckNone .. ckModify] of TTagPair = (
        {ckNone}   (Open : ''; Close : ''),
        {ckAdd}    (Open : '{TMGAdd}'; Close : '{-TMGAdd}'),
        {ckDelete} (Open : '{TMGDel}'; Close : '{-TMGDel}'),
        {ckModify} (Open : ''; Close : '')
      );

  constructor TDiffRecorder.Create(WebBrowser : THtmlObj; OutputDir : string);
  begin
    inherited Create;
    FWebBrowser := WebBrowser;
    HTMLSL := TStringList.Create;
    ModOldSL := TStringList.Create;
    ModNewSL := TStringList.Create;
    TagDeltaSL := TStringList.Create;
    LocalTimer := TTimer.Create(Application);
    if RightStr(OutputDir,1) <> '\' then OutputDir := OutputDir + '\';
    FOutputDir := OutputDir;
    Diff := TDiff.Create(self);
    CurrentSL := TStringList.Create;
  end;

  destructor TDiffRecorder.Destroy;
  begin
    Diff.Free;
    CurrentSL.Free;
    LocalTimer.Free;
    HTMLSL.Free;
    ModOldSL.Free;
    ModNewSL.Free;
    TagDeltaSL.Free;
    inherited;
  end;

  procedure TDiffRecorder.MakeSnapshot(SaveToFile : boolean = false);
  var SL : TStringList;
  begin
    SL := TStringList.Create;
    SL.Text := FWebBrowser.GetFullHTMLText;
    WrapLongHTMLLines(SL, 80,'');
    ProcessSnapshot(SL, SaveToFile);
    SL.Free;
  end;


  procedure TDiffRecorder.ProcessSnapshot(InputStr : string; SaveToFile : boolean = false);
  var InputSL : TStringList;
  begin
    InputSL := TStringList.Create;
    InputSL.Text := InputStr;
    ProcessSnapshot(InputSL);
    InputSL.Free;
  end;


  procedure TDiffRecorder.Summarize(SL : TStringList; Kind: TChangeKind);
  type TSearchMode = (smLookingForStart, smLookingForEnd);
  var SavedIdx : integer; //From this index to end of SL should not be deleted.
      i, j : integer;
      Mode : TSearchMode;
      OpenTag : string;
  const
      NUM_CONTEXT_LINES = 1;
  begin
    SavedIdx := SL.Count - 2;  //save last two lines, which are HTML wrapper
    i := SavedIdx - 1;
    Mode := smLookingForEnd;
    while i > 0 do begin
      if Mode = smLookingForStart then begin
        if Pos(TAGS[Kind].Open, SL.strings[i]) > 0 then begin
          SavedIdx := i - NUM_CONTEXT_LINES;
          i := SavedIdx;
          Mode := smLookingForEnd;
        end;
      end;
      if Mode = smLookingForEnd then begin
        if (Pos(TAGS[Kind].close, SL.strings[i]) > 0) or (i=2) then begin
          for j := (SavedIdx-1) downto (i+ NUM_CONTEXT_LINES + 1) do begin
            SL.Delete(j);
          end;
          SL.Insert(j+1,'<B>==== snip =====</B><BR>');
          Mode := smLookingForStart;
          inc(i); //so that dec below will leave us on same line.  Close and Open often on same line.
        end;
      end;
      dec(i);
    end;
  end;


  procedure TDiffRecorder.ProcessSnapshot(InputSL : TStringList; SaveToFile : boolean = false);
  //NOTE: It is expected that InputSL will be be raw HTML (not encoded / protected)
  var TimeStr, FName : string;

    procedure FixAndWrapWithHTML(SL : TStringList);
    begin
      HTMLEncode(SL);
      SL.Insert(0, '<!DOCTYPE html>');
      SL.Insert(1, '<html>');
      SL.Insert(2, '<body>');
      SL.Add('</body>');
      SL.Add('</html>');

      SL.Text := StringReplace(SL.Text, PSEUDOTAGS[ckAdd].Open, TAGS[ckAdd].Open, [rfReplaceAll]);
      SL.Text := StringReplace(SL.Text, PSEUDOTAGS[ckAdd].Close, TAGS[ckAdd].Close, [rfReplaceAll]);
      SL.Text := StringReplace(SL.Text, PSEUDOTAGS[ckDelete].Open, TAGS[ckDelete].Open, [rfReplaceAll]);
      SL.Text := StringReplace(SL.Text, PSEUDOTAGS[ckDelete].Close, TAGS[ckDelete].Close, [rfReplaceAll]);
    end;

  begin
    GetDiffHTML(CurrentSL, InputSL, HTMLSL, ModOldSL, ModNewSL, TagDeltaSL);
    if HTMLSL.Text = '' then exit;
    CurrentSL.Assign(InputSL);
    if (TagDeltaSL.Count > 0) and (TagDeltaSL[0] = TOO_BIG) then exit; //When page reloads, this is massive and bogs program down.
    FixAndWrapWithHTML(HTMLSL);
    if SaveToFile then begin
      TimeStr := FormatDateTime('yyyy"-"mm"-"dd" at "hh"."nn"."ss"."zzz', Now);
      HTMLSL.SaveToFile(FOutputDir + 'Snapshot on' + TimeStr + '.html');

      //ModOldSL.SaveToFile(FOutputDir + 'Del view on' + TimeStr + '.html');
      //Summarize(ModOldSL, ckDelete);
      //ModOldSL.SaveToFile(FOutputDir + 'Del Summary on' + TimeStr + '.html');

      //ModNewSL.SaveToFile(FOutputDir + 'Add view on' + TimeStr + '.html');
      //Summarize(ModNewSL, ckAdd);
      //ModNewSL.SaveToFile(FOutputDir + 'Add Summary on' + TimeStr + '.html');

      TagDeltaSL.SaveToFile(FOutputDir + 'Tag Delta List on '+ TimeStr + '.txt');
    end;
  end;

  procedure TDiffRecorder.GetDiffHTML(LastHTMLSL, SL2,
                                      HTMLChangesSL, ModOldSL, ModNewSL,
                                      TagDeltaSL : TStringList);
   var i, j, k : integer;
      lastKind : TChangeKind;
      Char1, Char2 : string;
      S1, S2 : string;
      LineFullStr, LineOldStr, LineNewStr : string;
      InTag : boolean;
      TooBig : boolean;
      OldTag, NewTag : string;
  begin
    HTMLChangesSL.Clear;
    ModOldSL.Clear;
    ModNewSL.Clear;
    TagDeltaSL.Clear;
    if LastHTMLSL.Text = SL2.Text then exit;
    S1 := LastHTMLSL.Text;
    S2 := SL2.Text;
    LineFullStr := ''; LineOldStr := ''; LineNewStr := '';
    InTag := false;
    TooBig := false;
    OldTag := '';
    NewTag := '';

    Diff.Execute(pchar(S1), pchar(S2), length(S1), length(S2));

    //now, display the diffs ...
    lastKind := ckNone;
    i := 0;
    while (i < Diff.count) and not TooBig do begin
      with Diff.Compares[i] do begin
        if kind <> lastKind then begin
          LineFullStr := LineFullStr + PSEUDOTAGS[lastKind].close;
          LineOldStr  := LineOldStr  + PSEUDOTAGS[lastKind].close;
          LineNewStr  := LineNewStr  + PSEUDOTAGS[lastKind].close;
          if kind <> ckModify then begin
            LineFullStr := LineFullStr + PSEUDOTAGS[kind].open;
            if kind = ckAdd then begin
              LineNewStr := LineNewStr + PSEUDOTAGS[kind].open;
            end;
            if kind = ckDelete then begin
              LineOldStr := LineOldStr + PSEUDOTAGS[kind].open;
            end;
          end;
        end;
        Char1 := chr1; Char2 := chr2;
        if chr1 = #13 then begin
          if LineFullStr <> '' then HTMLChangesSL.Add(LineFullStr +'<BR>');
          if LineOldStr <> ''  then ModOldSL.Add(LineOldStr + '<BR>');
          if LineNewStr <> ''  then ModNewSL.Add(LineNewStr + '<BR>');
          LineFullStr := ''; LineOldStr := ''; LineNewStr := ''; Char1 :='';
        end else if chr1 = #10 then begin
          Char1 := ''; //ignore LF char
        end;
        if chr2 = #13 then begin
          if chr1 <> chr2 then begin
            if LineFullStr <> '' then HTMLChangesSL.Add(LineFullStr +'<BR>');
            if LineOldStr <> ''  then ModOldSL.Add(LineOldStr + '<BR>');
            if LineNewStr <> ''  then ModNewSL.Add(LineNewStr + '<BR>');
          end;
          LineFullStr := ''; LineOldStr := ''; LineNewStr := ''; Char2 :='';
        end else if chr2 = #10 then begin
          Char2 := ''; //ignore LF char
        end;

        if (Char1 = '<') and (Char2 = '<') then begin
          InTag := True;
          OldTag := ''; NewTag := '';
        end;
        case kind of  //kind means how the 2nd string is changed, compared to 1st string.
          ckNone  : begin
                      LineFullStr := LineFullStr + Char1;
                      LineOldStr := LineOldStr + Char1;
                      LineNewStr := LineNewStr + Char1;
                      if InTag then begin
                        OldTag := OldTag + Char1;
                        NewTag := NewTag + Char2;
                      end;
                    end;
          ckAdd   : begin
                      LineFullStr := LineFullStr + Char2;
                      LineNewStr := LineNewStr + Char1;
                      if InTag then begin
                        NewTag := NewTag + Char2;
                      end;
                    end;
          ckDelete: begin
                      LineFullStr := LineFullStr + Char1;
                      LineOldStr := LineOldStr + Char1;
                      if InTag then begin
                        OldTag := OldTag + Char1;
                      end;
                    end;
          ckModify: begin  //output all OLD values, then ouput all NEW values
                      // Output all OLD values -------------------------
                      LineFullStr := LineFullStr + PSEUDOTAGS[ckDelete].open;
                      LineOldStr := LineOldStr + PSEUDOTAGS[ckDelete].open;
                      j := i;
                      while j < Diff.count do begin
                        Char1 := Diff.Compares[j].chr1;
                        if Char1 = #13 then begin
                          HTMLChangesSL.Add(LineFullStr +'<BR>');
                          ModOldSL.Add(LineOldStr + '<BR>');
                          LineFullStr := ''; LineOldStr := '';
                          Char1 :='';
                        end else if Char1 = #10 then begin
                          Char1 := ''; //ignore LF char
                        end;
                        LineFullStr := LineFullStr + Char1;
                        LineOldStr := LineOldStr + Char1;
                        if InTag then begin
                          OldTag := OldTag + Char1;
                        end;
                        inc(j);
                        if Diff.Compares[j].Kind <> ckModify then break;
                      end;
                      LineFullStr := LineFullStr + PSEUDOTAGS[ckDelete].close;
                      LineOldStr := LineOldStr + PSEUDOTAGS[ckDelete].close;
                      // Next, output all NEW values -----------------
                      LineFullStr := LineFullStr + PSEUDOTAGS[ckAdd].open;
                      LineNewStr := LineNewStr + PSEUDOTAGS[ckAdd].open;
                      while i < Diff.count do begin
                        Char2 := Diff.Compares[i].chr2;
                        if Char2 = #13 then begin
                          HTMLChangesSL.Add(LineFullStr +'<BR>');
                          LineFullStr := ''; LineNewStr := '';
                          Char2 :='';
                        end else if Char2 = #10 then begin
                          Char2 := ''; //ignore LF char
                        end;
                        LineFullStr := LineFullStr + Char2;
                        LineNewStr := LineNewStr + Char2;
                        if InTag then begin
                          NewTag := NewTag + Char2;
                        end;
                        inc(i);
                        if Diff.Compares[i].Kind <> ckModify then break;
                      end;
                      LineFullStr := LineFullStr + PSEUDOTAGS[ckAdd].close;
                      LineNewStr := LineNewStr + PSEUDOTAGS[ckAdd].close;
                    end;
        end; //case
        if (Char1 = '>') and (Char2 = '>') then begin
          InTag := False;
          if OldTag <> NewTag then begin
            if not TooBig then begin
              TagDeltaSL.Add('OLD: ' + OldTag); OldTag := '';
              TagDeltaSL.Add('NEW: ' + NewTag); NewTag := '';
              if TagDeltaSL.Count >= 15*2 then begin
                TooBig := true;
                TagDeltaSL.Insert(0, TOO_BIG);
              end;
            end;
            OldTag := ''; NewTag := '';
          end;
        end;
        lastKind := Kind;
      end;  //with
      inc(i);
    end; //while
    if TooBig then begin
      HTMLChangesSL.Clear;
      ModOldSL.Clear;
      ModNewSL.Clear;
    end else begin
      if LineFullStr <> '' then HTMLChangesSL.Add(LineFullStr);
      if LineOldStr <> ''  then ModOldSL.Add(LineOldStr);
      if LineNewStr <> ''  then ModNewSL.Add(LineNewStr);
    end;

  end;


end.
