unit uRpcLogEntry;

interface

uses
      Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TRpcb;

type
  TDisplayFormat = (dfFormatFullWithoutClientName,dfFormatFullWithClientName,
                        dfFormatForList);

  TMyString = class(TObject)
  private
    FString: String;
  public
    Constructor Create(Str: String);
    procedure Append(Str: String);
    function ToString: String;
  end;

  TRpcLogEntry = class(TObject)
  private
    mUniqueClientId: Integer;
    mClientName: String;
    mConnectionIndex: Integer;
    mContext: String;
    mUniqueId: Integer;      // unique rpc id
    mRpcName: String;
    mRpcParamsString: String;
    mRpcResults: String;
    mRpcEndDateTime: Double;
    mRpcDuration: Integer;
    mRpcParams: TParams;
  protected
    procedure SetParamsString(Value: String);
  public
    Constructor Create; overload;
    Constructor Create(uniqueClientId: Integer; clientName: String;
               connectionIndex: Integer; rpcUniqueId: Integer; rpcEndDateTime: Double;
               rpcDuration: Integer; context, rpcName, rpcParams, rpcResults: String); overload;
    property StrResults: String read mRpcResults write mRpcResults;
    property EndDateTime: double read mRpcEndDateTime write mRpcEndDateTime;
    property Duration: Integer read mRpcDuration write mRpcDuration;
    property Params: TParams read mRpcParams;
    property UniqueClientId: Integer read mUniqueClientId write mUniqueClientId;
    property ClientName: String read mClientName write mClientName;
    property ConnectionIndex: Integer read mConnectionIndex write mConnectionIndex;
    property UniqueId: Integer read mUniqueId write mUniqueId;
    property Context: String read mContext write mContext;
    property Name: String read mRpcName write mRpcName;
    property ParamsString: String read mRpcParamsString write SetParamsString;
    function CreateDisplayString(format: TDisplayFormat): String;
    function ToString: String;
    function CreateClipboardString: String;
    function CreateParamsDisplayString: String;
    function CreateResultsDisplayString: String;
  end;


const
  kHeaderStartTag: String    = '________________________RPC START____________________';
  kRpcTag: String = 'RPC>'#09#09#09;
  kRpcDebugIdTag: String = 'RPC DEBUG ID>'#09;
  kClientNameTag: String = 'CLIENT NAME>'#09#09;
  kClientDebugIdTag: String = 'CLIENT DEBUG ID>'#09;
  kContextTag: String = 'CONTEXT>'#09#09;
  kDurationTag: String = 'DURATION>'#09#09;
    // kTimeDateTag: String = 'END TIME>'#09#09;
  kParamsTag: String = '________________________PARAMS_______________________';
  kResultsTag: String = '________________________RESULTS______________________';
  kHeaderEndTag: String = '________________________RPC END______________________';

function PosNext(SubString: String; CurStart: Integer; S: String): Integer;

implementation

function PosNext(SubString: string; CurStart: Integer; S: String): Integer;
var
  Str1: String;
begin
  Str1 := Copy(S,CurStart,Length(S));
  Result := CurStart + Pos(SubString,Str1)-1;
end;

function TMyString.ToString: string;
begin
  Result := FString;
end;

procedure TMyString.Append(Str: string);
begin
  FString := FString + Str;
end;

constructor TMyString.Create(Str: string);
begin
  FString := Str;
end;


procedure TRpcLogEntry.SetParamsString(Value: string);
begin
  mRpcParamsString := value;
        // TODO:
        // now break the string into a string array and
        // shove it into the Params
        // Just rebuild the mParams
  if (mRpcParams <> nil) then
  begin
    mRpcParams.Free;
    mRpcParams := nil;
  end;

  mRpcParams := TParams.Create(Application);
//  mRpcParams.
end;

  /// <summary>
  /// Summary description for RpcLogEntry.
   /// </summary>
Constructor TRpcLogEntry.Create;
begin
  inherited;
end;

Constructor TRpcLogEntry.Create(uniqueClientId: Integer; clientName: String;
               connectionIndex: Integer; rpcUniqueId: Integer; rpcEndDateTime: Double;
               rpcDuration: Integer; context, rpcName, rpcParams, rpcResults: String);
