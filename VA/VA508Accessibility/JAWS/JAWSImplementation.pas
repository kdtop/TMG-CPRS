unit JAWSImplementation;

interface
{ DONE -oJeremy Merrill -c508 :
Add something that prevents overwriting of the script files if another
app is running that's using the JAWS DLL }
{ TODO -oJeremy Merrill -c508 : Add check in here to look at script version in JSS file }
{ DONE -oJeremy Merrill -c508 :
Replace registry communication with multiple windows - save strings in the window titles
Use EnumerateChildWindows jaws script function in place of the FindWindow function
that's being used right now.- EnumerateChildWindows with a window handle of 0
enumerates all windows on the desktop.  Will have to use the first part of the window
title as an ID, and the last part as the string values.  Will need to check for a maximum
string lenght, probably have to use multiple windows for long text.
Will also beed to have a global window shared by muiltiple instances of the JAWS.SR DLL. }
{ DONE -oJeremy Merrill -c508 :
Need to add version checking to TVA508AccessibilityManager component
and JAWS.DLL.  Warning needs to display just like JAWS.DLL and JAWS. }
uses SysUtils, Windows, Classes, Registry, StrUtils, Forms, Dialogs,
      ExtCtrls, VAUtils, DateUtils, PSApi, IniFiles, ActiveX,
      SHFolder, ShellAPI, VA508AccessibilityConst;

{$I 'VA508ScreenReaderDLLStandard.inc'}

{ DONE -oJeremy Merrill -c508 :Figure out why Delphi IDE is loading the DLL when JAWS is running  -
probably has something to do with the VA508 package being installed -
need to test for csDesigning some place that we're not testing for (maybe?)}

exports Initialize, ShutDown, RegisterCustomBehavior, ComponentData,
        SpeakText, IsRunning, ConfigChangePending;

implementation

uses fVA508HiddenJawsMainWindow, FSAPILib_TLB, ComObj;

const
//  JAWS_REQUIRED_VERSION     = '7.10.500'; in VA508AccessibilityConst unit
  JAWS_COM_OBJECT_VERSION = '8.0.2173';

	VA508_REG_PARAM_KEY = 'Software\Vista\508\JAWS';

  VA508_REG_COMPONENT_CAPTION = 'Caption';
  VA508_REG_COMPONENT_VALUE = 'Value';
  VA508_REG_COMPONENT_CONTROL_TYPE = 'ControlType';
  VA508_REG_COMPONENT_STATE = 'State';
  VA508_REG_COMPONENT_INSTRUCTIONS = 'Instructions';
  VA508_REG_COMPONENT_ITEM_INSTRUCTIONS = 'ItemInstructions';
  VA508_REG_COMPONENT_DATA_STATUS = 'DataStatus';

	VA508_ERRORS_SHOWN_STATE = 'ErrorsShown';

  RELOAD_CONFIG_SCRIPT = 'VA508Reload';

  SLASH = '\';
{ TODO -oJeremy Merrill -c508 :
Change APP_DATA so that "application data" isn't used - Windows Vista
doesn't use this value - get data from Windows API call }
  APP_DATA = SLASH + 'application data' + SLASH;
  JAWS_COMMON_SCRIPT_PATH_TEXT = '\freedom scientific\jaws\';
  JAWS_COMMON_SCRIPT_PATH_TEXT_LEN = length(JAWS_COMMON_SCRIPT_PATH_TEXT);

type
  TCompareType = (jcPrior, jcINI, jcLineItems, jcVersion, jcScriptMerge);

  TFileInfo = record
    AppFile: boolean;
    Ext: string;
    CompareType: TCompareType;
    Required: boolean;
    Compile: boolean;
  end;

const
  JAWS_SCRIPT_NAME = 'VA508JAWS';

  JAWS_SCRIPT_VERSION = 'VA508_Script_Version';
  CompiledScriptFileExtension = '.JSB';
  ScriptFileExtension = '.JSS';
  ScriptDocExtension = '.JSD';
  ConfigFileExtension = '.JCF';
  KeyMapExtension = '.JKM';
  DictionaryFileExtension = '.JDF';

  FileInfo: array[1..6] of TFileInfo = (
    (AppFile: FALSE; Ext: ScriptFileExtension;     CompareType: jcVersion;     Required: TRUE;  Compile: TRUE),
    (AppFile: FALSE; Ext: ScriptDocExtension;      CompareType: jcPrior;       Required: TRUE;  Compile: FALSE),
    (AppFile: TRUE;  Ext: ScriptFileExtension;     CompareType: jcScriptMerge; Required: TRUE;  Compile: TRUE),
    (AppFile: TRUE;  Ext: ConfigFileExtension;     CompareType: jcINI;         Required: TRUE;  Compile: FALSE),
    (AppFile: TRUE;  Ext: DictionaryFileExtension; CompareType: jcLineItems;   Required: FALSE; Compile: FALSE),
    (AppFile: TRUE;  Ext: KeyMapExtension;         CompareType: jcINI;         Required: FALSE; Compile: FALSE));

  JAWS_VERSION_ERROR = ERROR_INTRO + 
    'The Accessibility Framework can only communicate with JAWS ' + JAWS_REQUIRED_VERSION + CRLF +
    'or later versions.  Please update your version of JAWS to a minimum of' + CRLF +
    JAWS_REQUIRED_VERSION + ', or preferably the most recent release, to allow the Accessibility' + CRLF +
    'Framework to communicate with JAWS.  If you are getting this message' + CRLF +
    'and you already have a compatible version of JAWS, please contact your' + CRLF +
    'system administrator, and request that they run, with administrator rights,' + CRLF +
    'the JAWSUpdate application located in the \Program Files\VistA\' + CRLF +
    'Common Files directory. JAWSUpdate is not required for JAWS' + CRLF +
    'versions ' + JAWS_COM_OBJECT_VERSION + ' and above.' + CRLF;

  JAWS_FILE_ERROR = ERROR_INTRO +
    'The JAWS interface with the Accessibility Framework requires the ability' + CRLF +
    'to write files to the hard disk, but the following error is occurring trying to' + CRLF +
    'write to the disk:' + CRLF + '%s' + CRLF +
    'Please contact your system administrator in order to ensure that your ' + CRLF +
    'security privileges allow you to write files to the hard disk.' + CRLF +
    'If you are sure you have these privileges, your hard disk may be full.  Until' + CRLF +
    'this problem is resolved, the Accessibility Framework will not be able to' + CRLF +
    'communicate with JAWS.';

  JAWS_USER_MISSMATCH_ERROR = ERROR_INTRO +
    'An error has been detected in the state of JAWS that will not allow the' + CRLF +
    'Accessibility Framework to communicate with JAWS until JAWS is shut' + CRLF +
    'down and restarted.  Please restart JAWS at this time.';

  DLL_VERSION_ERROR = ERROR_INTRO +
    'The Accessibility Framework is at version %s, but the required JAWS' + CRLF +
    'support files are only at version %s.  The new support files should have' + CRLF +
    'been released with the latest version of the software you are currently' + CRLF +
    'running.  The Accessibility Framework will not be able to communicate' + CRLF +
    'with JAWS until these support files are installed.  Please contact your' + CRLF +
    'system administrator for assistance.';

  JAWS_ERROR_VERSION = 1;
  JAWS_ERROR_FILE_IO = 2;
  JAWS_ERROR_USER_PROBLEM = 3;
  DLL_ERROR_VERSION = 4;

  JAWS_ERROR_COUNT = 4;

  JAWS_RELOAD_DELAY = 500;

var
  JAWSErrorMessage: array[1..JAWS_ERROR_COUNT] of string = (JAWS_VERSION_ERROR, JAWS_FILE_ERROR,
         JAWS_USER_MISSMATCH_ERROR, DLL_VERSION_ERROR);
         
  JAWSErrorsShown: array[1..JAWS_ERROR_COUNT] of boolean  = (FALSE, FALSE, FALSE, FALSE);

type
  TJAWSSayString = function(StringToSpeak: PChar; Interrupt: BOOL): BOOL; stdcall;
  TJAWSRunScript = function(ScriptName: PChar): BOOL; stdcall;

  TStartupID = record
    Handle: HWND;
    InstanceID: Integer;
    MsgID: Integer;
  end;

  TJAWSManager = class
  strict private
    FRequiredFilesFound: boolean;
    FMainForm: TfrmVA508HiddenJawsMainWindow;
    FWasShutdown: boolean;
    FJAWSFileError: string;
    FDictionaryFileName: string;
    FConfigFile: string;
    FKeyMapFile: string;
    FMasterApp: string;
    FRootScriptFileName: string;
    FRootScriptAppFileName: string;
    FDefaultScriptDir: string;
    FUserStriptDir: string;
    FKeyMapINIFile: TINIFile;
    FKeyMapINIFileModified: boolean;
    FAssignedKeys: TStringList;
    FConfigINIFile: TINIFile;
    FConfigINIFileModified: boolean;
    FDictionaryFile: TStringList;
    FDictionaryFileModified: boolean;
    FCompiler: string;
    JAWSAPI: IJawsApi;
  private
    procedure ShutDown;
    procedure MakeFileWritable(FileName: string);
    procedure LaunchMasterApplication;
    procedure KillINIFiles(Sender: TObject);
    procedure ReloadConfiguration;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure ShowError(ErrorNumber: integer); overload;
    class procedure ShowError(ErrorNumber: integer; data: array of const); overload;
    class function GetPathFromJAWS(PathID: integer; DoLowerCase: boolean = TRUE): string;
    class function GetJAWSWindow: HWnd;
    class function IsRunning(HighVersion, LowVersion: Word): BOOL;
    function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL;
    procedure SendComponentData(WindowHandle: HWND; DataStatus: LongInt; Caption, Value, Data,
            ControlType, State, Instructions, ItemInstructions: PChar);
    procedure SpeakText(Text: PChar);
    procedure RegisterCustomBehavior(Before, After: string; Action: integer);
    class function JAWSVersionOK: boolean;
    class function JAWSTalking2CurrentUser: boolean;
    function FileErrorExists: boolean;
    property RequiredFilesFound: boolean read FRequiredFilesFound;
    property MainForm: TfrmVA508HiddenJawsMainWindow read FMainForm;
 end;

var
  JAWSManager: TJAWSManager = nil;
  DLLMessageID: UINT = 0;

procedure EnsureManager;
begin
  if not assigned(JAWSManager) then
    JAWSManager := TJAWSManager.Create;
end;

// Checks to see if the screen reader is currently running
function IsRunning(HighVersion, LowVersion: Word): BOOL; stdcall;
begin
  Result := TJAWSManager.IsRunning(HighVersion, LowVersion);
end;

// Executed after IsRunning returns TRUE, when the DLL is accepted as the screen reader of choice
function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL; stdcall;
begin
  EnsureManager;
  Result := JAWSManager.Initialize(ComponentCallBackProc);
end;

// Executed when the DLL is unloaded or screen reader is no longer needed
procedure ShutDown; stdcall;
begin
  if assigned(JAWSManager) then
  begin
    JAWSManager.ShutDown;
    FreeAndNil(JAWSManager);
  end;
end;

function ConfigChangePending: boolean; stdcall;
begin
  Result := FALSE;
  if assigned(JAWSManager) and assigned(JAWSManager.MainForm) and
                              (JAWSManager.MainForm.ConfigChangePending) then
    Result := TRUE;
end;

// Returns Component Data as requested by the screen reader
procedure ComponentData(WindowHandle: HWND;
                                   DataStatus:   LongInt = DATA_NONE;
                                   Caption:      PChar = nil;
                                   Value:        PChar = nil;
                                   Data:         PChar = nil;
                                   ControlType:  PChar = nil;
                                   State:        PChar = nil;
                                   Instructions: PChar = nil;
                                   ItemInstructions: PChar = nil); stdcall;
begin
  EnsureManager;
  JAWSManager.SendComponentData(WindowHandle, DataStatus, Caption, Value, Data, ControlType, State,
                                Instructions, ItemInstructions);
end;

// Instructs the Screen Reader to say the specified text
procedure SpeakText(Text: PChar); stdcall;
begin
  EnsureManager;
  JAWSManager.SpeakText(Text);
end;

procedure RegisterCustomBehavior(BehaviorType: integer; Before, After: PChar);
begin
  EnsureManager;
  JAWSManager.RegisterCustomBehavior(Before, After, BehaviorType);
end;

{ TJAWSManager }

const
{$WARNINGS OFF} // Don't care about platform specific warning
  NON_WRITABLE_FILE_ATTRIB = faReadOnly or faHidden;
{$WARNINGS ON}
  WRITABLE_FILE_ATTRIB = faAnyFile and (not NON_WRITABLE_FILE_ATTRIB);

procedure TJAWSManager.MakeFileWritable(FileName: string);
var
  Attrib: integer;
begin
  {$WARNINGS OFF} // Don't care about platform specific warning
  Attrib := FileGetAttr(FileName);
  {$WARNINGS ON}
  if (Attrib and NON_WRITABLE_FILE_ATTRIB) <> 0 then
  begin
    Attrib := Attrib and WRITABLE_FILE_ATTRIB;
    {$WARNINGS OFF} // Don't care about platform specific warning
    if FileSetAttr(FileName, Attrib) <> 0 then
    {$WARNINGS ON}
      FJAWSFileError := 'Could not change read-only attribute of file "' + FileName + '"';
  end;
end;

var
  JAWSMsgID: UINT = 0;

const
  JAWS_MESSAGE_ID = 'JW_GET_FILE_PATH';
  // version is in directory after JAWS \Freedom Scientific\JAWS\*.*\...
  JAWS_PATH_ID_APPLICATION = 0;
  JAWS_PATH_ID_USER_SCRIPT_FILES = 1;
  JAWS_PATH_ID_JAWS_DEFAULT_SCRIPT_FILES = 2;
// 0 = C:\Program Files\Freedom Scientific\JAWS\8.0\jfw.INI
// 1 = D:\Documents and Settings\zzzzzzmerrij\Application Data\Freedom Scientific\JAWS\8.0\USER.INI
// 2 = D:\Documents and Settings\All Users\Application Data\Freedom Scientific\JAWS\8.0\Settings\enu\DEFAULT.SBL

class function TJAWSManager.GetPathFromJAWS(PathID: integer; DoLowerCase: boolean = TRUE): string;
var
  atm: ATOM;
  len: integer;
  path: string;
  JAWSWindow: HWnd;
begin
  JAWSWindow := GetJAWSWindow;
  if JAWSMsgID = 0 then
    JAWSMsgID := RegisterWindowMessage(JAWS_MESSAGE_ID);
  Result := '';
  atm := SendMessage(JAWSWindow, JAWSMsgID, PathID, 0);
  if atm <> 0 then
  begin
    SetLength(path, MAX_PATH * 2);
    len := GlobalGetAtomName(atm, PChar(path), MAX_PATH * 2);
    GlobalDeleteAtom(atm);
    if len > 0 then
    begin
      SetLength(path, len);
      Result := ExtractFilePath(path);
      if DoLowerCase then
        Result := LowerCase(Result); 
    end;
  end;
end;


constructor TJAWSManager.Create;
const
  COMPILER_FILENAME = 'scompile.exe';
  JAWS_APP_NAME = 'VA508APP';
  JAWSMasterApp = 'VA508JAWSDispatcher.exe';

  procedure FindCompiler;
  var
    compiler: string;

  begin
    compiler := GetPathFromJAWS(JAWS_PATH_ID_APPLICATION);
    compiler := AppendBackSlash(compiler) + COMPILER_FILENAME;
    if FileExists(compiler) then
      FCompiler := compiler;
  end;

  procedure FindJAWSRequiredFiles;
  var
    Path: string;
    i: integer;
    FileName: string;
    info: TFileInfo;

  begin
    SetLength(Path, MAX_PATH);
    SetLength(Path, GetModuleFileName(HInstance, PChar(Path), Length(Path)));
    Path := ExtractFilePath(Path);
    Path := AppendBackSlash(Path);
    // look for the script files in the same directory as this DLL
    FRootScriptFileName := Path + JAWS_SCRIPT_NAME;
    FRootScriptAppFileName := Path + JAWS_APP_NAME;
    FRequiredFilesFound := TRUE;
    for i := low(FileInfo) to high(FileInfo) do
    begin
      info := FileInfo[i];
      if info.Required then
      begin
        if info.AppFile then
          FileName := FRootScriptAppFileName + info.Ext
        else
          FileName := FRootScriptFileName + info.Ext;
        if not FileExists(FileName) then
        begin
          FRequiredFilesFound := FALSE;
          break;
        end;
      end;
    end;
    if FRequiredFilesFound then
    begin
      FMasterApp := Path + JAWSMasterApp;
      FRequiredFilesFound := FileExists(FMasterApp);
    end;
    if FRequiredFilesFound then
    begin
      FDefaultScriptDir := lowercase(GetPathFromJAWS(JAWS_PATH_ID_JAWS_DEFAULT_SCRIPT_FILES));
      FRequiredFilesFound := (pos(JAWS_COMMON_SCRIPT_PATH_TEXT, FDefaultScriptDir) > 0);
    end;
    if FRequiredFilesFound then
    begin
      FUserStriptDir := lowercase(GetPathFromJAWS(JAWS_PATH_ID_USER_SCRIPT_FILES));
      FRequiredFilesFound := (pos(JAWS_COMMON_SCRIPT_PATH_TEXT, FUserStriptDir) > 0);
    end;
  end;

begin
  FindCompiler;
  if FCompiler <> '' then
    FindJAWSRequiredFiles;
end;

destructor TJAWSManager.Destroy;
begin
  ShutDown;
  inherited;
end;

function TJAWSManager.FileErrorExists: boolean;
begin
  Result := (FJAWSFileError <> '');
end;


class function TJAWSManager.GetJAWSWindow: HWnd;
const
  VISIBLE_WINDOW_CLASS: PChar = 'JFWUI2';
  VISIBLE_WINDOW_TITLE: PChar = 'JAWS';
  VISIBLE_WINDOW_TITLE2: PChar = 'Remote JAWS';

begin
  Result := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE);
  if Result = 0 then
    Result := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE2);
end;

function TJAWSManager.Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL;
var
  DestPath: string;
  ScriptFileChanges: boolean;
  LastFileUpdated: boolean;
  CompileCommands: TStringList;
  AppScriptNeedsFunction: boolean;
  AppNeedsUseLine: boolean;
  AppUseLine: string;
  AppStartFunctionLine: integer;

