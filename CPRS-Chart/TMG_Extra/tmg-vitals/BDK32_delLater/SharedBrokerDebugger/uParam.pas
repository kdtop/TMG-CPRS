unit uParam;

interface

uses
  Classes;

Type
  TParamType = (Literal, Reference, List, Undefined);

  TParamMult = class
  private
    mName: String;
    mMultiple: NameValueCollection;
  protected
    function GetCount: Integer;
    function GetFirst: String;
    function GetLast: String;
    function GetMultiple(index: String): string;
    procedure SetMultiple(index, value: string);
  public
    property Name: String read mName write mName;
    property Count: Integer read GetCount;
    property First: String read GetFirst;
    property Last: String read GetLast;
    property Self[index: string] read GetMultiple write SetMultiple;
  end;

  TParamRecord = class
  private
    mValue: String;
    mPType: TParamType;
    mMult: TParamMult;
  public
    property Value: String read mValue write mValue;
    property PType: TParamType read mPType write mPType;
    property Mult: TParamMult read mMult write mMult;
  end;

  TParam = class
  private
    mParameters: TList;
  protected
    procedure SetParameter(index: Integer; parameter: TParamRecord);
    function GetParameter(index: Integer): TParamRecord;
  public
    Constructor Create; overload;
    Constructor Create(rpcParams: String); overload;
    procedure Clear;
    property ParamRecord[index: Integer]: TParam read GetParameter write SetParameter;
    property Count: Integer read GetCount;
  end;


implementation

  // Thes classes are ported from Delphi and have hardly been tested.
  // Use them at your own discression.

  /// <summary>
  /// Summary description for Param.
  /// </summary>
procedure TParam.Clear;
var
  i: Integer;
begin
  for i:=0 to Pred(mParameters.Count) do
        mParameters[i] := nil;

  mParameters.Clear;
end;

procedure TParam.Assign(source: TParam)
begin
  Clear;
  for i:=0 to Pred(source.Count) do
  begin
    Self[i].Value := source[i].Value;
    Self[i].PType := source[i].PType;
    Self[i].Mult.Assign(source[i].Mult);
  end;
end;


Constructor TParam.Create;
begin
  mParameters := TList.Create;
end;

    /// <summary>
    /// This Param constructor takes a string and splits it into ParamRecords
    /// </summary>
    /// <param name:='rpcParams'></param>
Constructor TParam.Create(rpcParams: String)
var
  i, curStart, lengthOfRpcParams, EndOfSegment: Integer;
  aRef, aVal: String;
  ParamRecord: TParamRecord;
begin

const
      // kSEP_FS: char = 28;
  kSEP_GS: char = 29;
  kSEP_US: char = 30;
  kSEP_RS: char = 31;

  mParameters := TList.Create;
  if (rpcParams <> nil) then
  begin
    curStart := 0;
    i:= 0;
    lengthOfrpcParams := Length(rpcParams);
    while (curStart < lengthOfrpcParams-1)
    begin
      paramRecord := Self[i];
      case (rpcParams[curStart]) of
        'L' : paramRecord.PType := ParamType.Literal;
        'R' : paramRecord.PType := ParamType.Reference;
        'M' : paramRecord.PType := ParamType.List;
        else : paramRecord.PType := ParamType.Undefined;
      end;
      curStart := CurStart + 2;
      if (Self[i].PType = ParamType.List) then
      begin
        endOfSegment := 0;
        while (rpcParams[curStart] <> kSEP_GS) do
        begin
          endOfSegment := PosNext(kSEP_US,curStart,lengthOfrpcParams,rpcParams);
          aRef := rpcParams.Substring(curStart,endOfSegment - curStart);
          curStart := endOfSegment + 1;
          endOfSegment := PosNext(kSEP_RS,curStart,lengthOfrpcParams,rpcParams);
          aVal := rpcParams.Substring(curStart,endOfSegment - curStart);
          curStart := endOfSegment + 1;
          Self[i].Mult[aRef] := aVal;
        end;
        if (endOfSegment = 0) then
        begin
          endOfSegment := PosNext(kSEP_GS,curStart,lengthOfrpcParams,rpcParams);
          curStart := endOfSegment + 1;
        end
        else
        begin
            endOfSegment := PosNext(kSEP_GS,curStart,lengthOfrpcParams,rpcParams);
            Self[i].Value := rpcParams.Substring(curStart,endOfSegment-curStart);
            curStart := endOfSegment + 1;
        end;
        Inc(i);
      end;
  end
  else
  begin
        // The user of this routine should always pass in a valid string
        Assert(false);
  end;
end;

Destructor TParam.Destroy;
begin
  Clear;
  mParameters.Free;
end;

    // Private Methods
function TParam.GetCount: Integer;
begin
  Result := mParameters.Count;
end;

function TParam.GetParameter(int index): ParamRecord;
begin
  if (index >= mParameters.Count) then
  begin
    while (mParameters.Count <:= index) do // Setup placehoders
       mParameters.Add(nil);
  end;
  if (mParameters[index] = nil)
  begin
    Result := TParamRecord.Create();
    mParameters[index] := result;
  end
  else
    Result := TParamRecord(mParameters[index]);
end;

procedure TParam.SetParameter(index: Integer; parameter: ParamRecord);
begin
  if (index >= mParameters.Count) then
    while (mParameters.Count <= index) do // Set up placeholders
      mParameters.Add(nil);

   if (mParameters[index] = nil) then
     mParameters[index] := parameter;
end;

