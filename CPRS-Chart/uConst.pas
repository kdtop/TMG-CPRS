unit uConst;
 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)


interface

uses Messages, ORFn;

const

  { User defined messages used by CPRS }
//  UM_SHOWPAGE     = (WM_USER + 100);  // originally in fFrame
//  UM_NEWORDER     = (WM_USER + 101);  // originally in fODBase
//  UM_TAKEFOCUS    = (WM_USER + 102);  // in fProbEdt
//  UM_CLOSEPROBLEM = (WM_USER + 103);  // in fProbs
//  UM_PLFILTER     = (WM_USER + 104);  // in fProbs
//  UM_PLLEX        = (WM_USER + 105);  // in fProbs
//  UM_RESIZEPAGE   = (WM_USER + 107);  // originally in fPage
//  UM_DROPLIST     = (WM_USER + 108);  // originally in fODMedIn
//  UM_DESTROY      = (WM_USER + 109);  // used to notify owner when order dialog closes
//  UM_DELAYEVENT   = (WM_USER + 110);  // used with PostMessage to slightly delay an event

  UM_SHOWPAGE     = (WM_USER + 9236);  // originally in fFrame
  UM_NEWORDER     = (WM_USER + 9237);  // originally in fODBase
  UM_TAKEFOCUS    = (WM_USER + 9238);  // in fProbEdt
  UM_CLOSEPROBLEM = (WM_USER + 9239);  // in fProbs
  UM_PLFILTER     = (WM_USER + 9240);  // in fProbs
  UM_PLLEX        = (WM_USER + 9241);  // in fProbs
  UM_RESIZEPAGE   = (WM_USER + 9242);  // originally in fPage
  UM_DROPLIST     = (WM_USER + 9243);  // originally in fODMedIn
  UM_DESTROY      = (WM_USER + 9244);  // used to notify owner when order dialog closes
  UM_DELAYEVENT   = (WM_USER + 9245);  // used with PostMessage to slightly delay an event
  UM_INITIATE     = (WM_USER + 9246);  // used by fFrame to do initial stuff after FormCreate
  UM_RESYNCREM    = (WM_USER + 9247);  // used by fReminderDialog to update reminder controls
  UM_STILLDELAY   = (WM_USER + 9248);  // used by EDO related form fOrdersTS,fOrdersCopy,fMedsCopy
  UM_EVENTOCCUR   = (WM_USER + 9249);  // used by EDO for background occured event
  UM_NSSOTHER     = (WM_USER + 9250);  // used by NSS for auto-display schedule builder
  UM_MISC         = (WM_USER + 9251);  // used for misc stuff across forms
  UM_508          = (WM_USER + 9508);  // used for 508 messages at 508 base form level

  UM_AHKMSG       = (WM_USER + 4444);  //ELH Test for messages between AHK scripts and CPRS

  { Tab Indexes, moved from fFrame }
  CT_NOPAGE   = -1;                             // chart tab - none selected
  CT_UNKNOWN  =  0;                             // chart tab - unknown (shouldn't happen)
  CT_COVER    =  1;                             // chart tab - cover sheet
  CT_PROBLEMS =  2;                             // chart tab - problem list
  CT_MEDS     =  3;                             // chart tab - medications screen
  CT_ORDERS   =  4;                             // chart tab - doctor's orders
  CT_HP       =  5;                             // chart tab - history & physical
  CT_NOTES    =  6;                             // chart tab - progress notes
  CT_CONSULTS =  7;                             // chart tab - consults
  CT_DCSUMM   =  8;                             // chart tab - discharge summaries
  CT_LABS     =  9;                             // chart tab - laboratory results
  CT_REPORTS  = 10;                             // chart tab - reports
  CT_SURGERY  = 11;                             // chart tab - surgery
  CT_IMAGES   = 12;                             // chart tab - images      //kt 9/11 added
  CT_CONSOLE  = 13;                             // chart tab - console     //kt 9/11 added
  CT_WEBTAB1  = 14;                             // chart tab - web browser //kt 9/11 added
  CT_WEBTAB2  = 15;                             // chart tab - web browser //kt 9/11 added
  CT_WEBTAB3  = 16;                             // chart tab - web browser //kt 9/11 added
  //kt 9/11 NOTE --> Option: add more CT_WEBTAB#'s here.  But set CT_LAST_WEBTAB= to last one...
  CT_LAST_WEBTAB = CT_WEBTAB3;                  // Last web chart tab //kt 9/11 added

  { Changes object item types }
  CH_DOC = 10;                        // TIU documents (progress notes)
  CH_SUM = 12;                        // Discharge Summaries       {*REV*}
  CH_CON = 15;                        // Consults
  CH_SUR = 18;                        // Surgery reports
  CH_ORD = 20;                        // Orders
  CH_PCE = 30;                        // Encounter Form items

  { Changes object signature requirements }
  CH_SIGN_YES = 1;                    // Obtain signature (checkbox is checked)
  CH_SIGN_NO  = 2;                    // Don't obtain signature (checkbox is unchecked)
  CH_SIGN_NA  = 0;                    // Signature not applicable (checkbox is greyed)

  { Sign & release orders }
  SS_ONCHART  = '0';
  SS_ESIGNED  = '1';
  SS_UNSIGNED = '2';
  SS_NOTREQD  = '3';
  SS_DIGSIG   = '7';
  RS_HOLD     = '0';
  RS_RELEASE  = '1';
  NO_PROVIDER = 'E';
  NO_VERBAL   = 'V';
  NO_PHONE    = 'P';
  NO_POLICY   = 'I';
  NO_WRITTEN  = 'W';

  { Actions on orders }
  ORDER_NEW   = 0;
  ORDER_DC    = 1;
  ORDER_RENEW = 2;
  ORDER_HOLD  = 3;
  ORDER_EDIT  = 4;
  ORDER_COPY  = 5;
  ORDER_QUICK = 9;
  ORDER_ACT   = 10;
  ORDER_SIGN  = 11;
  ORDER_CPLXRN = 12;

  { Order action codes }
  OA_COPY     = 'RW';
  OA_CHANGE   = 'XX';
  OA_RENEW    = 'RN';
  OA_HOLD     = 'HD';
  OA_DC       = 'DC';
  OA_UNHOLD   = 'RL';
  OA_FLAG     = 'FL';
  OA_UNFLAG   = 'UF';
  OA_COMPLETE = 'CP';
  OA_ALERT    = 'AL';
  OA_REFILL   = 'RF';
  OA_VERIFY   = 'VR';
  OA_CHART    = 'CR';
  OA_RELEASE  = 'RS';
  OA_SIGN     = 'ES';
  OA_ONCHART  = 'OC';
  OA_COMMENT  = 'CM';
  OA_TRANSFER = 'XFR';
  OA_CHGEVT   = 'EV';
  OA_EDREL    = 'MN';

  { Ordering Dialog Form IDs }
  OD_ACTIVITY  = 100;
  OD_ALLERGY   = 105;
  OD_CONSULT   = 110;
  OD_PROCEDURE = 112;
  OD_DIET_TXT  = 115;
  OD_DIET      = 117;
  OD_LAB       = 120;
  OD_BB        = 125;
  OD_MEDINPT   = 130;
  OD_MEDS      = 135;
  OD_MEDOUTPT  = 140;
  OD_MEDNONVA = 145;
  OD_NURSING   = 150;
  OD_MISC      = 151;
  OD_GENERIC   = 152;
  OD_IMAGING   = 160;
  OD_VITALS    = 171;  // use 170 for ORWD GENERIC VITALS, 171 for GMRVOR
  OD_MEDIV     = 180;
  OD_NUR_OTP   = 800;  //TMG
  OD_NUR_OSP   = 801;  //TMG
  OD_TEXTONLY  = 999;
  OM_NAV       = 1001;
  OM_QUICK     = 1002;
  OM_TABBED    = 1003;
  OM_TREE      = 1004;
  OM_ALLERGY   = 1105;
  OM_HTML      = 1200;
  OD_AUTOACK   = 9999;

  { Ordering role }
  OR_NOKEY     = 0;
  OR_CLERK     = 1;
  OR_NURSE     = 2;
  OR_PHYSICIAN = 3;
  OR_STUDENT   = 4;
  OR_BADKEYS   = 5;

  { Quick Orders }
  QL_DIALOG = 0;
  QL_AUTO   = 1;
  QL_VERIFY = 2;
  QL_REJECT = 8;
  QL_CANCEL = 9;
  MAX_KEYVARS = 10;

  { Order Signature Statuses }
  OSS_UNSIGNED = 2;
  OSS_NOT_REQUIRE = 3;

  { Special Strings }
  TX_WPTYPE = '^WP^';                 // used to identify fields passed as word processing

  { Pharmacy Variables }
  PST_UNIT_DOSE  = 'U';
  PST_IV_FLUIDS  = 'F';
  PST_OUTPATIENT = 'O';

  { Status groups for medications }
  MED_ACTIVE     = 0;                 // status is an active status (active, hold, on call)
  MED_PENDING    = 1;                 // status is a pending status (non-verified)
  MED_NONACTIVE  = 2;                 // status is a non-active status (expired, dc'd, ...)

  { Actions for medications }
  MED_NONE       = 0;
  MED_NEW        = 1;
  MED_DC         = 2;
  MED_HOLD       = 3;
  MED_RENEW      = 4;
  MED_REFILL     = 5;

  { Validate Date/Times }
  DT_FUTURE   = 'F';
  DT_PAST     = 'P';
  DT_MMDDREQ  = 'E';
  DT_TIMEOPT  = 'T';
  DT_TIMEREQ  = 'R';

  { Change Context Types }
  CC_CLICK        = 0;
  CC_INIT_PATIENT = 1;
  CC_NOTIFICATION = 2;
  CC_REFRESH      = 3;
  CC_RESUME       = 4;

  { Notification Types }
  NF_LAB_RESULTS                   = 3;
  NF_FLAGGED_ORDERS                = 6;
  NF_ORDER_REQUIRES_ELEC_SIGNATURE = 12;
  NF_ABNORMAL_LAB_RESULTS          = 14;
  NF_IMAGING_RESULTS               = 22;
  NF_CONSULT_REQUEST_RESOLUTION    = 23;
  NF_ABNORMAL_IMAGING_RESULTS      = 25;
  NF_IMAGING_REQUEST_CANCEL_HELD   = 26;
  NF_NEW_SERVICE_CONSULT_REQUEST   = 27;
  NF_CONSULT_REQUEST_CANCEL_HOLD   = 30;
  NF_SITE_FLAGGED_RESULTS          = 32;
  NF_ORDERER_FLAGGED_RESULTS       = 33;
  NF_ORDER_REQUIRES_COSIGNATURE    = 37;
  NF_LAB_ORDER_CANCELED            = 42;
  NF_STAT_RESULTS                  = 44;
  NF_DNR_EXPIRING                  = 45;
  NF_MEDICATIONS_EXPIRING_INPT     = 47;
  NF_UNVERIFIED_MEDICATION_ORDER   = 48;
  NF_NEW_ORDER                     = 50;
  NF_IMAGING_RESULTS_AMENDED       = 53;
  NF_CRITICAL_LAB_RESULTS          = 57;
  NF_UNVERIFIED_ORDER              = 59;
  NF_FLAGGED_OI_RESULTS            = 60;
  NF_FLAGGED_OI_ORDER              = 61;
  NF_DC_ORDER                      = 62;
  NF_CONSULT_REQUEST_UPDATED       = 63;
  NF_FLAGGED_OI_EXP_INPT           = 64;
  NF_FLAGGED_OI_EXP_OUTPT          = 65;
  NF_CONSULT_PROC_INTERPRETATION   = 66;
  NF_IMAGING_REQUEST_CHANGED       = 67;
  NF_LAB_THRESHOLD_EXCEEDED        = 68;
  NF_MAMMOGRAM_RESULTS             = 69;
  NF_PAP_SMEAR_RESULTS             = 70;
  NF_ANATOMIC_PATHOLOGY_RESULTS    = 71;
  NF_MEDICATIONS_EXPIRING_OUTPT    = 72;
  NF_DEA_AUTO_DC_CS_MED_ORDER      = 74;
  NF_DEA_CERT_REVOKED              = 75;
  NF_DCSUMM_UNSIGNED_NOTE          = 901;
  NF_CONSULT_UNSIGNED_NOTE         = 902;
  NF_NOTES_UNSIGNED_NOTE           = 903;
  NF_SURGERY_UNSIGNED_NOTE         = 904;
  NF_ERX_REFILL_NEEDED             = 11305;   //ERx 4/22/11
  NF_ERX_INCOMPLETE_ORDER          = 11306;   //ERx 4/22/11

  { Notify Application Events }
  NAE_OPEN   = 'BEG';
  NAE_CLOSE  = 'END';
  NAE_NEWPT  = 'XPT';
  NAE_REPORT = 'RPT';
  NAE_ORDER  = 'ORD';

  { TIU Delete Document Reasons }
  DR_PRIVACY = 'P';
  DR_ADMIN   = 'A';
  DR_NOTREQ  = '';
  DR_CANCEL  = 'CANCEL';

  { TIU Document Types }
  TYP_PROGRESS_NOTE =   3;
  TYP_ADDENDUM      =  81;
  TYP_DC_SUMM       = 244;  //kt documentation.  <-- This seems to be hard coded IEN for server!
  TYP_COMPONENT     = 115;  //kt added.  Does this have to match IEN on server? ?

  { TIU National Document Class Names }
  DCL_CONSULTS = 'CONSULTS';
  DCL_CLINPROC = 'CLINICAL PROCEDURES';
  DCL_SURG_OR  = 'SURGICAL REPORTS';
  DCL_SURG_NON_OR = 'PROCEDURE REPORT (NON-O.R.)';

  { TIU View Contexts }
  NC_RECENT     = 0;                             // Note context - last n signed notes
  NC_ALL        = 1;                             // Note context - all signed notes
  NC_UNSIGNED   = 2;                             // Note context - all unsigned notes
  NC_UNCOSIGNED = 3;                             // Note context - all uncosigned notes
  NC_BY_AUTHOR  = 4;                             // Note context - signed notes by author
  NC_BY_DATE    = 5;                             // Note context - signed notes by date range
  NC_CUSTOM     = 6;                             // Note Context - custom view
  //Text Search CQ: HDS00002856
  NC_SEARCHTEXT = 7;                             // Note Content - search for text
  NC_OTHER_UNSIGNED = 8;                      // Note Content - all others' unsigned notes  //TMG  9/12/17

  { Surgery View Contexts }
  SR_RECENT     = 0;
  SR_ALL        = 1;
  SR_BY_DATE    = 5;                             
  SR_CUSTOM     = 6;

  { Surgery TreeView Icons }
  IMG_SURG_BLANK     = 0;
  IMG_SURG_TOP_LEVEL = 1;
  IMG_SURG_GROUP_SHUT = 2;
  IMG_SURG_GROUP_OPEN = 3;
  IMG_SURG_CASE_EMPTY = 4;
  IMG_SURG_CASE_SHUT  = 5;
  IMG_SURG_CASE_OPEN  = 6;
  IMG_SURG_RPT_SINGLE = 7;
  IMG_SURG_RPT_ADDM   = 8;
  IMG_SURG_ADDENDUM   = 9;
  IMG_SURG_NON_OR_CASE_EMPTY = 10;
  IMG_SURG_NON_OR_CASE_SHUT  = 11;
  IMG_SURG_NON_OR_CASE_OPEN  = 12;

  { TIU TreeView icons }
  IMG_TOP_LEVEL     = 0;
  IMG_GROUP_SHUT    = 1;
  IMG_GROUP_OPEN    = 2;
  IMG_SINGLE        = 3;
  IMG_PARENT        = 4;
  IMG_IDNOTE_SHUT   = 5;
  IMG_IDNOTE_OPEN   = 6;
  IMG_IDPAR_ADDENDA_SHUT = 7;
  IMG_IDPAR_ADDENDA_OPEN = 8;
  IMG_ID_CHILD      = 9;
  IMG_ID_CHILD_ADD  = 10;
  IMG_ADDENDUM      = 11;

  { Consults Treeview Icons }
  IMG_GMRC_TOP_LEVEL     = 0;
  IMG_GMRC_GROUP_SHUT    = 1;
  IMG_GMRC_GROUP_OPEN    = 2;
  IMG_GMRC_CONSULT       = 3;
  IMG_GMRC_PROC          = 4;
  IMG_GMRC_CLINPROC      = 5;
  IMG_GMRC_ALL_PROC      = 6;
  IMG_GMRC_IFC_CONSULT   = 7;
  IMG_GMRC_IFC_PROC      = 8;


  { TIU Imaging icons }
  IMG_NO_IMAGES     = 6;
  IMG_1_IMAGE       = 1;
  IMG_2_IMAGES      = 2;
  IMG_MANY_IMAGES   = 3;
  IMG_CHILD_HAS_IMAGES = 4;
  IMG_IMAGES_HIDDEN = 5;


  { TIU ListView sort indicators }
  IMG_NONE       = -1;
  IMG_ASCENDING  =  12;
  IMG_DESCENDING =  13;
  IMG_BLANK      =  14;

  { TIU TreeView context strings}
  NC_TV_TEXT: array[CT_NOTES..CT_DCSUMM] of array[NC_RECENT..NC_OTHER_UNSIGNED] of string =
    (('Recent Signed Notes','All signed notes','All unsigned notes','All uncosigned notes','Signed notes by author','Signed notes by date range',' ',' ','All other users'' unsigned notes'),
     ('','Related Documents','Medicine Results',' ',' ',' ',' ',' ',' '),
     ('Recent Signed Summaries','All signed summaries','All unsigned summaries','All uncosigned summaries','Signed summaries by author','Signed summaries by date range',' ',' ',' '));

  CC_ALL        = 1;                             // Consult context - all Consults
  CC_BY_STATUS  = 2;                             // Consult context - Consults by Status
  CC_BY_SERVICE = 4;                             // Consult context - Consults by Service
  CC_BY_DATE    = 5;                             // Consult context - Consults by date range
  CC_CUSTOM     = 6;                             // Custom consults list

  CC_TV_TEXT: array[CC_ALL..CC_CUSTOM] of string =
    ('All consults','Consults by Status', '', 'Consults by Service','Consults by Date Range','Custom List');

  PKG_CONSULTS = 'GMR(123,';
  PKG_SURGERY  = 'SRF(';
  PKG_PRF = 'PRF';

  { New Person Filters }
  NPF_ALL       = 0;
  NPF_PROVIDER  = 1;