  procedure EnsureWindow;
  begin
    if not assigned(FMainForm) then
      FMainForm := TfrmVA508HiddenJawsMainWindow.Create(nil);
    FMainForm.ComponentDataCallBackProc := ComponentCallBackProc;
    FMainForm.ConfigReloadProc := ReloadConfiguration;
    FMainForm.HandleNeeded;
    Application.ProcessMessages;
  end;

  
  function GetVersion(FileName: string): integer;
  var
    list: TStringList;

    p,i: integer;
    line: string;
    working: boolean;
  begin
    Result := 0;
    list := TStringList.Create;
    try
      list.LoadFromFile(FileName);
      i := 0;
      working := TRUE;
      while working and (i < list.Count) do
      begin
        line := list[i];
        p := pos('=', line);
        if p > 0 then
        begin
          if trim(copy(line,1,p-1)) = JAWS_SCRIPT_VERSION then
          begin
            line := trim(copy(line,p+1,MaxInt));
            if copy(line,length(line), 1) = ',' then
              delete(line,length(line),1);
            Result := StrToIntDef(line, 0);
            working := FALSE;
          end;
        end;
        inc(i);
      end;
    finally
      list.Free;
    end;
  end;

  function VersionDifferent(FromFile, ToFile: string): boolean;
  var
    FromVersion, ToVersion: integer;
  begin
    FromVersion := GetVersion(FromFile);
    ToVersion := GetVersion(ToFile);
    Result := (FromVersion > ToVersion);
  end;

