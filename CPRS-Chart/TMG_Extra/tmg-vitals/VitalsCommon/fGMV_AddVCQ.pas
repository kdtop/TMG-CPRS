unit fGMV_AddVCQ;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/02/04 3:12p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Used to selected Vitals/Categories/Qualifiers from the
*                     TGMV_FileReference objects
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_AddVCQ.pas $
*
* $History: fGMV_AddVCQ.pas $
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
 * User: Vhaishandria Date: 1/26/04    Time: 1:06p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/Common
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:14p
 * Created in $/Vitals503/Common
 * Version 5.0.3
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/05/02    Time: 3:49p
 * Updated in $/Vitals GUI Version 5.0/Common
 * 
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 3:53p
 * Created in $/Vitals GUI Version 5.0/Common
 *
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
  StdCtrls;

type
  TfrmGMV_AddVCQ = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    lbxVitals: TListBox;
    procedure LoadVitals;
    procedure LoadCategory;
    procedure LoadQualifiers;
    procedure lbxVitalsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGMV_AddVCQ: TfrmGMV_AddVCQ;

implementation

uses uGMV_Common, uGMV_FileEntry, uGMV_Const, uGMV_GlobalVars;

{$R *.DFM}

procedure TfrmGMV_AddVCQ.LoadVitals;
var
  i: integer;
begin
  for i := 0 to GMVTypes.Entries.Count - 1 do
    lbxVitals.Items.AddObject(GMVTypes.Entries[i], GMVTypes.Entries.Objects[i]);
  Caption := 'Add Vital';
end;

procedure TfrmGMV_AddVCQ.LoadCategory;
var
  i: integer;
begin
  for i := 0 to GMVCats.Entries.Count - 1 do
    lbxVitals.Items.AddObject(GMVCats.Entries[i], GMVCats.Entries.Objects[i]);
  Caption := 'Add Vital Category';
end;

procedure TfrmGMV_AddVCQ.LoadQualifiers;
var
  i: integer;
begin
  for i := 0 to GMVQuals.Entries.Count - 1 do
    lbxVitals.Items.AddObject(GMVQuals.Entries[i], GMVQuals.Entries.Objects[i]);
  Caption := 'Add Vital Qualifier';
end;

procedure TfrmGMV_AddVCQ.lbxVitalsDblClick(Sender: TObject);
begin
  GetParentForm(Self).Perform(CM_VITALSELECTED,0,0);
end;

end.