begin
  mUniqueClientId  := uniqueClientId;
  mClientName    := clientName;
  if (context = '') then
    mContext := ''
  else
    mContext  := context;

  mConnectionIndex := connectionIndex;

  mUniqueId := rpcUniqueId;
  if (rpcName = '') then
    mrpcName := ''
  else
    mrpcName := rpcName;

  if(rpcParams = '') then
    mrpcParamsString := ''
  else
    mrpcParamsString := rpcParams;

  if(rpcResults = '') then
    mrpcResults := ''
  else
    mrpcResults   := rpcResults;

  mRpcEndDateTime   := rpcEndDateTime;
  mRpcDuration   := rpcDuration;
end;


function TRpcLogEntry.ToString: String;
begin
  Result := CreateDisplayString(dfFormatForList);
end;

    /// <summary>
    /// CreateDisplayString returns a string with the rpc params
    /// formated based on the DisplayFormat format 
    /// </summary>
    /// <param name:='format'></param>
    /// <returns></returns>
    ///
const
  kInitialStringBuilderSize: Integer = 1000;
  kNamePad: Integer = 31;
  krpcIdPad: Integer = 5;
  kcIdpad: Integer = 7;
  kDurationPad: Integer = 3;
  kLiteral: String = 'literal';
  kReference: String = 'reference';
  kList: String = 'list';
  kUndefined: String = 'undefined';


function TRpcLogEntry.CreateDisplayString(format: TDisplayFormat): String;
var
  ResultVal: TMyString;