  function LineItemUpdateNeeded(FromFile, ToFile: string): boolean;
  var
    fromList, toList: TStringList;
    i, idx: integer;
    line: string;
  begin
    Result := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(toFile);
      for i := 0 to fromList.Count - 1 do
      begin
        line := fromList[i];
        if trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            Result := TRUE;
            break;
          end;
        end;
      end;
    finally
      toList.Free;
      fromList.Free;
    end;
  end;

  function INIUpdateNeeded(FromFile, ToFile: string): boolean;
  var
    FromINIFile, ToINIFile: TIniFile;
    Sections, Values: TStringList;
    i, j: integer;
    section, key, val1, val2: string;
  begin
    Result := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TIniFile.Create(FromFile);
      try
        ToINIFile := TIniFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for i := 0 to Sections.count-1 do
          begin
            section := Sections[i];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(Section, key, '');
              result := (val1 <> val2);
              if Result then
                break;
            end;
            if Result then
              break;
          end;
        finally
          ToINIFile.Free;
        end;
      finally
        FromINIFile.Free;
      end;
    finally
      Sections.Free;
      Values.Free;
    end;
  end;

  function IsUseLine(data: string): boolean;
  var
    p: integer;
  begin
    Result := (copy(data,1,4) = 'use ');
    if Result then
    begin
      Result := FALSE;
      p := pos('"', data);
      if p > 0 then
      begin
        p := posEX('"', data, p+1);
        if p = length(data) then
          Result := TRUE;
      end;
    end;
  end;