//  NPF_ENCOUNTER = 2;
  NPF_SUPPRESS  = 9;

  { Location Types }
  LOC_ALL      = 0;
  LOC_OUTP     = 1;
  LOC_INP      = 2;

  { File Numbers }
  FN_HOSPITAL_LOCATION = 44;
  FN_NEW_PERSON = 200;

  UpperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  LowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  Digits = '0123456789';

  MAX_ENTRY_WIDTH = 80;   //Change in 23.9 for D/S, Consult, and Surgery Notes AGP
  MAX_PROGRESSNOTE_WIDTH = 80;

  //Group Name
   NONVAMEDGROUP = 'Non-VA Meds';
   NONVAMEDTXT =   'Non-VA';

   DISCONTINUED_ORDER = '2';

   CaptionProperty = 'Caption';
   ShowAccelCharProperty = 'ShowAccelChar';
   DrawersProperty = 'Drawers';

   {Sensitive Patient Access}
    DGSR_FAIL = -1;
    DGSR_NONE =  0;
    DGSR_SHOW =  1;
    DGSR_ASK  =  2;
    DGSR_DENY =  3;

  //CQ #15813 added strings here, rather then being duplicated in numerous sections of code - JCS
  TX_SAVERR_PHARM_ORD_NUM = 'The changes to this order have not been saved.  You must contact Pharmacy to complete any action on this order.';
  TX_SAVERR_IMAGING_PROC = 'The order has not been saved.  You must contact the Imaging Department for help completing this order.';
  TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING = 'Invalid Pharmacy order number';
  TX_SAVERR_IMAGING_PROC_SEARCH_STRING = 'Invalid Procedure, Inactive, no Imaging Type or no Procedure Type';

  //DEA prescriber ineligibility text used in conjunction w/DEACheckFailed
  TX_DEAFAIL   = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider does not have a current, valid DEA# on record' + CRLF +
                 'and is ineligible to sign the order.';
  TX_SCHFAIL   = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider is not authorized to prescribe medications' + CRLF +
                 'in Federal Schedule ';
  TX_NO_DETOX  = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider does not have a valid Detoxification/Maintenance ID' + CRLF +
                 'number on record and is ineligible to sign the order.';
  TX_EXP_DETOX1= 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider''s Detoxification/Maintenance ID number' + CRLF +
                 'expired due to an expired DEA# on ';
  TX_EXP_DETOX2= '.' + CRLF + 'Provider is ineligible to sign the order.';
  TX_EXP_DEA1  = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider''s DEA# expired on ';
  TX_EXP_DEA2  = ' and no VA# is' + CRLF +
                 'assigned. Provider is ineligible to sign the order.';
  TX_INSTRUCT  = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF + 'Click CANCEL to cancel the current order.';
  TC_DEAFAIL   = 'Order not completed';
   // ERX ACTIONS
   ERX_ACTION_ORDER = 0;
   ERX_ACTION_ALERT = 1;


   //kt added below from fNotes, so could also be used for fSingleNote  2/16/17
  TX_NEED_VISIT = 'A visit is required before creating a new progress note.';
  TX_CREATE_ERR = 'Error Creating Note';
  TX_UPDATE_ERR = 'Error Updating Note';
  TX_NO_NOTE    = 'No progress note is currently being edited';
  TX_SAVE_NOTE  = 'Save Progress Note';
  TX_ADDEND_NO  = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this progress note?';
  TX_DEL2_OK    = CRLF + CRLF + 'Delete this note component?';  //kt 5/15
  TX_DEL_AND_COMPS_OK = TX_DEL_OK + CRLF + 'AND' + CRLF + 'Delete all attached note components?';  //kt added 5/15
  TX_DEL_ERR    = 'Unable to Delete Note';
  TX_DEL2_ERR   = 'Unable to Delete Attached Note Components';  //kt 5/15
  TX_BAD_IEN    = 'Invalid record number for document';  //kt 5/15

  TX_SIGN       = 'Sign Note';
  TX_COSIGN     = 'Cosign Note';
  TX_SIGN_ERR   = 'Unable to Sign Note';
