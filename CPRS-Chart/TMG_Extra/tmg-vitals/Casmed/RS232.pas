unit RS232;
//******************************************************************************
//  uses only this unit (RS232) and ATE740X:   Use ATE740X calls only.
//  TODO:  1)  Determine XON XOFF capabilities.
//         2)  Tighten FNewComPortTimeOuts settings.
//         3)  Determine if Exception messages here are really necessary.
//******************************************************************************

interface

uses
  Windows, SysUtils, Dialogs;

//******************************************************************************
type
  TCharArray = array[0..25] of Char;

  TComPort = class(TObject)
  private
    { Private declarations }
    FComPortName: string;
    FComPortHandle: THandle;
    FPreviousComPort: TDCB;
    FNewComPort: TDCB;
    FPreviousComPortTimeouts: TCommTimeouts;
    FNewComPortTimeOuts: TCommTimeouts;
    FComPortInputBuffer: TCharArray;  //????
    FCommandResults: string;
  public
    { Public declarations }
    property ComPortname:String read FComPortName;
    function Open: boolean;
    function GetPreviousComPortSettings: boolean;
    function SetNewComPortSettings: boolean;
    function Config: boolean;
    function Read(NumberOfBytesExpected: integer): boolean;
    function Write(Command: string): boolean;
    function Purge: boolean;
    property CommandResults: string read FCommandResults write FCommandResults;
    procedure Close;
    constructor Create;
  end;
//******************************************************************************
var
  ComPort: TComPort;

const
//  buffer sizes  ------------------------------
    RX_BUFFER_SIZE = 1024;
    TX_BUFFER_SIZE = 1024;
//  CAS 740X COMM PROTOCOLS  -------------------
    CAS_COMM_PROTOCOL_BAUD      = CBR_115200; //  115200 Baud
    CAS_COMM_PROTOCOL_FLAGS     = $0001;      //  FLAGS >> binary only.
    CAS_COMM_PROTOCOL_DATA_BITS = DATABITS_8; //  8 DataBits
    CAS_COMM_PROTOCOL_PARITY    = NOPARITY;   //  No Parity
    CAS_COMM_PROTOCOL_STOP_BIT  = ONESTOPBIT; //  1 Stop Bit
//----------------------------------------------

implementation

//******************************************************************************
constructor TComPort.Create;
begin
  inherited Create;
  FComPortHandle := INVALID_HANDLE_VALUE;
end;
//******************************************************************************
function TComPort.Open: boolean;
begin
  FComPortName := 'COM1';
//----------------------------------------------
  FComPortHandle := CreateFile(pchar(FComPortName),
                    GENERIC_READ or GENERIC_WRITE,
                    0,                      //  Exclusive. (No Sharing)
                    nil,                    //  No inheritance.
                    OPEN_EXISTING,          //  Devices use OPEN_EXISTING.
                    FILE_ATTRIBUTE_NORMAL,  //  Devices use FILE_ATTRIBUTE_NORMAL.
                    0);                     //  Devices use No hTemplateFile.
//----------------------------------------------
  if (FComPortHandle <> INVALID_HANDLE_VALUE) then
  begin
    if (GetPreviousComPortSettings) then
      if (SetNewComPortSettings) then
        result := TRUE
      else
        result := FALSE   //  failed to SetCommTimeouts
    else
      result := FALSE     //  failed to GetCommTimeouts/GetCommState
  end else
  begin
    FComPortName := 'COM2';
//----------------------------------------------
    FComPortHandle := CreateFile(pchar(FComPortName),
                      GENERIC_READ or GENERIC_WRITE,
                      0,                      //  Exclusive. (No Sharing)
                      nil,                    //  No inheritance.
                      OPEN_EXISTING,          //  Devices use OPEN_EXISTING.
                      FILE_ATTRIBUTE_NORMAL,  //  Devices use FILE_ATTRIBUTE_NORMAL.
                      0);                     //  Devices use No hTemplateFile.
//----------------------------------------------
    if (FComPortHandle <> INVALID_HANDLE_VALUE) then
    begin
      if (GetPreviousComPortSettings) then
        if (SetNewComPortSettings) then
          result := TRUE
        else
          result := FALSE   //  failed to SetCommTimeouts
      else
        result := FALSE     //  failed to GetCommTimeouts/GetCommState
    end else
    begin
      Exception.Create('COM PORT ERROR: CreateFile failed.');
      result := FALSE;      //  failed to GetHandle.
      exit;
    end;
  end;
