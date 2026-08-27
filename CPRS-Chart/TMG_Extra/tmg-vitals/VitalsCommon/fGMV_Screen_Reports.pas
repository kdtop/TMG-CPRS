unit fGMV_Screen_Reports;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 5/21/03 1:19p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Generic form for print to screen functions.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_Screen_Reports.pas $
*
* $History: fGMV_Screen_Reports.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 12:06p
 * Created in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  TRPCb,
  ComCtrls,
  uGMV_Common;

type
  TfrmGMV_ScreenRPT = class(TForm)
    Button1: TButton;
    Bevel2: TBevel;
    Button3: TButton;
    RichEdit1: TRichEdit;
    Font: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Patient: string;
    StartDate, Enddate, Ward, Room: string;
    RPCBroker1: TRPCBroker;
    ReportNumber: Integer;
  end;

var
  frmGMV_ScreenRPT: TfrmGMV_ScreenRPT;

procedure PrintScreenReport(PatientDFN: string; ReportNumber: Integer);

implementation

{$R *.DFM}

procedure PrintScreenReport(PatientDFN: string; ReportNumber: Integer);
begin
end;

procedure TfrmGMV_ScreenRPT.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.