//  TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
//                  'answered.  The Encounter form will now be opened.  Please answer all '+
//                 'service connected questions.';
//  TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NONOTE     = 'No progress note is currently selected.';
  TX_NONOTE_CAP = 'No Note Selected';
  TX_NOPRT_NEW  = 'This progress note may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Progress Note';
  TX_NO_ALERT   = 'There is insufficient information to process this alert.' + CRLF +
                  'Either the alert has already been deleted, or it contained invalid data.' + CRLF + CRLF +
                  'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  TX_ORDER_LOCKED = 'This record is locked by an action underway on the Consults tab';
  TC_ORDER_LOCKED = 'Unable to access record';
  TX_NO_ORD_CHG   = 'The note is still associated with the previously selected request.' + CRLF +
                    'Finish the pending action on the consults tab, then try again.';
  TC_NO_ORD_CHG   = 'Locked Consult Request';
  TX_NEW_SAVE1    = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2    = CRLF + CRLF + 'Do you wish to save this note and begin a new one?';
  TX_NEW_SAVE3    = CRLF + CRLF + 'Do you wish to save this note and begin a new addendum?';
  TX_NEW_SAVE4    = CRLF + CRLF + 'Do you wish to save this note and edit the one selected?';
  TX_NEW_SAVE5    = CRLF + CRLF + 'Do you wish to save this note and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2    = 'Create New Note';
  TC_NEW_SAVE3    = 'Create New Addendum';
  TC_NEW_SAVE4    = 'Edit Different Note';
  TC_NEW_SAVE5    = 'Create New Interdisciplinary Entry';
  TX_EMPTY_NOTE   = CRLF + CRLF + 'This note contains no text and will not be saved.' + CRLF +
                    'Do you wish to delete this note?';
  TC_EMPTY_NOTE   = 'Empty Note';
  TX_EMPTY_NOTE1   = 'This note contains no text and can not be signed.';
  TC_NO_LOCK      = 'Unable to Lock Note';
  TX_ABSAVE       = 'It appears the session terminated abnormally when this' + CRLF +
                    'note was last edited. Some text may not have been saved.' + CRLF + CRLF +
                    'Do you wish to continue and sign the note?';
  TC_ABSAVE       = 'Possible Missing Text';
  TX_NO_BOIL      = 'There is no boilerplate text associated with this title.';
  TC_NO_BOIL      = 'Load Boilerplate Text';
  TX_BLR_CLEAR    = 'Do you want to clear the previously loaded boilerplate text?';
  TC_BLR_CLEAR    = 'Clear Previous Boilerplate Text';
  TX_DETACH_CNF     = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';
  TX_RETRACT_CAP    = 'Retraction Notice';
  TX_RETRACT        = 'This document will now be RETRACTED.  As Such, it has been removed' +CRLF +
                      ' from public view, and from typical Releases of Information,' +CRLF +
                      ' but will remain indefinitely discoverable to HIMS.' +CRLF +CRLF;
  TX_AUTH_SIGNED    = 'Author has not signed, are you SURE you want to sign.' +CRLF;

   //kt end addition


var
  ScrollBarWidth: integer = 0;

implementation

uses
  Windows;
  
initialization
  ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);

end.


