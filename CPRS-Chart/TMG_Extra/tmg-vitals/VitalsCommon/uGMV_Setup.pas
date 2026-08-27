unit uGMV_Setup;

interface

procedure setUpGlobals;
procedure CleanUpGlobals;

procedure CleanUpManagerGlobals;

implementation

uses uGMV_User, uGMV_FileEntry, uGMV_Template, SysUtils;

procedure setUpGlobals;
begin
  GMVUser := TGMV_User.Create;
  GMVTypes := TGMV_VitalType.Create;

  InitVitalsIENS;

  GMVQuals := TGMV_VitalQual.Create;
  GMVCats := TGMV_VitalCat.Create;
  GMVClinics := TGMV_Clinics.Create;
  GMVDefaultTemplates := TGMV_DefaultTemplates.Create;

////////////////////////////////////////////////// exist in the main Application
//      GMVTeams := TGMV_Teams.Create;
//      GMVNursingUnits := TGMV_NursingUnit.Create;
//      GMVWardLocations := TGMV_WardLocation.Create;
////////////////////////////////////////////////////////////////////////////////

end;

procedure CleanUpGlobals;
begin
  FreeAndNil(GMVDefaultTemplates);
  FreeAndNil(GMVTypes);
  FreeAndNil(GMVQuals);
  FreeAndNil(GMVCats);
  FreeAndNil(GMVClinics);
  FreeAndNil(GMVUser);
end;

procedure CleanUpManagerGlobals;
begin
end;

end.
