unit uGMV_Const;

interface
uses
  Messages
  ,uGMV_GlobalVars
  ,uGMV_VitalTypes
  ;

type
  PColor = ^TColor;
  TColor = -$7FFFFFFF-1..$7FFFFFFF;
{
  TGMV_ImageIndex = (
    iiFolderOpen,
    iiFolderClosed,
    iiTemplate,
    iiDefaultTemplate,
    iiSave,
    iiDelete,
    iiVital,
    iiAbnormal);
}

const
  clBlack = TColor($000000);
  clMaroon = TColor($000080);
  clGreen = TColor($008000);
  clOlive = TColor($008080);
  clNavy = TColor($800000);
  clPurple = TColor($800080);
  clTeal = TColor($808000);
  clGray = TColor($808080);
  clSilver = TColor($C0C0C0);
  clRed = TColor($0000FF);
  clLime = TColor($00FF00);
  clYellow = TColor($00FFFF);
  clBlue = TColor($FF0000);
  clFuchsia = TColor($FF00FF);
  clAqua = TColor($FFFF00);
  clLtGray = TColor($C0C0C0);
  clDkGray = TColor($808080);
  clWhite = TColor($ffffff);

  DISPLAYCOLORS: array[0..15] of TColor = (
    clBlack,
    clMaroon,
    clGreen,
    clOlive,
    clNavy,
    clPurple,
    clTeal,
    clGray,
    clSilver,
    clRed,
    clLime,
    clYellow,
    clBlue,
    clFuchsia,
    clAqua,
    clWhite);

  DISPLAYNAMES: array[0..15] of string = (
    'Black',
    'Maroon',
    'Green',
    'Olive',
    'Navy',
    'Purple',
    'Teal',
    'Gray',
    'Silver',
    'Red',
    'Lime',
    'Yellow',
    'Blue',
    'Fuchsia',
    'Aqua',
    'White');

(*
  RPC_MANAGER = 'GMV MANAGER';
  RPC_USER = 'GMV USER';
//  RPC_PARAMETER = 'GMV PARAMETER';
  RPC_CREATECONTEXT = 'GMV V/M GUI';
  RPC_ICN_TO_DFN = 'VAFCTFU CONVERT ICN TO DFN';
  RPC_DFN_TO_ICN = 'VAFCTFU CONVERT DFN TO ICN';
*)
  CM_NOPATIENT = WM_APP + 401; //AAN 06/11/02
  CM_PATIENTFOUND = WM_APP + 402; //AAN 06/11/02
  CM_TEMPLATEUPDATED = WM_APP + 403; //AAN 06/11/02
  CM_TEMPLATEREFRESHED = WM_APP + 404; //AAN 06/11/02
  CM_VITALSELECTED = WM_APP + 405; //AAN 07/05/02
  CM_PTSEARCHING = WM_APP + 406; //AAN 07/18/02
  CM_PTLISTNOTFOUND = WM_APP + 407; //AAN 07/18/02
  CM_PTSEARCHDONE = WM_APP + 408; //AAN 07/18/02
  CM_PTSEARCHKBMODE = WM_APP + 409; //AAN 07/18/02
  CM_UPDATELOOKUP = WM_APP + 410; //AAN 07/18/02
  CM_PATIENTChanged = WM_APP + 411; //AAN 06/11/02
  CM_PTSEARCHDELAY = WM_APP + 412; //AAN 06/11/02
  CM_PTSEARCHSTART = WM_APP + 413; //AAN 06/11/02
  CM_PTLISTCHANGED = WM_APP + 414; //AAN 06/11/02
  CM_VITALCHANGED = WM_APP + 414; //AAN 06/11/02
  CM_SELECTPTLIST = WM_APP + 415; //AAN 06/11/02

  CM_SAVEINPUT = WM_APP + 416; //AAN 2003/06/06

  CM_PERIODCHANGED = WM_APP + 417; //AAN 06/11/02

  dfltGMVAbnormalText: integer = 9; //AAN 06/13/02
  dfltGMVAbnormalBkgd: integer = 15; //AAN 06/13/02
  dfltGMVAbnormalTodayBkgd: integer = 15; //AAN 06/13/02
  dfltGMVAbnormalBold: Boolean = False; //AAN 06/13/02
  dfltGMVAbnormalQuals: Boolean = True; //AAN 06/13/02
  dfltGMVNormalText: integer = 0; //AAN 06/13/02
  dfltGMVNormalBkgd: integer = 15; //AAN 06/13/02
  dfltGMVNormalTodayBkgd: integer = 15; //AAN 06/13/02
  dfltGMVNormalBold: Boolean = False; //AAN 06/13/02
  dfltGMVNormalQuals: Boolean = True; //AAN 06/13/02
  dfltGMVInquiryBkgd: integer = $00EACF80;
  dfltGMVInquiryTextBkgd:integer = $00EACF80; //clInfoBk;
  dfltGMVInquiryName: string = 'ORWPT PTINQ';

  GMV_VASitePos = 3;

  GMVIMAGES: array[TGMV_ImageIndex] of integer = (0, 1, 2, 3, 4, 5, 6, 7);
  BOOLEAN01: array[Boolean] of integer = (0, 1);
  BOOLEANYN: array[Boolean] of string = ('No', 'Yes');
  BOOLEANTF: array[Boolean] of string = ('False', 'True');
  BOOLEANUM: array[Boolean] of string = ('US', 'Metric');


  sMsgName = 'VistA Event - Clinical';
  sMsgReceiveName = 'VistA Event - Vitals';
  sMsgClose = 'VitalsClose';

  sMsgInvalidBP =
//          'Invalid format for B/P.' + #13 + #13 +
          'The entry should be in the following format:'+#13+
          'nnn/nnn  or nnn/nnn/nnn' + #13+
          'for systolic/diastolic or systolic/intermediate/diastolic'+#13+
          'with values from 0 to 300.'
           ;

  GMV_WEBSITE = 'http://vista.med.va.gov/ClinicalSpecialties/vitals/';
  MetricList = 'HEIGHT TEMPERATURE WEIGHT CIRCUMFERENCE/GIRTH'; //AAN 06/11/02

  GMV_DateTimeFormat = 'mm/dd/yyyy hh:nn:ss';
  GMV_DateFormat = 'mm/dd/yyyy';
  GMV_TimeFormat = 'hh:nn:ss';

implementation

end.