  function IsFunctionLine(data: string): boolean;
  var
    p1, p2: integer;
    line: string;
  begin
    Result := FALSE;
    line := data;
    p1 := pos(' ', line);
    if (p1 > 0) then
    begin
      if copy(line,1,p1-1) = 'script' then
        Result := true
      else
      begin
        p2 := posEx(' ', line, p1+1);
        if p2 > 0 then
        begin
          line := copy(line, p1+1, p2-p1-1);
          if (line = 'function') then
            Result := TRUE;
        end;
      end;
    end;
  end;

  function CheckForUseLineAndFunction(FromFile, ToFile: string): boolean;
  var
    FromData: TStringList;
    ToData: TStringList;
    UseLine: string;
    i: integer;
    line: string;

  begin
    Result := FALSE;
    FromData := TStringList.create;
    ToData := TStringList.create;
    try
      UseLine := '';
      AppUseLine := '';
      AppStartFunctionLine := -1;
      FromData.LoadFromFile(FromFile);
      for i := 0 to FromData.Count - 1 do
      begin
        line := lowerCase(trim(FromData[i]));
        if (UseLine = '') and IsUseLine(line) then
        begin
          UseLine := line;
          AppUseLine := FromData[i];
        end
        else
        if (AppStartFunctionLine < 0) and IsFunctionLine(line) then
          AppStartFunctionLine := i;
        if (UseLine <> '') and (AppStartFunctionLine >= 0) then break;
      end;
      if (UseLine = '') or (AppStartFunctionLine < 0) then exit;

      AppNeedsUseLine := TRUE;
      AppScriptNeedsFunction := TRUE;
      ToData.LoadFromFile(ToFile);
      for i := 0 to ToData.Count - 1 do
      begin
        line := lowerCase(trim(ToData[i]));
        if AppNeedsUseLine and IsUseLine(line) and (line = UseLine) then
          AppNeedsUseLine := FALSE
        else
        if AppScriptNeedsFunction and IsFunctionLine(line) then
            AppScriptNeedsFunction := FALSE;
        if (not AppNeedsUseLine) and (not AppScriptNeedsFunction) then break;
      end;
      if AppNeedsUseLine or AppScriptNeedsFunction then
        Result := TRUE;
    finally
      FromData.free;
      ToData.free;
    end;
  end;

