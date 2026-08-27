unit uGMV_Monitor;

interface
uses
   Classes,
   XMLIntf,
   XMLDoc
   ;

type
  TfReady = function:Boolean;stdcall;
  TfReset = function:Boolean;stdcall;
  TfgetBufferLength = function:integer;stdcall;
  TfgetStatus = function:PChar;stdcall;

  TResultRecord = Record
    Value:String;
    UnitsName:String;
    UnitsValue:String;
    Method:String;
    Year:String;
    Month:String;
    Day:String;
    Hour:String;
    Minute:String;
    Second:String;
  end;

  TGMV_Monitor = class(TObject)
  private
    fVendor:String;
    fModel:String;
    fSerialNumber:String;
    fSoftwareVersion:String;
    fLibraryName:String;

    fMonitorLibrary: THandle;

    fReady: TfReady;
    fReset: TfReset;
    fgetBufferLength: TfgetBufferLength;
    fgetStatus : TfgetStatus;

    rrSystolic,
    rrDiastolic,
    rrPulse,
    rrTemp,
    rrOxygen:TResultRecord;

    function getBPString:String;
    function getPulseString:String;
    function getTempString:String;
    function getTempUnitString:String;
    function getSpO2String:String;

    function getXMLString:String;
    function getDescription:String;

    procedure setUpRR(var aRR: TResultRecord;aNode:IXMLNode);
  public
    Active: Boolean;
    constructor Create;
    Destructor Destroy; override;
    procedure getData(aReset:Boolean=False);

    property Vendor: String read fVendor;
    property Model: String read fModel;
    property SerialNumber: String read fSerialNumber;
    property SoftwareVersion: String read fSoftwareVersion;

    property sBP : String read getBPString;
    property sPulse: String read getPulseString;
    property sTemp: String read getTempString;
    property sTempUnit:String read getTempUnitString; // ??
    property sSpO2:String read getSpO2String;

    property XMLString:String read getXMLString;

    property LibraryName: String read fLibraryName;

    property Description:String read getDescription;
  end;


const
  sInvalidValue = 'Invalid Value';

  tnVitals = 'Vitals';

  tnVendor = 'Vendor';
  tnModel = 'Model';
  tnSerialNumber = 'Serial_Number';
  tnResult = 'Result';

  nnTemp = 'Body_temperature';
  nnOxygen = 'Oxygen_saturation';
  nnPulse = 'Pulse';
  nnSBP = 'Systolic_blood_pressure';
  nnDBP = 'Diastolic_blood_pressure';

  nnValue = 'Value';
  nnUnits = 'Units';
  nnMethod = 'Method';
  nnTimeStamp = 'Time_stamp';

  anName = 'name';
  anYear = 'year';
  anMonth = 'month';
  anDay = 'day';
  anHour = 'hour';
  anMinute = 'minute';
  anSecond = 'second';

implementation

uses
  Windows
  , FileCTRL
  , Forms, SysUtils, uGMV_GlobalVars, uGMV_DLLCommon, uXML, Dialogs;

procedure ClearResultRecord(var aR: TResultRecord);
begin
  with aR do
    begin
      Value := '';
      UnitsName := '';
      UnitsValue := '';
      Method := '';
      Year := '';
      Month := '';
      Day := '';
      Hour := '';
      Minute := '';
      Second := '';
    end;
end;

constructor TGMV_Monitor.Create;
var
  sDir,sFN: String;
  i: Integer;
  FLB: TFileListBox;
  P: Pointer;
  DLLHandle: THandle;

begin
  inherited Create;

  fVendor := 'Unknown';
  fSoftwareVersion := 'Unknown';
  fModel := 'Unknown';
  Active := False;

  FLB := TFileListBox.Create(application);
  FLB.Parent := Application.MainForm;
  FLB.Visible := False;
  FLB.Mask := '*.dll';
  sDir := ExtractFileDir(Application.ExeName)+'\'+GMV_PlugInDir;
  try
    FLB.ApplyFilePath( sDir );
    fMonitorLibrary := 0;

    for i := 0 to FLB.Items.Count - 1 do
      begin
        sFN := sDir + '\'+ FLB.Items[i];
        FindModule(sFN,GMV_PlugInReset,DLLHandle,P);
        if Assigned(P) then
          begin
            fLibraryName := sFN;
            fMonitorLibrary:= DLLHandle;
            fReset := p;
            if fReset then
              begin
                FindModule(sFN,GMV_PlugInReady,DLLHandle,P);
                fReady := p;
  //              FindModule(sFN,GMV_PlugInReset,DLLHandle,P);
  //              fReset := P;
                FindModule(sFN,GMV_PlugInReady,DLLHandle,P);
                fgetBufferLength := P;
                FindModule(sFN,GMV_PlugInGetStatus,DLLHandle,P);
                fgetStatus := P;

                // reset device
                // get description
                // update GUI
                getData(true);
                Active := True;
                break;
              end
            else
              begin
  //              ShowMessage('Monitor is NOT READY'+#13+'Continue to search');
              end;
            FreeLibrary(DLLHandle);
            fMonitorLibrary := 0;
          end;

      end;
  except
  end;
  FLB.Free;

end;