begin

  ResultVal := TMyString.Create('');

  case (format) of
    dfFormatFullWithClientName:
    begin
      ResultVal.Append(kHeaderStartTag);
      ResultVal.Append(#13#10 + kRpcTag      + Name);
      ResultVal.Append(#13#10 + kRpcDebugIdTag    + IntToStr(UniqueId));
      ResultVal.Append(#13#10 + kClientNameTag    + ClientName);
      ResultVal.Append(#13#10 + kClientDebugIdTag  + IntToStr(UniqueClientId));
      ResultVal.Append(#13#10 + kContextTag    + Context);
      ResultVal.Append(#13#10 + kDurationTag    + IntToStr(Duration) + 'ms');
      //ResultVal.Append(#13#10 + kTimeDateTag    + EndDateTime);
      ResultVal.Append(#13#10 + kParamsTag      + CreateParamsDisplayString);
      ResultVal.Append(#13#10 + kResultsTag    + CreateResultsDisplayString);
      ResultVal.Append(#13#10 + kHeaderEndTag);
    end;
    dfFormatForList:
    begin
//          ResultVal.Append(Name+#09rpcId:='+UniqueId+#09cId:='+UniqueClientId+'  time:='+Duration+'ms  '+ClientName);
{      if(Duration < 1)
        durationStr := '<1'
      else
       durationStr := Duration.ToString();

      ResultVal.Append(  Name.PadRight(kNamePad)+
                  ' cId:='+UniqueClientId.ToString().PadRight(kcIdpad)+
                  ' time:='+duration.PadLeft(kDurationPad)+'ms'+
                  ' rpcId:='+UniqueId.ToString().PadRight(krpcIdPad)+
                  ClientName);
}
      end;
    else
      begin
          ResultVal.Append(kHeaderStartTag);
          ResultVal.Append(#13#10 + kRpcTag      + Name);
          ResultVal.Append(#13#10 + kRpcDebugIdTag    + IntToStr(UniqueId));
          //ResultVal.Append(#13#10 + kClientNameTag    + ClientName);
          //ResultVal.Append(#13#10 + kClientDebugIdTag  + UniqueClientId);
          ResultVal.Append(#13#10 + kContextTag    + Context);
          ResultVal.Append(#13#10 + kDurationTag    + IntToStr(Duration) + 'ms');
          //ResultVal.Append(#13#10 + kTimeDateTag    + EndDateTime);
          ResultVal.Append(#13#10 + kParamsTag      + CreateParamsDisplayString());
          ResultVal.Append(#13#10 + kResultsTag    + CreateResultsDisplayString());
          ResultVal.Append(#13#10 + kHeaderEndTag);
          // Default case is FormatFullWithoutClientName
      end;
    end;
    Result := ResultVal.ToString();
end;
    
function TRpcLogEntry.CreateClipboardString: String;
var
  ResultVal: TMyString;
begin
  ResultVal := TMyString.Create('');
      ResultVal.Append(kHeaderStartTag);
      ResultVal.Append(#13#10#13#10+kRpcTag+Name);
      ResultVal.Append(#13#10+kRpcDebugIdTag+ IntToStr(UniqueId));
      ResultVal.Append(#13#10+kClientNameTag+ClientName);
      ResultVal.Append(#13#10+kClientDebugIdTag+ IntToStr(UniqueClientId));
      ResultVal.Append(#13#10+kContextTag+Context);
      ResultVal.Append(#13#10+kDurationTag+ IntToStr(Duration));
      ResultVal.Append(#13#10#13#10+kParamsTag+#13#10);
      ResultVal.Append(CreateParamsDisplayString);
      ResultVal.Append(#13#10#13#10+kResultsTag+#13#10);
      ResultVal.Append(CreateResultsDisplayString);
      ResultVal.Append(#13#10#13#10+kHeaderEndTag+#13#10#13#10);
  Result := ResultVal.ToString();
end;

// const char kSEP_FS = (char)28;
const kSEP_GS: String = #29;
const kSEP_US: String = #30;
const kSEP_RS: String = #31;

function TRpcLogEntry.CreateParamsDisplayString: String;
var
  Str: String;
  Chr: Char;
  Chr1: String;
  TypeStr{, x, y}: String;
  ResultVal: TMyString;
  i, {j,} CurrStart: Integer;
  LengthOfRpcParams: Integer;
  EndOfSegment: Integer;
  ARef, AVal: String;
  Str2: String;
begin
  ResultVal := TMyString.Create('');
  LengthOfRpcParams := Length(mRpcParamsString);
  if LengthOfRpcParams > 0 then
  begin
    Str := mRpcParamsString;
    CurrStart := 1;
    i := 1;
//      for i:=0 to Pred(Params.Count) do
    while CurrStart < LengthOfRpcParams do
    begin
      Chr1 := Copy(Str,CurrStart,1);
      Chr := PChar(Chr1)^;
      case Chr of    //
        'L': typeStr := kLiteral;
        'R': typeStr := kReference;
        'M': typeStr := kList;
        else typeStr := kUndefined ;
      end;    // case
      if i <> 1 then
        ResultVal.Append(#13#10);
      ResultVal.Append(TypeStr+#9);
      CurrStart := CurrStart + 2;
      if TypeStr = kList then
      begin
        EndOfSegment := 0;
        while Copy(Str,CurrStart,1) <> kSep_GS do
        begin
          EndOfSegment := PosNext(kSep_US,CurrStart,Str);
          ARef := Copy(Str,CurrStart,EndOfSegment-CurrStart);
          CurrStart := EndOfSegment + 1;
          EndOfSegment := PosNext(kSep_RS,CurrStart,Str);
          AVal := Copy(Str,CurrStart,EndOfSegment-CurrStart);
          CurrStart := EndOfSegment + 1;
          ResultVal.Append(#13#10#9+ARef+#9+AVal);
          Str2 := #13#10#9+Aref+#9+Aval;
          Aval := Str2;
        end;    // while
        if EndOfSegment = 0 then
          EndOfSegment := PosNext(kSep_GS,CurrStart,Str);
        CurrStart := EndOfSegment + 1;
      end
      else
      begin
        EndOfSegment := PosNext(kSEP_GS,CurrStart,Str);
        ResultVal.Append(Copy(Str,CurrStart,EndOfSegment-CurrStart));
        CurrStart := EndOfSegment + 1;
      end;
      Inc(i);
    end;  // while
  end;
{
  else
      Assert(False);
}
{
    if (i<>0) then
      ResultVal.Append(#13#10);
    ResultVal.Append(typeStr+#09+Params[i].Value);
        if (Params[i].PType = List) then
        begin
          for j:=0 to Pred(Params[i].Mult.Count) do
          begin
            x := Params[i].Mult.Subscript(j);
            y := Params[i].Mult[x];
            ResultVal.Append(#13#10#09+'('+x+'):='+y);
          end
        end
      end;
}
  Result := ResultVal.ToString;
end;

function TRpcLogEntry.CreateResultsDisplayString: String;
begin
  Result := StrResults;
end;

end.