  function UpdateNeeded(FromFile, ToFile: string; CompareType: TCompareType): boolean;
  begin
    Result := TRUE;
    try
      case CompareType of
        jcScriptMerge: Result := CheckForUseLineAndFunction(FromFile, ToFile);
        jcPrior:       Result := LastFileUpdated;
        jcVersion:     Result := VersionDifferent(FromFile, ToFile);
        jcINI:         Result := INIUpdateNeeded(FromFile, ToFile);
        jcLineItems:   Result := LineItemUpdateNeeded(FromFile, ToFile);
      end;
    except
      on E: Exception do
        FJAWSFileError := E.Message;
    end;
  end;

  procedure INIFileUpdate(FromFile, ToFile: String);
  var
    FromINIFile, ToINIFile: TIniFile;
    Sections, Values: TStringList;
    i, j: integer;
    section, key, val1, val2: string;
    modified: boolean;
  begin
    modified := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TIniFile.Create(FromFile);
      try
        ToINIFile := TIniFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for i := 0 to Sections.count-1 do
          begin
            section := Sections[i];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(Section, key, '');
              if (val1 <> val2) then
              begin
                ToINIFile.WriteString(section, key, val1);
                modified := TRUE;
              end;
            end;
          end;
        finally
          if modified then
            ToINIFile.UpdateFile();
          ToINIFile.Free;
        end;
      finally
        FromINIFile.Free;
      end;
    finally
      Sections.Free;
      Values.Free;
    end;
  end;

  procedure LineItemFileUpdate(FromFile, ToFile: string);
  var
    fromList, toList: TStringList;
    i, idx: integer;
    line: string;
    modified: boolean;
  begin
    modified := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(toFile);
      for i := 0 to fromList.Count - 1 do
      begin
        line := fromList[i];
        if trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            toList.Add(line);
            modified := TRUE;
          end;
        end;
      end;
    finally
      if Modified then
        toList.SaveToFile(ToFile);
      toList.Free;
      fromList.Free;
    end;
  end;

  procedure DeleteCompiledFile(ToFile: string);
  var
    CompiledFile: string;
  begin
    CompiledFile := copy(ToFile, 1, length(ToFile) - length(ExtractFileExt(ToFile)));
    CompiledFile := CompiledFile + CompiledScriptFileExtension;
    if FileExists(CompiledFile) then
    begin
      MakeFileWritable(CompiledFile);
      DeleteFile(PChar(CompiledFile));
    end;
  end;

  function DoScriptMerge(FromFile, ToFile: string): boolean;
  var
    BackupFile: string;
    FromData: TStringList;
    ToData: TStringList;
    i, idx: integer;
    ExitCode: integer;
  begin
    Result := TRUE;
    BackupFile := ToFile + '.BACKUP';
    if FileExists(BackupFile) then
    begin
      MakeFileWritable(BackupFile);
      DeleteFile(PChar(BackupFile));
    end;
    DeleteCompiledFile(ToFile);
    CopyFile(PChar(ToFile), PChar(BackupFile), FALSE);
    MakeFileWritable(ToFile);
    FromData := TStringList.create;
    ToData := TStringList.create;
    try
      ToData.LoadFromFile(ToFile);
      if AppNeedsUseLine then
        ToData.Insert(0, AppUseLine);
      if AppScriptNeedsFunction then
      begin
        FromData.LoadFromFile(FromFile);
        ToData.Insert(1,'');
        idx := 2;
        for i := AppStartFunctionLine to FromData.Count - 1 do
        begin
          ToData.Insert(idx, FromData[i]);
          inc(idx);
        end;
        ToData.Insert(idx,'');
      end;
      if not assigned(JAWSAPI) then
        JAWSAPI := CoJawsApi.Create;
      ToData.SaveToFile(ToFile);
      ExitCode := ExecuteAndWait('"' + FCompiler + '"', '"' + ToFile + '"');
      JAWSAPI.StopSpeech;
      if ExitCode = 0 then // compile succeeded!
        ReloadConfiguration
      else
        Result := FALSE; // compile failed - just copy the new one
    finally
      FromData.free;
      ToData.free;
    end;
  end;
  
  procedure UpdateFile(FromFile, ToFile: string; info: TFileInfo);
  var
    DoCopy: boolean;
    error: boolean;
    CheckOverwrite: boolean;
  begin
    DoCopy := FALSE;
    if FileExists(ToFile) then
    begin
      MakeFileWritable(ToFile);
      CheckOverwrite := TRUE;
      try
        case info.CompareType of
          jcScriptMerge: if not DoScriptMerge(FromFile, ToFile) then DoCopy := TRUE;
          jcPrior, jcVersion: DoCopy := TRUE;
          jcINI: INIFileUpdate(FromFile, ToFile);
          jcLineItems: LineItemFileUpdate(FromFile, ToFile);
        end;
      except
        on E: Exception do
          FJAWSFileError := E.Message;
      end;
    end
    else
    begin
      CheckOverwrite := FALSE;
      DoCopy := TRUE;
    end;
    if DoCopy then
    begin
      error := FALSE;
      if not CopyFile(PChar(FromFile), PChar(Tofile), FALSE) then
        error := TRUE;
      if (not error) and (not FileExists(ToFile)) then
        error := TRUE;
      if (not error) and CheckOverwrite and (info.CompareType <> jcPrior) and
        UpdateNeeded(FromFile, ToFile, info.CompareType) then
        error := TRUE;
      if error and (not FileErrorExists) then
        FJAWSFileError := 'Error copying "' + FromFile + '" to' + CRLF + '"' + ToFile + '".';
      if (not error) and (info.Compile) then
      begin
        DeleteCompiledFile(ToFile);
        CompileCommands.Add('"' + ToFile + '"');
      end;     
    end;
  end;

