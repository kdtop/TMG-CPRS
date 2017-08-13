unit Message;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, ActiveX, ComObj, ExtCtrls, comserv;

type
  TfrmMessage = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Done: boolean;
  end;

var
  frmMessage: TfrmMessage;

implementation

uses VAUtils, FSAPILib_TLB, VA508AccessibilityConst;

{$R *.dfm}
{$R FSAPIVER.res}
{$R JAWSAPI.res}

const
  JAWS_INSTALL_DIRECTORY_KEY = 'SOFTWARE\Freedom Scientific\JAWS\';
  JAWS_INSTALL_DIRECTORY_VAR = 'Target';
  JAWS_SHARED_DIR = 'Shared\';
  JAWS_FSAPI_DIR = 'fsapi\';
  DLL_NAME = 'FSAPI.dll';
  CPP_INSTALL_APP = 'vcredist_x86.exe';

type
  TDllRegisterServer = function: HResult; stdcall;

const
  DllRegisterServerName = 'DllRegisterServer';

  UPDATE_VERSION_ID = 5000;
  TARGET_DIR_ID = 5001;
  DLL_RESOURCE_NAME = 'COMOBJECT';

procedure TfrmMessage.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMessage.FormCreate(Sender: TObject);
var
  UpdateDirs: TStringList;
  msg: string;
  buffer: array[0..255] of char;

  procedure ProcessParams;
  var
    data: TStringList;
    version: string;

  begin
    if (ParamCount > 1) and FileExists(ParamStr(1)) then
    begin
      version := FileVersionValue(ParamStr(1), FILE_VER_FILEVERSION);
      data := TStringList.Create;
      try
        data.add('STRINGTABLE');
        data.add('{');
        data.add(' ' + IntToStr(UPDATE_VERSION_ID) + ', "' + version + '"');
        data.add('}');
        data.SaveToFile(ParamStr(2));
      finally
        data.Free;
      end;
    end;
    Done := TRUE;
  end;

  procedure GetTargetDirectories(Dirs: TStringList);
  var
    reg: TRegistry;
    keys: TStringList;
    idx, i: integer;
    key, dir: string;
    JFile, JFileVersion: string;
    VerOK, Found: boolean;

  begin
    keys := TStringList.Create;
    try
      reg := TRegistry.Create(KEY_READ);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKeyReadOnly(JAWS_INSTALL_DIRECTORY_KEY);
        reg.GetKeyNames(keys);
        Found := FALSE;
        for I := 0 to keys.Count - 1 do
        begin
          key := JAWS_INSTALL_DIRECTORY_KEY + keys[i] + '\';
          reg.CloseKey;
          if reg.OpenKeyReadOnly(key) then
          begin
            dir := LowerCase(reg.ReadString(JAWS_INSTALL_DIRECTORY_VAR));
            JFile := AppendBackSlash(dir) + JAWS_APPLICATION_FILENAME;
            if FileExists(JFile) then
            begin
              Found := TRUE;
              JFileVersion := FileVersionValue(JFile, FILE_VER_FILEVERSION);
              VerOK := VersionOK(JAWS_REQUIRED_VERSION, JFileVersion);
              if VerOK then
              begin
                idx := pos('\jaws\', dir);
                if idx > 0 then
                begin
                  dir := copy(dir, 1, idx);
                  if dirs.IndexOf(dir) < 0 then
                    dirs.Add(dir);
                end;
              end;
            end;
          end;
        end;
        if found and (dirs.Count = 0) then
          dirs.Add('');
      finally
        reg.Free;
      end;
    finally
      keys.free;
    end;
  end;

  function RegSvr(filename: string): boolean;
  var
    dll: HModule;
    regsvr: TDllRegisterServer;
  begin
    Result := TRUE;
    dll := 0;
    try
      dll := LoadLibrary(PChar(Filename));
      if dll > HINSTANCE_ERROR then
      begin
        try
          regsvr := GetProcAddress(dll, DllRegisterServerName);
          if assigned(regsvr) then
            OleCheck(regsvr);
        finally
          FreeLibrary(dll);
        end;
      end
      else
        Result := FALSE;
    except
      Result := FALSE;
      if dll > HINSTANCE_ERROR then
        FreeLibrary(dll);
    end;
  end;

  procedure RegisterServer(filename: string; var msg: string);
  var
    api: IJawsApi;
    oldmsg: string;
    Registered: boolean;
    cppInstall: string;

  begin
    try
      try
        api := CoJawsApi.Create;
      except
        oldmsg := msg;
        msg := 'Error registering the required JAWS Component (' + DLL_NAME +
               ').  You must have admin rights on your machine to register this component.  ' +
               'Please contact your system administrator for assistance.';
        try
          Registered := RegSvr(filename);
          if not Registered then
          begin
            cppInstall := ExtractFilePath(Application.ExeName) + CPP_INSTALL_APP;
            if fileExists(cppInstall) then
            begin
              ExecuteAndWait(cppInstall);
              Registered := RegSvr(filename);
            end;
          end;

          if Registered then
          begin
            api := CoJawsApi.Create;

            if oldmsg = '' then
              msg :=''
            else
              msg := oldmsg + #13#10;
            msg := msg + 'The required JAWS Component has been successfully registered.';
          end;
        except
        end;
      end;
    finally
      api := nil;
    end;
  end;

  procedure UpdateCheck(UpdateDirs: TStringList; var msg: string);
  var
    UpdateVersion, ExistingVersion: string;
    i: integer;
    dirs: TStringList;
    filename, dir, TargetDir: string;
    update: boolean;

  begin
    LoadString(HInstance, UPDATE_VERSION_ID, @buffer, 255);
    UpdateVersion := StrPas(buffer);

    LoadString(HInstance, TARGET_DIR_ID, @buffer, 255);
    TargetDir := StrPas(buffer);

    dirs := TStringList.Create;
    try
      GetTargetDirectories(dirs);
      if dirs.Count < 1 then
        msg := 'Can not find JAWS installed on this machine';
      if (dirs.Count = 1) and (dirs[0] = '') then
      begin
        dirs.Delete(0);
        msg := 'JAWS version ' + JAWS_REQUIRED_VERSION + ' or higher is required in order to run JAWSUpdate';
      end;
      for I := 0 to dirs.Count - 1 do
      begin
        dir := dirs[i] + JAWS_SHARED_DIR + JAWS_FSAPI_DIR + TargetDir;
        dir := AppendBackSlash(dir);
        update := TRUE;
        if DirectoryExists(dir) then
        begin
          filename := dir + DLL_NAME;
          if FileExists(fileName) then
          begin
            ExistingVersion := FileVersionValue(fileName, FILE_VER_FILEVERSION);
            update := not VersionOK(UpdateVersion, ExistingVersion);
            if not update then
              RegisterServer(filename, msg);
          end;
        end;
        if update then
          UpdateDirs.Add(dirs[i]);
      end;
    finally
      dirs.Free;
    end;
    if (UpdateDirs.Count < 1) and (msg = '') then
      msg := 'The required JAWS Component is already installed on your machine';
  end;

  function MakeDirError(dir: string; var msg: string): boolean;
  begin
    Result := FALSE;
    if not DirectoryExists(dir) then
    begin
      if not CreateDir(dir) then
      begin
        msg := 'Error Creating Directory ' + dir;
        Result := TRUE;
      end;
    end;
  end;

  procedure DoUpdate(UpdateDirs: TStringList; var msg: string);
  var
    i: integer;
    dir, last: string;
    TargetDir: string;
    rs: TResourceStream;
    fs: TFileStream;
    filename: string;

  begin
    LoadString(HInstance, TARGET_DIR_ID, @buffer, 255);
    TargetDir := StrPas(buffer);

    for I := 0 to UpdateDirs.Count - 1 do
    begin
      dir := UpdateDirs[i];
      if MakeDirError(dir, msg) then continue;
      dir := dir + JAWS_SHARED_DIR;
      if MakeDirError(dir, msg) then continue;
      dir := dir + JAWS_FSAPI_DIR;
      if MakeDirError(dir, msg) then continue;
      dir := dir + TargetDir;
      dir := AppendBackSlash(dir);
      if MakeDirError(dir, msg) then continue;
      filename := dir + DLL_NAME;
      if FileExists(filename) then
        DeleteFile(filename);
      last := filename;
      try
        rs := TResourceStream.Create(HInstance, DLL_RESOURCE_NAME, RT_RCDATA);
        try
          fs := TFileStream.Create(filename, fmCreate OR fmShareExclusive);
          try
            fs.CopyFrom(rs, rs.Size);
          finally
            fs.Free;
          end;
        finally
          rs.Free;
        end;
      except
        on e:Exception do
          msg := e.Message;
      end;
    end;
    if msg = '' then
    begin
      msg := 'The required JAWS Component has been successfully installed.';
      RegisterServer(last, msg);
    end;
  end;

  procedure DeleteOldUpdater;
  var
    u8File: string;
  begin
    u8File := ExtractFilePath(Application.ExeName) + 'Jaws8Update.exe';
    if fileExists(u8File) then
      SysUtils.DeleteFile(u8File);
  end;

begin
  if (ParamCount > 0) then
    ProcessParams
  else
  begin
    DeleteOldUpdater;
    UpdateDirs := TStringList.Create;
    try
      msg := '';
      UpdateCheck(UpdateDirs, msg);
      if UpdateDirs.Count > 0 then
        DoUpdate(UpdateDirs, msg);
      label1.Caption := msg;
    finally
      UpdateDirs.Free;
    end;
  end;
end;

procedure TfrmMessage.FormShow(Sender: TObject);
begin
  if Done then Close;
end;

end.