function TParam.PosNext(aChar: char; startPos, lengthOfRpcParams: Integer; rpcParams: String): Integer;
begin
  Assert(rpcParams <> nil);

  Result := 0;
  while (result = 0) and (startPos < lengthOfRpcParams)  do
  begin
    if(rpcParams[startPos] = aChar)
      Result := startPos;
    Inc(startPos);
  end;
end;


Constructor TParamRecord.Create;
begin
  mMult := new ParamMult();
  mMult.Name := ParamMult.kMultNameDefault;
  mValue := nil;
  mPType := ParamType.Undefined;
end;

Destructor TParamRecord.Destroy;
begin
      if(mMult <> nil)
      begin
        mMult := nil;
      end;
    end;

  // The ParamMult class uses a NameValueCollection dictionary/hashtable as opposted to a string list
  // like in Delphi. I think I have ported this properly preserving the desired functionality
  // I think the NameValueCollection is the right answer here, but there may be some
  // nuances that have been missed.
  // Also, an enumerator should be created (provide by NameValueCollection) if the
  // list is to be iterated over a lot between changes (for read only access). This
  // will provided enhanced performance.
const kMultInstanceNameDefault: string := 'Mult_instance';
const kMultNameDefault: string := 'Mult';

    // Public Methods
Constructor TParamMult.Create;
begin
  mMultiple := TNameValueCollection.Create;
  mName := '';
end;


Destructor TParamMult.Destroy;
begin
  ClearAll;
  mMultiple.Free;
  mMultiple := nil;
  mName := nil;
end;
    
function TParamMult.Position(subscript: string): Integer;
var
  i: Integer;
begin
  Result := -1;

  for i:=0 to Pred(mMultiple.Count) do
  begin
    if (mMultiple.GetKey(i) = subscript)
    begin
      Result := i;
      break;
    end;
  end;
end;


function TParamMult.Subscript(position: Integer): String;
begin
  if(position > -1 && position < Count) then
    result := mMultiple.GetKey(position);
end;
    /// <summary>
    /// In Assign all of the items from source object are copied one by one into the
    /// target.  So if the source is later destroyed, target object will continue
    /// to hold the copy of all elements, completely unaffected.
    /// The source can only be a NameValueCollection or else it with throw an exception.
    /// </summary>
    /// <param name:='source'></param>
{
    public void      Assign(object source)
    begin
      ClearAll();
      if (source is ParamMult)
        mMultiple.Add((NameValueCollection)source);
      else
        throw(new ParamMultException('Invalid source type'+ source.GetType()+' in method Assign'));
    end;
}
    /// <summary>
    /// Order returns the subscript string of the next or previous element from the
    /// StartSubscript.  This is very similar to the $O function available in M.
    /// nil string ('') is returned when reaching beyong the first or last
    /// element, or when list is empty. Note: A major difference between the M $O 
    /// and this function is that in this function StartSubscript must identify a valid subscript
    /// in the list.
    /// </summary>
    /// <param name:='startSubscript'></param>
    /// <param name:='direction'></param>
    /// <returns></returns>
function TParamMult.Order(startSubscript: String; direction: Integer): String;
var
  index: Integer;
begin
  if (startSubscript = '') then
  begin
    if(direction > 0) then
      result := First
    else
      result := Last;
  end
  else
  begin
    index := Position(startSubscript);
    if(index > -1) then
    begin
      if (index < (Count -1)) and (direction > 0) then
        result := mMultiple[index+1]
      else
        result := mMultiple[index-1];
    end;
  end;
end;

{
    public class    ParamMultException : Exception
    begin
      public ParamMultException(string errorString)
        :base(kParamMultExceptionLabel + errorString)beginend;
      private const string kParamMultExceptionLabel := 'ParamMult Exeption: ';
    end;
}
procedure TParamMult.ClearAll;
begin
  mMultiple.Clear();
end;


function TParamMult.GetCount: Integer;
begin
  Result := mMultiple.Count;
end;


function TParamMult.GetFirst: String;
begin
  Result := '';
  if (mMultiple.Count > 0) then
    Result := mMultiple[0];
end;


function TParamMult.GetLast: String;
begin
  Result := '';
  if (mMultiple.Count > 0) then
    Result := mMultiple[mMultiple.Count-1];
end;


    /// <summary>
    /// GetMultiple Returns the VALUE of the element whose subscript is passed.
    /// </summary>
    /// <param name:='index'></param>
    /// <returns></returns>
function TParamMult.GetMultiple(index: String): String;
var
  TryResult: String;
  StrError: String;
begin
  tryResult := '';
      try
      begin
        tryResult := mMultiple[index];
      end;
        // The requested string might not be in the string array in which case IndexOf will 
        // return a -1 so lets handle this through an IndexOutOfRangeException
//      catch (ArgumentOutOfRangeException)
      except
      begin
        if (Name <> '') then
          StrError :=Name
        else
          StrError := kMultInstanceNameDefault;
        strError +:= StrError + '[' + index + ']'#0D#0A' is undefined';

        // There was a complicated way to attempt to find this data on exception
        // in the Delphi unit trpcb.pas in the broker project under
        // TMult.GetFMultiple. I did not understand this so I will throw an
        // exception here. -Travis

//        throw( new ParamMultException(strError));
      end;
      finally
      begin
        result := tryResult;
      end;
end;


    /// <summary>
    /// SetMultiple Stores a new element in the multiple.  mMultiple (StringCollection) is the
    /// structure, which is used to hold the subscript and value pair.  Subscript is stored as 
    /// the String, value is stored as an object of the string.
    /// </summary>
    /// <param name:='index'></param>
    /// <param name:='Value'></param>
procedure TParamMult.SetMultiple(index, newElement: String):
begin
  mMultiple.Set(index,newElement);
end;

end.
 