  procedure EnsureJAWSScriptsAreUpToDate;
  var
    DestFile, FromFile, ToFile, AppName, ext: string;
    idx1, idx2, i: integer;
    DoUpdate: boolean;
    info: TFileInfo;

  begin
    AppName := ExtractFileName(ParamStr(0));
    ext := ExtractFileExt(AppName);
    AppName := LeftStr(AppName, length(AppName) - Length(ext));
    DestPath := '';
    idx1 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, FUserStriptDir);
    idx2 := pos(JAWS_COMMON_SCRIPT_PATH_TEXT, FDefaultScriptDir);
    if (idx1 > 0) and (idx2 > 0) then
    begin
      DestPath := copy(FUserStriptDir,1,idx1-1) + copy(FDefaultScriptDir, idx2, MaxInt);
      DestFile := DestPath + AppName;
      FDictionaryFileName := DestFile + DictionaryFileExtension;
      FConfigFile := DestFile + ConfigFileExtension;
      FKeyMapFile := DestFile + KeyMapExtension;
      LastFileUpdated := FALSE;
      for i := low(FileInfo) to high(FileInfo) do
      begin
        info := FileInfo[i];
        if info.AppFile then
        begin
          FromFile := FRootScriptAppFileName + info.Ext;
          ToFile := DestFile + info.Ext;
        end
        else
        begin
          FromFile := FRootScriptFileName + info.Ext;
          ToFile := DestPath + JAWS_SCRIPT_NAME + info.Ext;
        end;
        if not FileExists(FromFile) then continue;
        if FileExists(ToFile) then
        begin
          DoUpdate := UpdateNeeded(FromFile, ToFile, info.CompareType);
          if DoUpdate then
            MakeFileWritable(ToFile);
        end
        else
          DoUpdate := TRUE;
        LastFileUpdated := DoUpdate;
        if DoUpdate and (not FileErrorExists) then
        begin
          UpdateFile(FromFile, ToFile, info);
          ScriptFileChanges := TRUE;
        end;
        if FileErrorExists then
          break;
      end;
    end
    else
      FJAWSFileError := 'Unknown File Error'; // should never happen - condition checked previously
  end;

  procedure DoCompiles;
  var
    i: integer;
  begin
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;
    for i := 0 to CompileCommands.Count - 1 do
    begin
      ExecuteAndWait('"' + FCompiler + '"', CompileCommands[i]);
      JAWSAPI.StopSpeech;
    end;
    ReloadConfiguration;
  end;

begin
  Result := FALSE;
  ScriptFileChanges := FALSE;
  if JAWSManager.RequiredFilesFound then
  begin
    FJAWSFileError := '';
    CompileCommands := TStringList.Create;
    try
      EnsureJAWSScriptsAreUpToDate;
      if CompileCommands.Count > 0 then
        DoCompiles;
    finally
      CompileCommands.Free;
    end;
    if FileErrorExists then
      ShowError(JAWS_ERROR_FILE_IO, [FJAWSFileError])
    else if JAWSTalking2CurrentUser then
    begin
      EnsureWindow;
      LaunchMasterApplication;
      if ScriptFileChanges then
      begin
        FMainForm.ConfigReloadNeeded;
      end;
      Result := TRUE;
    end;
  end;
end;

class function TJAWSManager.IsRunning(HighVersion, LowVersion: Word): BOOL;

  function ComponentVersionSupported: boolean;
  var
    SupportedHighVersion, SupportedLowVersion: integer;
    FileName, newVersion, convertedVersion, currentVersion: string;
    addr: pointer;

  begin
    addr := @TJAWSManager.IsRunning;
    FileName := GetDLLFileName(addr);
    currentVersion := FileVersionValue(FileName, FILE_VER_FILEVERSION);
    VersionStringSplit(currentVersion, SupportedHighVersion, SupportedLowVersion);
    Result := FALSE;
    if (HighVersion < SupportedHighVersion) then
      Result := TRUE
    else
    if (HighVersion = SupportedHighVersion) and
       (LowVersion <= SupportedLowVersion) then
      Result := TRUE;
    if not Result then
    begin
      newVersion := IntToStr(HighVersion) + '.' + IntToStr(LowVersion);
      convertedVersion := IntToStr(SupportedHighVersion) + '.' + IntToStr(SupportedLowVersion);
      ShowError(DLL_ERROR_VERSION, [newVersion, convertedVersion]);
    end;
  end;

begin
  Result := (GetJAWSWindow <> 0);
  if Result then
    Result := ComponentVersionSupported;
  if Result then
    Result := JAWSVersionOK;
  if Result then
  begin
    EnsureManager;
    with JAWSManager do
      Result := RequiredFilesFound;
  end;
end;

