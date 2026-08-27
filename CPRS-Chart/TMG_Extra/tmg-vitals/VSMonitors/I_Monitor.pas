unit I_Monitor;

interface

type
  I_SVSM = interface
  ['{C009F7A3-8EAA-47BA-BDBB-D12092587AF6}']
    function checkReadiness:Boolean;stdcall;
    function resetMonitor:Boolean;stdcall;
    function getBufferLength:integer;stdcall;
    function getState:PChar;stdcall;

    function getVendorName:String;
    function getModel:String;
    function getSerialNumber:String;
    function getResultByName(aName:String):String;
  end;

implementation

end.
