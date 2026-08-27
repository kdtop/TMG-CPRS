unit fGMV_Allergies;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 5/21/03 1:19p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Allergy display form
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_Allergies.pas $
*
* $History: fGMV_Allergies.pas $
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
 * User: Vhaishandria Date: 5/21/03    Time: 1:17p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 6/13/02    Time: 5:13p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 11:52a
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
  StdCtrls,
  uGMV_Common;

type
  TfrmGMV_Allergies = class(TForm)
    btnClose: TButton;
    memResults: TMemo;
    lbResults: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowPatientAllergies(const PatientDFN: string);

implementation

{$R *.DFM}

procedure ShowPatientAllergies(const PatientDFN: string);
begin
  with TfrmGMV_Allergies.Create(Application) do
  try
    CallServer(GMVBroker, 'GMV ALLERGY', [PatientDFN], nil, RetList);
//AAN 06/12/02    memResults.Lines.Assign(RetList);
    lbResults.Items.Assign(RetList);//AAN 06/12/02
    ShowModal;
  finally
    free;
  end;
end;

end.