end;
//******************************************************************************
function TComPort.GetPreviousComPortSettings: boolean;
begin
  if not GetCommState(FComPortHandle, FPreviousComPort) then
  begin
    Exception.Create('COM PORT ERROR: GetCommState failed. (previous settings)');
    result := FALSE;
    exit;
  end;
  if not GetCommTimeouts(FComPortHandle, FPreviousComPortTimeouts) then
  begin
    Exception.Create('COM PORT ERROR: GetCommTimeouts failed.');
    result := FALSE;
    exit;
  end;
  result := TRUE;
end;
//******************************************************************************
function TComPort.SetNewComPortSettings: boolean;
begin
  result := TRUE;
  with FNewComPortTimeOuts do
  begin
    ReadIntervalTimeout := 200;
    ReadTotalTimeoutMultiplier := 0;
    ReadTotalTimeoutConstant := 0;
    WriteTotalTimeoutMultiplier := 0;
    WriteTotalTimeoutConstant := 0;
  end;
  if not SetCommTimeouts(FComPortHandle, FNewComPortTimeOuts) then
  begin
    Exception.Create('COM PORT ERROR: SetCommTimeouts failed.');
    result := FALSE;
    exit;
  end;
end;
//******************************************************************************
function TComPort.Config: boolean;
begin
  result := FALSE;

  if not GetCommState(FComPortHandle, FNewComPort) then
    Exception.Create('COM PORT ERROR: GetCommState failed. (config)');

  with FNewComPort do
  begin
    DCBLength := sizeof(TDCB);
    BaudRate  := CAS_COMM_PROTOCOL_BAUD;
    Flags     := CAS_COMM_PROTOCOL_FLAGS;
    ByteSize  := CAS_COMM_PROTOCOL_DATA_BITS;
    Parity    := CAS_COMM_PROTOCOL_PARITY;
    StopBits  := CAS_COMM_PROTOCOL_STOP_BIT;
  end;

  if not SetCommState(FComPortHandle, FNewComPort) then
    Exception.Create('COM PORT ERROR: SetCommState failed.');

  if not SetupComm(FComPortHandle, RX_BUFFER_SIZE, TX_BUFFER_SIZE) then
    Exception.Create('COM PORT ERROR: SetupComm failed.');

  result := (FComPortHandle <> INVALID_HANDLE_VALUE);
end;
//******************************************************************************
function TComPort.Purge: boolean;
begin
  result := PurgeComm(FComPortHandle, PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR);
end;
//******************************************************************************
function TComPort.Read(NumberOfBytesExpected: integer): boolean;
var
  ComPortError, BytesRead: DWORD;
  ComPortStat: TComStat;
begin
//  Sleep(1);  //  This seems to alieveate hangs...
  ClearCommError(FComPortHandle, ComPortError, @ComPortStat);
  FCommandResults := '';

  if (ComPortStat.cbInQue > 0) then
  begin                                          //  Pull expected number of bytes...
    ReadFile(FComPortHandle, FComPortInputBuffer, NumberOfBytesExpected{ComPortStat.cbInQue}, BytesRead, nil);
    FCommandResults := FCommandResults + FComPortInputBuffer;
  end;
  result := (NumberOfBytesExpected = Length(FCommandResults));
end;
//******************************************************************************
function TComPort.Write(Command: string): boolean;
var
  BytesWritten: DWORD;
  charCommandBuffer:array[0..5] of Char;
begin
  Purge;
  StrPCopy(charCommandBuffer,Command);  //  Null terminated strings...
  WriteFile(FComPortHandle, charCommandBuffer, Length(Command), BytesWritten, nil);
  //kt //codex original -->   result := (BytesWritten = Length(Command));
  result := (BytesWritten = DWORD(Length(Command))); //kt //codex 8/30/26
end;
//******************************************************************************
procedure TComPort.Close;
begin
  if (FComPortHandle <> INVALID_HANDLE_VALUE) then
  begin
    SetCommTimeouts(FComPortHandle, FPreviousComPortTimeouts);
    SetCommState(FComPortHandle, FPreviousComPort);
    CloseHandle(FComPortHandle);
    FComPortHandle := INVALID_HANDLE_VALUE;
  end;
end;
//******************************************************************************

end.