destructor TGMV_Monitor.Destroy;
begin
  if fMonitorLibrary <> 0 then
    try
      FreeLibrary(fMonitorLibrary);
    except
    end;
  inherited;
end;

function TGMV_Monitor.getBPString:String;
begin
  Result := rrSystolic.Value + '/' + rrDiastolic.Value;
  if Result = '/' then Result := '';
end;

function TGMV_Monitor.getPulseString:String;
begin
  Result := rrPulse.Value;
end;

function TGMV_Monitor.getTempString:String;
begin
  Result := rrTemp.Value;
end;

function TGMV_Monitor.getTempUnitString:String;
begin
  Result := rrTemp.UnitsName;
end;

function TGMV_Monitor.getSpO2String:String;
begin
  Result := rrOxygen.Value;
end;

function TGMV_Monitor.getXMLString:String;
begin
  Result := '';
  try // Ready always reaturns False
    if not Assigned(fReady) then Exit;
    if fReady then
      Result := fGetStatus
    else
      Result := '';
//    if not Assigned(fReset) then Exit;
//    fReset;
  except
  end;
end;

procedure TGMV_Monitor.setUpRR(var aRR: TResultRecord;aNode:IXMLNode);
begin
  ClearResultRecord(aRR);
  with aRR do
    begin
      try  Value := aNode.ChildNodes[nnValue].Text;  except on E: Exception do ShowMessage('Setup RR Value:'+#13#10+E.Message); end;
      try UnitsName := aNode.ChildNodes[nnUnits].GetAttribute(anName); except on E: Exception do ShowMessage('Setup RR Units Name:'+#13#10+E.Message); end;
      try  UnitsValue := aNode.ChildNodes[nnUnits].Text; except on E: Exception do ShowMessage('Setup RR Units Value:'+#13#10+E.Message); end;
      try  Method := aNode.ChildNodes[nnMethod].Text; except on E: Exception do ShowMessage('Setup RR Method:'+#13#10+E.Message); end;

      try  Year := aNode.ChildNodes[nnTimeStamp].GetAttribute(anYear); except on E: Exception do ShowMessage('Setup RR Year:'+#13#10+E.Message); end;
      try  Month := aNode.ChildNodes[nnTimeStamp].GetAttribute(anMonth);       except on E: Exception do ShowMessage('Setup RR Month :'+#13#10+E.Message); end;
      try  Day := aNode.ChildNodes[nnTimeStamp].GetAttribute(anDay);       except on E: Exception do ShowMessage('Setup RR day:'+#13#10+E.Message); end;
      try Hour := aNode.ChildNodes[nnTimeStamp].GetAttribute(anHour);       except on E: Exception do ShowMessage('Setup RR Hour:'+#13#10+E.Message); end;
      try  Minute := aNode.ChildNodes[nnTimeStamp].GetAttribute(anMinute);  except on E: Exception do ShowMessage('Setup RR Minute:'+#13#10+E.Message); end;
      try  Second := aNode.ChildNodes[nnTimeStamp].GetAttribute(anSecond);   except on E: Exception do ShowMessage('Setup RR Second:'+#13#10+E.Message); end;
    end;
end;

procedure TGMV_Monitor.getData(aReset:Boolean=False);
var
  xDOC:IXMLDocument;
  xxNode,
  xNode: IXMLNode;
  s,ss: String;
  i: Integer;

begin
  s := XMLString;
  if s = '' then
    begin
      ClearResultRecord(rrSystolic);
      ClearResultRecord(rrDiastolic);
      ClearResultRecord(rrPulse);
      ClearResultRecord(rrTemp);
      ClearResultRecord(rrOxygen);
      Exit;
    end;

  xDOC := XMLDocument(s);
  xNode := xDoc.ChildNodes[tnVitals];
  if Assigned(xNode) then
    begin
      if aReset then
        begin
          fVendor := xNode.ChildNodes[tnVendor].Text;
          fModel := xNode.ChildNodes[tnModel].Text;
          fSerialNumber  := xNode.ChildNodes[tnSerialNumber].Text;
//      fSoftwareVersion  := xNode.ChildNodes[tnVendor];
        end;
      for i := 0 to xNode.ChildNodes.Count - 1 do
        begin
          xxNode := xNode.ChildNodes[i];
          if xxNode.Nodename = tnResult then
            begin
              try
                ss := xxNode.GetAttribute(anName);
                if ss = nnPulse then  setUpRR(rrPulse,xxNode);
                if ss = nnTemp then   setUpRR(rrTemp,xxNode);
                if ss = nnOxygen then setUpRR(rrOxygen,xxNode);
                if ss = nnSBP then    setUpRR(rrSystolic,xxNode);
                if ss = nnDBP then    setUpRR(rrDiastolic,xxNode);
              except
                on E: Exception do
                  ShowMessage('Get Data:'+#13#10+E.Message);
              end;
            end;
        end;
    end;
  fReset; // reset is the part of the protocol
end;

function TGMV_Monitor.getDescription:String;
begin
  Result :=
     fVendor + '  '+fModel+ ' (SN: '+fSerialNumber+')'+#13+
     '_____________________________'+#13+#13+
     'Software: '+fSoftwareVersion;

end;

end.