class function TJAWSManager.JAWSTalking2CurrentUser: boolean;
var
  CurrentUserPath: string;
  WhatJAWSThinks: string;

  procedure Fix(var path: string);
  var
    idx: integer;
  begin
    idx := pos(APP_DATA, lowercase(path));
    if idx > 0 then
      path := LeftStr(path,idx-1);
    idx := length(path);
    while (idx > 0) and (path[idx] <> '\') do dec(idx);
    delete(path,1,idx);
  end;

  function UserProblemExists: boolean;
  begin
    CurrentUserPath := GetSpecialFolderPath(CSIDL_APPDATA);
    WhatJAWSThinks := GetPathFromJAWS(JAWS_PATH_ID_USER_SCRIPT_FILES, FALSE);
    fix(CurrentUserPath);
    fix(WhatJAWSThinks);
    Result := (lowercase(CurrentUserPath) <> lowercase(WhatJAWSThinks));
  end;

begin
  if UserProblemExists then
  begin
    ShowError(JAWS_ERROR_USER_PROBLEM);
    Result := FALSE;
  end
  else
    Result := TRUE;
end;

class function TJAWSManager.JAWSVersionOK: boolean;
var
  JFileVersion: string;
  JFile: string;

  function OlderVersionOKIfCOMObjectInstalled: boolean;
  var
    api: IJawsApi;
  begin
    Result := VersionOK(JAWS_REQUIRED_VERSION, JFileVersion);
    if Result then
    begin
      try
        try
          api := CoJawsApi.Create;
        except
          Result := FALSE;
        end;
      finally
        api := nil;
      end;
    end;
  end;

begin
  JFile := GetPathFromJAWS(JAWS_PATH_ID_APPLICATION);//JAWS_PATH_ID_USER_SCRIPT_FILES);
  JFile := AppendBackSlash(JFile) + JAWS_APPLICATION_FILENAME;
  if FileExists(JFile) then
  begin
    JFileVersion := FileVersionValue(JFile, FILE_VER_FILEVERSION);
    Result := VersionOK(JAWS_COM_OBJECT_VERSION, JFileVersion);
    if not Result then
      Result := OlderVersionOKIfCOMObjectInstalled;
  end
  else
  begin
// if file not found, then assume a future version where the exe was moved
// to a different location  
    Result := TRUE;
  end;
  if not Result then
    ShowError(JAWS_ERROR_VERSION);
end;

procedure TJAWSManager.KillINIFiles(Sender: TObject);
begin
  if assigned(FDictionaryFile) then
  begin
    if FDictionaryFileModified then
    begin
      MakeFileWritable(FDictionaryFileName);
      FDictionaryFile.SaveToFile(FDictionaryFileName);
    end;
    FreeAndNil(FDictionaryFile);
  end;

  if assigned(FConfigINIFile) then
  begin
    if FConfigINIFileModified then
    begin
      FConfigINIFile.UpdateFile;
    end;
    FreeAndNil(FConfigINIFile);
  end;

  if assigned(FKeyMapINIFile) then
  begin
    if FKeyMapINIFileModified then
    begin
      FKeyMapINIFile.UpdateFile;
    end;
    FreeAndNil(FKeyMapINIFile);
  end;

  if assigned(FAssignedKeys) then
    FreeAndNil(FAssignedKeys);
end;

procedure TJAWSManager.LaunchMasterApplication;
begin
  if FileExists(FMasterApp) then
    ShellExecute(0, PChar('open'), PChar(FMasterApp), nil,
                    PChar(ExtractFilePath(FMasterApp)), SW_SHOWNA);
end;


procedure TJAWSManager.RegisterCustomBehavior(Before, After: string;
  Action: integer);

const
  WindowClassesSection = 'WindowClasses';
  MSAAClassesSection = 'MSAAClasses';
  DICT_DELIM: char = Char($2E);
  CommonKeysSection = 'Common Keys';
  CustomCommandHelpSection = 'Custom Command Help';
  KeyCommand = 'VA508SendCustomCommand(';
  KeyCommandLen = length(KeyCommand);

var
  modified: boolean;

  procedure Add2INIFile(var INIFile: TINIFile; var FileModified: boolean;
                        FileName, SectionName, Data, Value: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    OldValue := INIFile.ReadString(SectionName, Data, '');
    if OldValue <> Value then
    begin
      INIFile.WriteString(SectionName, Data, Value);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RemoveFromINIFile(var INIFile: TINIFile; var FileModified: boolean;
                                FileName, SectionName, Data: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    OldValue := INIFile.ReadString(SectionName, Data, '');
    if OldValue <> '' then
    begin
      INIFile.DeleteKey(SectionName, Data);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RegisterCustomClassChange;
  begin
    Add2INIFile(FConfigINIFile, FConfigINIFileModified, FConfigFile,
                  WindowClassesSection, Before, After);
  end;

  procedure RegisterMSAAClassChange;
  begin
    Add2INIFile(FConfigINIFile, FConfigINIFileModified, FConfigFile,
                  MSAAClassesSection, Before, '1');
  end;

  procedure RegisterCustomKeyMapping;
  begin
    Add2INIFile(FKeyMapINIFile, FKeyMapINIFileModified, FKeyMapFile,
                  CommonKeysSection, Before, KeyCommand + after + ')');
    if not assigned(FAssignedKeys) then
      FAssignedKeys := TStringList.Create;
    FAssignedKeys.Add(Before);
  end;

  procedure RegisterCustomKeyDescription;
  begin
    Add2INIFile(FConfigINIFile, FConfigINIFileModified, FConfigFile,
                  CustomCommandHelpSection, Before, After);
  end;

  procedure DecodeLine(line: string; var before1, after1: string);
  var
    i, j, len: integer;
  begin
    before1 := '';
    after1 := '';
    len := length(line);
    if (len < 2) or (line[1] <> DICT_DELIM) then exit;
    i := 2;
    while (i < len) and (line[i] <> DICT_DELIM) do inc(i);
    before1 := copy(line,2,i-2);
    j := i + 1;
    while (j <= len) and (line[j] <> DICT_DELIM) do inc(j);
    after1 := copy(line,i+1,j-i-1);
  end;

  procedure RegisterCustomDictionaryChange;
  var
    i, idx: integer;
    line, before1, after1: string;
    add: boolean;
  begin
    if not assigned(FDictionaryFile) then
    begin
      FDictionaryFile := TStringList.Create;
      FDictionaryFileModified := FALSE;
      if FileExists(FDictionaryFileName) then
        FDictionaryFile.LoadFromFile(FDictionaryFileName);
    end;

    add := TRUE;
    idx := -1;
    for I := 0 to FDictionaryFile.Count - 1 do
    begin
      line := FDictionaryFile[i];
      DecodeLine(line, before1, after1);
      if (before1 = Before) then
      begin
        idx := i;
        if after1 = after then
          add := false;
        break;
      end;
    end;
    if add then
    begin
      line := DICT_DELIM + Before + DICT_DELIM + after + DICT_DELIM;
      if idx < 0 then
        FDictionaryFile.Add(line)
      else
        FDictionaryFile[idx] := line;
      modified := TRUE;
      FDictionaryFileModified := TRUE;
    end;
  end;

  procedure RemoveComponentClass;
  begin
    RemoveFromINIFile(FConfigINIFile, FConfigINIFileModified, FConfigFile,
                  WindowClassesSection, Before);
  end;

  procedure RemoveMSAAClass;
  begin
    RemoveFromINIFile(FConfigINIFile, FConfigINIFileModified, FConfigFile,
                  MSAAClassesSection, Before);
  end;

  procedure PurgeKeyMappings;
  var
    i: integer;
    name, value: string;
    keys: TStringList;
    delete: boolean;
  begin
    if not assigned(FKeyMapINIFile) then
    begin
      MakeFileWritable(FKeyMapFile);
      FKeyMapINIFile := TINIFile.Create(FKeyMapFile);
      FKeyMapINIFileModified := FALSE;
    end;
    keys := TStringList.Create;
    try
      FKeyMapINIFile.ReadSectionValues(CommonKeysSection, keys);
      for i := keys.Count - 1 downto 0 do
      begin
        value := copy(keys.ValueFromIndex[i],1,KeyCommandLen);
        if value = KeyCommand then
        begin
          name := keys.Names[i];
          delete := (not assigned(FAssignedKeys));
          if not delete then
            delete := (FAssignedKeys.IndexOf(name) < 0);
          if delete then
          begin
            FKeyMapINIFile.DeleteKey(CommonKeysSection, name);
            FKeyMapINIFileModified := TRUE;
            modified := TRUE;
          end;
        end;
      end;
    finally
      keys.Free;
    end;
  end;

begin
{ TODO : check file io errors when updating config files }
  modified := FALSE;
  case Action of
    BEHAVIOR_ADD_DICTIONARY_CHANGE:           RegisterCustomDictionaryChange;
    BEHAVIOR_ADD_COMPONENT_CLASS:             RegisterCustomClassChange;
    BEHAVIOR_ADD_COMPONENT_MSAA:              RegisterMSAAClassChange;
    BEHAVIOR_ADD_CUSTOM_KEY_MAPPING:          RegisterCustomKeyMapping;
    BEHAVIOR_ADD_CUSTOM_KEY_DESCRIPTION:      RegisterCustomKeyDescription;
    BEHAVIOR_REMOVE_COMPONENT_CLASS:          RemoveComponentClass;
    BEHAVIOR_REMOVE_COMPONENT_MSAA:           RemoveMSAAClass;
    BEHAVIOR_PURGE_UNREGISTERED_KEY_MAPPINGS: PurgeKeyMappings;
  end;
  if modified and assigned(FMainForm) then
  begin
    FMainForm.ResetINITimer(KillINIFiles);
    FMainForm.ConfigReloadNeeded;
  end;
end;

procedure TJAWSManager.ReloadConfiguration;
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.RunFunction('ReloadAllConfigs');
end;

procedure TJAWSManager.SendComponentData(WindowHandle: HWND; DataStatus: LongInt; Caption, Value,
            Data, ControlType, State, Instructions, ItemInstructions: PChar);

  procedure SendRequestResponse;
  begin
    FMainForm.WriteData(VA508_REG_COMPONENT_CAPTION, Caption);
    FMainForm.WriteData(VA508_REG_COMPONENT_VALUE, Value);
    FMainForm.WriteData(VA508_REG_COMPONENT_CONTROL_TYPE, ControlType);
    FMainForm.WriteData(VA508_REG_COMPONENT_STATE, State);
    FMainForm.WriteData(VA508_REG_COMPONENT_INSTRUCTIONS, Instructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_ITEM_INSTRUCTIONS, ItemInstructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_DATA_STATUS, IntToStr(DataStatus));
    FMainForm.PostData;
  end;

  procedure SendChangeEvent;
  var
    Event: WideString;
  begin
    Event := 'VA508ChangeEvent(' + IntToStr(WindowHandle)   +  ',' +
                                   IntToStr(DataStatus)     +  ',"' +
                                   StrPas(Caption)          + '","' +
                                   StrPas(Value)            + '","' +
                                   StrPas(ControlType)      + '","' +
                                   StrPas(State)            + '","' +
                                   StrPas(Instructions)     + '","' +
                                   StrPas(ItemInstructions) + '"';
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;
    JAWSAPI.RunFunction(Event)
  end;

begin
  if (Data <> nil) and (Length(Data) > 0) then
  begin
    Value := Data;
    DataStatus := DataStatus AND DATA_MASK_DATA;
    DataStatus := DataStatus OR DATA_VALUE;
  end;
  if (DataStatus and DATA_CHANGE_EVENT) <> 0 then
  begin
    DataStatus := DataStatus AND DATA_MASK_CHANGE_EVENT;
    SendChangeEvent;
  end
  else
    SendRequestResponse;
end;

const
  MAX_REG_CHARS = 125; // When Jaws reads over 126 chars it returns a blank string
  MORE_STRINGS = '+';
  LAST_STRING = '-';
  MAX_COUNT_KEY = 'Max';

class procedure TJAWSManager.ShowError(ErrorNumber: integer);
begin
  ShowError(ErrorNumber, []);
end;

class procedure TJAWSManager.ShowError(ErrorNumber: integer; data: array of const);
var
  error: string;

begin
  if not JAWSErrorsShown[ErrorNumber] then
  begin
    error := JAWSErrorMessage[ErrorNumber];
    if length(data) > 0 then
      error := Format(error, data);
    JAWSErrorsShown[ErrorNumber] := TRUE;
    MessageBox(0, PChar(error), 'JAWS Accessibility Component Error',
          MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_TOPMOST);
  end;
end;

procedure TJAWSManager.ShutDown;
begin
  if FWasShutdown then exit;
  if assigned(JAWSAPI) then
  begin
    try
      JAWSAPI := nil; // causes access violation
    except
    end;
  end;
  KillINIFiles(nil);
  if assigned(FMainForm) then
    FreeAndNil(FMainForm);
  FWasShutdown := TRUE;
end;

procedure TJAWSManager.SpeakText(Text: PChar);
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.SayString(Text, FALSE);
end;


initialization
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

finalization
  ShutDown;
  CoUninitialize;

end.
