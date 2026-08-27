unit ArrayListWrapper;

interface

uses ShareMem, Classes, JNI, SysUtils;

type

TArrayListWrapper = class(TObject)
private
  javaRef: JObject;
  clazz: JClass;
  addMethod: JMethodID;
  FJVM: TJNIEnv;
  procedure assertNotNull(jObj: JObject; msg: string);
  procedure assertNoException(msg:string);
protected
public
  constructor Create(aJVM: TJNIEnv);
  destructor Destroy; override;
  property JavaReference: JObject read javaRef;
  property JVM: TJNIEnv read FJVM write FJVM;
  function Add(jObj: JObject): boolean;
end;

TArrayListException = class(Exception);

implementation

procedure TArrayListWrapper.assertNotNull(jObj: JObject; msg: string);
begin
  if not Assigned(jObj) then begin
    if (JVM.ExceptionCheck) then begin
      JVM.ExceptionDescribe;
      JVM.ExceptionClear;
    end;
    raise TArrayListException.Create(msg);
  end;
end;

procedure TArrayListWrapper.assertNoException(msg:string);
begin
    if (JVM.ExceptionCheck) then begin
      JVM.ExceptionDescribe;
      JVM.ExceptionClear;
      raise TArrayListException.Create(msg);
    end;
end;

constructor TArrayListWrapper.Create(aJVM: TJNIEnv);
var
  createMethod: JMethodID;
begin                     
  inherited create;
  JVM := aJVM;  {lw added}
  clazz := JVM.FindClass('java/util/ArrayList');
  assertNotNull(clazz, 'Could not get the ArrayList Java class.');
  createMethod := JVM.GetMethodID(clazz,'<init>','()V');
  assertNoException('Error getting the ArrayList.<init> method.');
  javaRef := JVM.NewObjectA(clazz,createMethod,nil);
  assertNotNull(javaRef, 'Counld not create a new ArrayList object.');
  addMethod := JVM.GetMethodID(clazz, 'add', '(Ljava/lang/Object;)Z');
  assertNoException('Error getting the ArrayList.add method.');
end;

destructor TArrayListWrapper.Destroy;
begin
  javaRef := nil;
  clazz := nil;
  addMethod := nil;
  inherited;
end;

function TArrayListWrapper.Add(jObj: JObject): boolean;
begin
  result := JVM.CallBooleanMethod(javaRef,addMethod,[jObj]);
end;

end.
