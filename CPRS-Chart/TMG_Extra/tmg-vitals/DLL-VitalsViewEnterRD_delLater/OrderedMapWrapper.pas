unit OrderedMapWrapper;
interface

uses ShareMem, Classes, JNI, SysUtils;

type

TOrderedMapWrapper = class(TObject)
private
  javaRef: JObject;
  jOrderedMapClassRef: JClass;
  putMethod: JMethodID;
  FJVM: TJNIEnv;
  procedure assertNotNull(jObj: JObject; msg: string);
  procedure assertNoException(msg:string);
protected
public
  constructor Create(aJVM: TJNIEnv);
  destructor Destroy; override;
  property JavaReference: JObject read javaRef;
  property JVM: TJNIEnv read FJVM write FJVM;
  function Put(jObj: JObject;jObj2: JObject): Boolean;
end;

TOrderedMapException = class(Exception);

implementation

procedure TOrderedMapWrapper.assertNotNull(jObj: JObject; msg: string);
begin
  if not Assigned(jObj) then begin
    if (JVM.ExceptionCheck) then begin
      JVM.ExceptionDescribe;
      JVM.ExceptionClear;
    end;
    raise TOrderedMapException.Create(msg);
  end;
end;

procedure TOrderedMapWrapper.assertNoException(msg:string);
begin
    if (JVM.ExceptionCheck) then begin
      JVM.ExceptionDescribe;
      JVM.ExceptionClear;
      raise TOrderedMapException.Create(msg);
    end;
end;

constructor TOrderedMapWrapper.Create(aJVM: TJNIEnv);
var
  createMethod: JMethodID;
begin
  inherited create;
  JVM := aJVM;  {lw added}
  jOrderedMapClassRef := JVM.FindClass('gov/va/med/cprs/wrapped/OrderedMap');
  assertNotNull(jOrderedMapClassRef, 'Could not get the OrderedMap Java class.');
  createMethod := JVM.GetMethodID(jOrderedMapClassRef,'<init>','()V');
  assertNoException('Error getting the OrderedMap.<init> method.');
  javaRef := JVM.NewObjectA(jOrderedMapClassRef,createMethod,nil);
  assertNotNull(javaRef, 'Counld not create a new OrderedMap object.');
  putMethod := JVM.GetMethodID(jOrderedMapClassRef, 'put', '(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;');
  assertNoException('Error getting the OrderedMap.put method.');
end;

destructor TOrderedMapWrapper.Destroy;
begin
  javaRef := nil;
  jOrderedMapClassRef := nil;
  putMethod := nil;
  inherited;
end;

function TOrderedMapWrapper.Put(jObj: JObject;jObj2: JObject): Boolean;
begin
  result := JVM.CallBooleanMethod(javaRef,putMethod,[jObj,jObj2]);
end;

end.
