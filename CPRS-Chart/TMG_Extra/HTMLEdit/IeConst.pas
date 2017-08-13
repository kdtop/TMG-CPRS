(******************************************************************************
*                                   IEConst                                   *
* Constants for IE hosting etc...                                             *
******************************************************************************)
unit Ieconst;

interface

uses
   ActiveX, OleCtrls, Windows, Messages, SysUtils, Classes;


const
  SID_SHTMLEditHost: TGUID = '{3050F6A0-98B5-11CF-BB82-00AA00BDCE0B}';
  //(D1: $3050F6A0; D2: $98B5; D3: $11CF; D4: ($BB, $82, $00, $AA, $00, $BD, $CE, $0B));

  IID_IDocHostUIHandler: TGUID = '{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}';
  GUID_TriEditCommandGroup: TGUID = '{2582F1C0-084E-11d1-9A0E-006097C9B344}';
  CMDSETID_Forms3: TGUID = '{DE4BA900-59CA-11CF-9592-444553540000}';
  CGID_MSHTML: TGUID = '{DE4BA900-59CA-11CF-9592-444553540000}';
  CGID_DocHostCommandHandler: TGUID = (D1: $F38BC242; D2: $B950; D3: $11D1; D4: ($89, $18, $00, $C0, $4F, $C2, $C8, $36));



  CLSID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';

  SID_SHTMLEditServices: TGUID = (D1: $3050f7f9; D2: $98b5; D3: $11cf; D4: ($bb, $82, $00, $AA, $00, $bd, $ce, $0b));

  //* Object interface: IBrowserHost, ver. 0.0,
  // GUID={0x5FD6158A,0x71F6,0x4F20,{0xB8,0xA9,0x6E,0xAF,0x5D,0x03,0x2D,0x15}} */

  MSOCMDF_SUPPORTED = OLECMDF_SUPPORTED;
  MSOCMDF_ENABLED = OLECMDF_ENABLED;

  MSOCMDEXECOPT_PROMPTUSER = OLECMDEXECOPT_PROMPTUSER;
  MSOCMDEXECOPT_DONTPROMPTUSER = OLECMDEXECOPT_DONTPROMPTUSER;


//thise constants / enums isent contained in IE 5.5 SHDocVw_TLB ???
type
  RefreshConstants = TOleEnum;
const
  REFRESH_NORMAL = 0;
  REFRESH_IFEXPIRED = 1;
  REFRESH_CONTINUE = 2;
  REFRESH_COMPLETELY = 3;

type
  BrowserNavConstants = TOleEnum;
const
  navOpenInNewWindow = $00000001;
  navNoHistory       = $00000002;
  navNoReadFromCache = $00000004;
  navNoWriteToCache  = $00000008;
  navAllowAutosearch = $00000010;
  navBrowserBar      = $00000020;
//----- END ----------

const
  CONTEXT_MENU_DEFAULT = 0;
  CONTEXT_MENU_IMAGE = 1;
  CONTEXT_MENU_CONTROL = 2;
  CONTEXT_MENU_TABLE = 3;
  CONTEXT_MENU_TEXTSELECT = 4;
  CONTEXT_MENU_ANCHOR = 5;
  CONTEXT_MENU_UNKNOWN = 6;
  CONTEXT_MENU_IMGDYNSRC = 7;
  CONTEXT_MENU_IMGART = 8;
  CONTEXT_MENU_DEBUG = 9;


  DOCHOSTUITYPE_BROWSE= 0;
  DOCHOSTUITYPE_AUTHOR= 1;

  DOCHOSTUIDBLCLK_DEFAULT= 0;
  DOCHOSTUIDBLCLK_SHOWPROPERTIES= 1;
  DOCHOSTUIDBLCLK_SHOWCODE= 2;

  DOCHOSTUIFLAG_DIALOG                      = 1;
  DOCHOSTUIFLAG_DISABLE_HELP_MENU           = 2;
  DOCHOSTUIFLAG_NO3DBORDER                  = 4;
  DOCHOSTUIFLAG_SCROLL_NO                   = 8;
  DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE     = 16;
  DOCHOSTUIFLAG_OPENNEWWIN                  = 32;
  DOCHOSTUIFLAG_DISABLE_OFFSCREEN           = 64;
  DOCHOSTUIFLAG_FLAT_SCROLLBAR              = 128;
  DOCHOSTUIFLAG_DIV_BLOCKDEFAULT            = 256;
  DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY     = 512;
  DOCHOSTUIFLAG_OVERRIDEBEHAVIORFACTORY     = $00000400;
  DOCHOSTUIFLAG_CODEPAGELINKEDFONTS         = $00000800;
  DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8   = $00001000;
  DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8    = $00002000;
  DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE   = $00004000;
  DOCHOSTUIFLAG_ENABLE_INPLACE_NAVIGATION   = $00010000;
  DOCHOSTUIFLAG_IME_ENABLE_RECONVERSION     = $00020000;
  DOCHOSTUIFLAG_THEME                       = $00040000;
  DOCHOSTUIFLAG_NOTHEME                     = $00080000;
  DOCHOSTUIFLAG_NOPICS                      = $00100000;
  DOCHOSTUIFLAG_NO3DOUTERBORDER             = $00200000;

  //old style DECM....
  DECMD_BOLD              = $00001388;   //5000
  DECMD_COPY              = $0000138A;
  DECMD_CUT               = $0000138B;
  DECMD_DELETE            = $0000138C;
  DECMD_DELETECELLS       = $0000138D;
  DECMD_DELETECOLS        = $0000138E;
  DECMD_DELETEROWS        = $0000138F;
  DECMD_FINDTEXT          = $00001390;
  DECMD_FONT              = $00001391;
  DECMD_GETBACKCOLOR      = $00001392;
  DECMD_GETBLOCKFMT       = $00001393;
  DECMD_GETBLOCKFMTNAMES  = $00001394;
  DECMD_GETFONTNAME       = $00001395;
  DECMD_GETFONTSIZE       = $00001396;
  DECMD_GETFORECOLOR      = $00001397;
  DECMD_HYPERLINK         = $00001398;
  DECMD_IMAGE             = $00001399;
  DECMD_INDENT            = $0000139A;
  DECMD_INSERTCELL        = $0000139B;
  DECMD_INSERTCOL         = $0000139C;
  DECMD_INSERTROW         = $0000139D;
  DECMD_INSERTTABLE       = $0000139E;
  DECMD_ITALIC            = $0000139F;
  DECMD_JUSTIFYCENTER     = $000013A0;
  DECMD_JUSTIFYLEFT       = $000013A1;
  DECMD_JUSTIFYRIGHT      = $000013A2;
  DECMD_LOCK_ELEMENT      = $000013A3;
  DECMD_MAKE_ABSOLUTE     = $000013A4;
  DECMD_MERGECELLS        = $000013A5;
  DECMD_ORDERLIST         = $000013A6;
  DECMD_OUTDENT           = $000013A7;
  DECMD_PASTE             = $000013A8;
  DECMD_REDO              = $000013A9;
  DECMD_REMOVEFORMAT      = $000013AA;
  DECMD_SELECTALL         = $000013AB;
  DECMD_SEND_BACKWARD     = $000013AC;
  DECMD_BRING_FORWARD     = $000013AD;
  DECMD_SEND_BELOW_TEXT   = $000013AE;
  DECMD_BRING_ABOVE_TEXT  = $000013AF;
  DECMD_SEND_TO_BACK      = $000013B0;
  DECMD_BRING_TO_FRONT    = $000013B1;
  DECMD_SETBACKCOLOR      = $000013B2;
  DECMD_SETBLOCKFMT       = $000013B3;
  DECMD_SETFONTNAME       = $000013B4;
  DECMD_SETFONTSIZE       = $000013B5;
  DECMD_SETFORECOLOR      = $000013B6;
  DECMD_SPLITCELL         = $000013B7;
  DECMD_UNDERLINE         = $000013B8;
  DECMD_UNDO              = $000013B9;
  DECMD_UNLINK            = $000013BA;
  DECMD_UNORDERLIST       = $000013BB;
  DECMD_PROPERTIES        = $000013BC;    //5052
  IDM_NUDGE_ELEMENT       = $000013BD;
  IDM_LOCK_ELEMENT        = $000013BE;
  IDM_CONSTRAIN           = $000013BF;
  KS_TEST                 = $000013C0;

  //end old style DECM....

  IDM_UNKNOWN               =  0;
  IDM_ALIGNBOTTOM           =  1;
  IDM_ALIGNHORIZONTALCENTERS=  2;
  IDM_ALIGNLEFT             =  3;
  IDM_ALIGNRIGHT            =  4;
  IDM_ALIGNTOGRID           =  5;
  IDM_ALIGNTOP              =  6;
  IDM_ALIGNVERTICALCENTERS  =  7;
  IDM_ARRANGEBOTTOM         =  8;
  IDM_ARRANGERIGHT          =  9;
  IDM_BRINGFORWARD           = 10;
  IDM_BRINGTOFRONT           = 11;
  IDM_CENTERHORIZONTALLY     = 12;
  IDM_CENTERVERTICALLY       = 13;
  IDM_CODE                   = 14;
  IDM_DELETE                 = 17;
  IDM_FONTNAME               = 18;
  IDM_FONTSIZE               = 19;
  IDM_GROUP                  = 20;
  IDM_HORIZSPACECONCATENATE  = 21;
  IDM_HORIZSPACEDECREASE     = 22;
  IDM_HORIZSPACEINCREASE     = 23;
  IDM_HORIZSPACEMAKEEQUAL    = 24;
  IDM_INSERTOBJECT           = 25;
  IDM_MULTILEVELREDO         = 30;
  IDM_SENDBACKWARD           = 32;
  IDM_SENDTOBACK             = 33;
  IDM_SHOWTABLE              = 34;
  IDM_SIZETOCONTROL          = 35;
  IDM_SIZETOCONTROLHEIGHT    = 36;
  IDM_SIZETOCONTROLWIDTH     = 37;
  IDM_SIZETOFIT              = 38;
  IDM_SIZETOGRID             = 39;
  IDM_SNAPTOGRID             = 40;
  IDM_TABORDER               = 41;
  IDM_TOOLBOX                = 42;
  IDM_MULTILEVELUNDO         = 44;
  IDM_UNGROUP                = 45;
  IDM_VERTSPACECONCATENATE   = 46;
  IDM_VERTSPACEDECREASE      = 47;
  IDM_VERTSPACEINCREASE      = 48;
  IDM_VERTSPACEMAKEEQUAL     = 49;
  IDM_JUSTIFYFULL            = 50;
  IDM_BACKCOLOR              = 51;
  IDM_BOLD                   = 52;
  IDM_BORDERCOLOR            = 53;
  IDM_FLAT                   = 54;
  IDM_FORECOLOR              = 55;
  IDM_ITALIC                 = 56;
  IDM_JUSTIFYCENTER          = 57;
  IDM_JUSTIFYGENERAL         = 58;
  IDM_JUSTIFYLEFT            = 59;
  IDM_JUSTIFYRIGHT           = 60;
  IDM_RAISED                 = 61;
  IDM_SUNKEN                 = 62;
  IDM_UNDERLINE              = 63;
  IDM_CHISELED               = 64;
  IDM_ETCHED                 = 65;
  IDM_SHADOWED               = 66;
  IDM_FIND                   = 67;
  IDM_SHOWGRID               = 69;
  IDM_OBJECTVERBLIST0        = 72;
  IDM_OBJECTVERBLIST1        = 73;
  IDM_OBJECTVERBLIST2        = 74;
  IDM_OBJECTVERBLIST3        = 75;
  IDM_OBJECTVERBLIST4        = 76;
  IDM_OBJECTVERBLIST5        = 77;
  IDM_OBJECTVERBLIST6        = 78;
  IDM_OBJECTVERBLIST7        = 79;
  IDM_OBJECTVERBLIST8        = 80;
  IDM_OBJECTVERBLIST9        = 81;
  IDM_OBJECTVERBLISTLAST     = IDM_OBJECTVERBLIST9;
  IDM_CONVERTOBJECT          = 82;
  IDM_CUSTOMCONTROL          = 83;
  IDM_CUSTOMIZEITEM          = 84;
  IDM_RENAME                 = 85;
  IDM_IMPORT                 = 86;
  IDM_NEWPAGE                = 87;
  IDM_MOVE                   = 88;
  IDM_CANCEL                 = 89;
  IDM_FONT                   = 90;
  IDM_STRIKETHROUGH          = 91;
  IDM_DELETEWORD             = 92;
  IDM_EXECPRINT              = 93;
  IDM_JUSTIFYNONE            = 94;
  IDM_TRISTATEBOLD           = 95;
  IDM_TRISTATEITALIC         = 96;
  IDM_TRISTATEUNDERLINE      = 97;

  IDM_FOLLOW_ANCHOR         =  2008;

  IDM_INSINPUTIMAGE         =  2114;
  IDM_INSINPUTBUTTON        =  2115;
  IDM_INSINPUTRESET         =  2116;
  IDM_INSINPUTSUBMIT        =  2117;
  IDM_INSINPUTUPLOAD        =  2118;
  IDM_INSFIELDSET           =  2119;

  IDM_PASTEINSERT           =  2120;
  IDM_REPLACE               =  2121;
  IDM_EDITSOURCE            =  2122;
  IDM_BOOKMARK              =  2123;
  IDM_HYPERLINK             =  2124;
  IDM_UNLINK                =  2125;
  IDM_BROWSEMODE            =  2126;
  IDM_EDITMODE              =  2127;
  IDM_UNBOOKMARK            =  2128;

  IDM_TOOLBARS              =  2130;
  IDM_STATUSBAR             =  2131;
  IDM_FORMATMARK            =  2132;
  IDM_TEXTONLY              =  2133;
  IDM_OPTIONS               =  2135;
  IDM_FOLLOWLINKC           =  2136;
  IDM_FOLLOWLINKN           =  2137;
  IDM_VIEWSOURCE            =  2139;
  IDM_ZOOMPOPUP             =  2140;

  // IDM_BASELINEFONT1, IDM_BASELINEFONT2, IDM_BASELINEFONT3, IDM_BASELINEFONT4,
  // and IDM_BASELINEFONT5 should be consecutive integers;
  //
  IDM_BASELINEFONT1         =  2141;
  IDM_BASELINEFONT2         =  2142;
  IDM_BASELINEFONT3         =  2143;
  IDM_BASELINEFONT4         =  2144;
  IDM_BASELINEFONT5         =  2145;

  IDM_HORIZONTALLINE        =  2150;
  IDM_LINEBREAKNORMAL       =  2151;
  IDM_LINEBREAKLEFT         =  2152;
  IDM_LINEBREAKRIGHT        =  2153;
  IDM_LINEBREAKBOTH         =  2154;
  IDM_NONBREAK              =  2155;
  IDM_SPECIALCHAR           =  2156;
  IDM_HTMLSOURCE            =  2157;
  IDM_IFRAME                =  2158;
  IDM_HTMLCONTAIN           =  2159;
  IDM_TEXTBOX               =  2161;
  IDM_TEXTAREA              =  2162;
  IDM_CHECKBOX              =  2163;
  IDM_RADIOBUTTON           =  2164;
  IDM_DROPDOWNBOX           =  2165;
  IDM_LISTBOX               =  2166;
  IDM_BUTTON                =  2167;
  IDM_IMAGE                 =  2168;
  IDM_OBJECT                =  2169;
  IDM_1D                    =  2170;
  IDM_IMAGEMAP              =  2171;
  IDM_FILE                  =  2172;
  IDM_COMMENT               =  2173;
  IDM_SCRIPT                =  2174;
  IDM_JAVAAPPLET            =  2175;
  IDM_PLUGIN                =  2176;
  IDM_PAGEBREAK             =  2177;
  IDM_HTMLAREA              =  2178;

  IDM_PARAGRAPH             =  2180;
  IDM_FORM                  =  2181;
  IDM_MARQUEE               =  2182;
  IDM_LIST                  =  2183;
  IDM_ORDERLIST             =  2184;
  IDM_UNORDERLIST           =  2185;
  IDM_INDENT                =  2186;
  IDM_OUTDENT               =  2187;
  IDM_PREFORMATTED          =  2188;
  IDM_ADDRESS               =  2189;
  IDM_BLINK                 =  2190;
  IDM_DIV                   =  2191;

  IDM_TABLEINSERT           =  2200;
  IDM_RCINSERT              =  2201;
  IDM_CELLINSERT            =  2202;
  IDM_CAPTIONINSERT         =  2203;
  IDM_CELLMERGE             =  2204;
  IDM_CELLSPLIT             =  2205;
  IDM_CELLSELECT            =  2206;
  IDM_ROWSELECT             =  2207;
  IDM_COLUMNSELECT          =  2208;
  IDM_TABLESELECT           =  2209;
  IDM_TABLEPROPERTIES       =  2210;
  IDM_CELLPROPERTIES        =  2211;
  IDM_ROWINSERT             =  2212;
  IDM_COLUMNINSERT          =  2213;

  IDM_HELP_CONTENT          =  2220;
  IDM_HELP_ABOUT            =  2221;
  IDM_HELP_README           =  2222;

  IDM_REMOVEFORMAT          =  2230;
  IDM_PAGEINFO              =  2231;
  IDM_TELETYPE              =  2232;
  IDM_GETBLOCKFMTS          =  2233;
  IDM_BLOCKFMT              =  2234;
  IDM_SHOWHIDE_CODE         =  2235;
  IDM_TABLE                 =  2236;

  IDM_COPYFORMAT            =  2237;
  IDM_PASTEFORMAT           =  2238;
  IDM_GOTO                  =  2239;

  IDM_CHANGEFONT            =  2240;
  IDM_CHANGEFONTSIZE        =  2241;
  IDM_INCFONTSIZE           =  2242;
  IDM_DECFONTSIZE           =  2243;
  IDM_INCFONTSIZE1PT        =  2244;
  IDM_DECFONTSIZE1PT        =  2245;
  IDM_CHANGECASE            =  2246;
  IDM_SUBSCRIPT             =  2247;
  IDM_SUPERSCRIPT           =  2248;
  IDM_SHOWSPECIALCHAR       =  2249;

  IDM_CENTERALIGNPARA       =  2250;
  IDM_LEFTALIGNPARA         =  2251;
  IDM_RIGHTALIGNPARA        =  2252;
  IDM_REMOVEPARAFORMAT      =  2253;
  IDM_APPLYNORMAL           =  2254;
  IDM_APPLYHEADING1         =  2255;
  IDM_APPLYHEADING2         =  2256;
  IDM_APPLYHEADING3         =  2257;

  IDM_DOCPROPERTIES         =  2260;
  IDM_ADDFAVORITES          =  2261;
  IDM_COPYSHORTCUT          =  2262;
  IDM_SAVEBACKGROUND        =  2263;
  IDM_SETWALLPAPER          =  2264;
  IDM_COPYBACKGROUND        =  2265;
  IDM_CREATESHORTCUT        =  2266;
  IDM_PAGE                  =  2267;
  IDM_SAVETARGET            =  2268;
  IDM_SHOWPICTURE           =  2269;
  IDM_SAVEPICTURE           =  2270;
  IDM_DYNSRCPLAY            =  2271;
  IDM_DYNSRCSTOP            =  2272;
  IDM_PRINTTARGET           =  2273;
  IDM_IMGARTPLAY            =  2274;
  IDM_IMGARTSTOP            =  2275;
  IDM_IMGARTREWIND          =  2276;
  IDM_PRINTQUERYJOBSPENDING =  2277;
  IDM_SETDESKTOPITEM        =  2278;

  IDM_CONTEXTMENU           =  2280;
  IDM_GOBACKWARD            =  2282;
  IDM_GOFORWARD             =  2283;
  IDM_PRESTOP               =  2284;

  IDM_CREATELINK            =  2290;
  IDM_COPYCONTENT           =  2291;

  IDM_LANGUAGE              =  2292;

  IDM_GETPRINTTEMPLATE      =  2295;
  IDM_TEMPLATE_PAGESETUP    =  2298;

  IDM_REFRESH               =  2300;
  IDM_STOPDOWNLOAD          =  2301;

  IDM_ENABLE_INTERACTION    =  2302;

  IDM_LAUNCHDEBUGGER        =  2310;
  IDM_BREAKATNEXT           =  2311;

  IDM_INSINPUTHIDDEN        =  2312;
  IDM_INSINPUTPASSWORD      =  2313;

  IDM_OVERWRITE             =  2314;

  IDM_PARSECOMPLETE         =  2315;

  IDM_HTMLEDITMODE          =  2316;

  IDM_REGISTRYREFRESH       =  2317;
  IDM_COMPOSESETTINGS       =  2318;

  IDM_SHOWALLTAGS           =  2320;
  IDM_SHOWALIGNEDSITETAGS   =  2321;
  IDM_SHOWSCRIPTTAGS        =  2322;
  IDM_SHOWSTYLETAGS         =  2323;
  IDM_SHOWCOMMENTTAGS       =  2324;
  IDM_SHOWAREATAGS          =  2325;
  IDM_SHOWUNKNOWNTAGS       =  2326;
  IDM_SHOWMISCTAGS          =  2327;
  IDM_SHOWZEROBORDERATDESIGNTIME       =  2328;

  IDM_AUTODETECT            =  2329;

  IDM_SCRIPTDEBUGGER        =  2330;

  IDM_GETBYTESDOWNLOADED    =  2331;

  IDM_NOACTIVATENORMALOLECONTROLS      =  2332;
  IDM_NOACTIVATEDESIGNTIMECONTROLS     =  2333;
  IDM_NOACTIVATEJAVAAPPLETS            =  2334;

  IDM_NOFIXUPURLSONPASTE    =  2335;
  IDM_EMPTYGLYPHTABLE        = 2336;
  IDM_ADDTOGLYPHTABLE        = 2337;
  IDM_REMOVEFROMGLYPHTABLE   = 2338;
  IDM_REPLACEGLYPHCONTENTS   = 2339;

  IDM_SHOWWBRTAGS           =  2340;

  IDM_PERSISTSTREAMSYNC     =  2341;
  IDM_SETDIRTY              =  2342;
  IDM_RUNURLSCRIPT          =  2343;

  IDM_ZOOMRATIO             =  2344;
  IDM_GETZOOMNUMERATOR      =  2345;
  IDM_GETZOOMDENOMINATOR    =  2346;


  IDM_MIMECSET__FIRST__     =  3609;
  IDM_MIMECSET__LAST__      =  3640;

  // COMMANDS FOR COMPLEX TEXT
  IDM_DIRLTR                =  2350;
  IDM_DIRRTL                =  2351;
  IDM_BLOCKDIRLTR           =  2352;
  IDM_BLOCKDIRRTL           =  2353;
  IDM_INLINEDIRLTR          =  2354;
  IDM_INLINEDIRRTL          =  2355;

  // SHDOCVW
  IDM_ISTRUSTEDDLG          =  2356;

  // MSHTMLED
  IDM_INSERTSPAN            =  2357;
  IDM_LOCALIZEEDITOR        =  2358;

  // XML MIMEVIEWER
  IDM_SAVEPRETRANSFORMSOURCE = 2370;
  IDM_VIEWPRETRANSFORMSOURCE = 2371;

  // Scrollbar context menu
  IDM_SCROLL_HERE            = 2380;
  IDM_SCROLL_TOP             = 2381;
  IDM_SCROLL_BOTTOM          = 2382;
  IDM_SCROLL_PAGEUP          = 2383;
  IDM_SCROLL_PAGEDOWN        = 2384;
  IDM_SCROLL_UP       = 2385;
  IDM_SCROLL_DOWN     = 2386;
  IDM_SCROLL_LEFTEDGE = 2387;
  IDM_SCROLL_RIGHTEDGE = 2388;
  IDM_SCROLL_PAGELEFT  = 2389;
  IDM_SCROLL_PAGERIGHT = 2390;
  IDM_SCROLL_LEFT     =  2391;
  IDM_SCROLL_RIGHT    =  2392;

  // IE 6 Form Editing Commands
  IDM_MULTIPLESELECTION = 2393;
  IDM_2D_POSITION       = 2394;
  IDM_2D_ELEMENT        = 2395;
  IDM_1D_ELEMENT        = 2396;
  IDM_ABSOLUTE_POSITION = 2397;
  IDM_LIVERESIZE        = 2398;
  IDM_ATOMICSELECTION	  = 2399;

  // Auto URL detection mode
  IDM_AUTOURLDETECT_MODE = 2400;

  // Legacy IE50 compatible paste
  IDM_IE50_PASTE         = 2401;

  // ie50 paste mode
  IDM_IE50_PASTE_MODE    = 2402;

  // Printing support
  DM_GETIPRINT          = 2403;

  // for disabling selection handles
  IDM_DISABLE_EDITFOCUS_UI       = 2404;

  // for visibility/display in design
  IDM_RESPECTVISIBILITY_INDESIGN = 2405;

  // set css mode
  IDM_CSSEDITING_LEVEL           = 2406;

  // New outdent
  IDM_UI_OUTDENT              = 2407;

  // Printing Status
  IDM_UPDATEPAGESTATUS        = 2408;

  // IME Reconversion
  IDM_IME_ENABLE_RECONVERSION = 2409;

  IDM_OVERRIDE_CURSOR         = 2420;

  IDM_MENUEXT_FIRST__     =  3700;
  IDM_MENUEXT_LAST__      =  3732;
  IDM_MENUEXT_COUNT       =  3733;

  ID_EDITMODE             = 32801;

  // Commands mapped from the standard set.  We should
  // consider deleting them from public header files.

  IDM_OPEN                  =  2000;
  IDM_NEW                   =  2001;
  IDM_SAVE                  =  70;
  IDM_SAVEAS                =  71;
  IDM_SAVECOPYAS            =  2002;
  IDM_PRINTPREVIEW          =  2003;
  IDM_SHOWPRINT             =  2010;
  IDM_SHOWPAGESETUP         =  2011;
  IDM_PRINT                 =  27;
  IDM_PAGESETUP             =  2004;
  IDM_SPELL                 =  2005;
  IDM_PASTESPECIAL          =  2006;
  IDM_CLEARSELECTION        =  2007;
  IDM_PROPERTIES            =  28;
  IDM_REDO                  =  29;
  IDM_UNDO                  =  43;
  IDM_SELECTALL             =  31;
  IDM_ZOOMPERCENT           =  50;
  IDM_GETZOOM               =  68;
  IDM_STOP                  =  2138;
  IDM_COPY                  =  15;
  IDM_CUT                   =  16;
  IDM_PASTE                 =  26;


  // Defines for IDM_ZOOMPERCENT
  CMD_ZOOM_PAGEWIDTH = -1;
  CMD_ZOOM_ONEPAGE   = -2;
  CMD_ZOOM_TWOPAGES  = -3;
  CMD_ZOOM_SELECTION = -4;
  CMD_ZOOM_FIT       = -5;

  // IDMs for CGID_EditStateCommands group
  IDM_CONTEXT        = 1;
  IDM_HWND           = 2;

  // Shdocvw Execs on CGID_DocHostCommandHandler
  IDM_NEW_TOPLEVELWINDOW   = 7050;

  //
  // Commands exposed for VID, had to be moved from privcid.h
  //

  // Undo hack command for VID to force preservation of the undo stack across
  // arbitrary operations. Arye.
  IDM_PRESERVEUNDOALWAYS          = 6049;
  // Another hack for VID to persist default values
  IDM_PERSISTDEFAULTVALUES        = 7100;
  // And yet another hack for VID to not aggressively overwrite some meta tags.
  IDM_PROTECTMETATAGS             = 7101;

  //--------------------------------

  IDM_TRIED_IS_1D_ELEMENT       = 0;   //[out,VT_BOOL]
  IDM_TRIED_IS_2D_ELEMENT       = 1;   //[out,VT_BOOL]
  IDM_TRIED_NUDGE_ELEMENT       = 2;   //[in,VT_BYREF VARIANT.byref=LPPOINT]
  IDM_TRIED_SET_ALIGNMENT       = 3;   //[in,VT_BYREF VARIANT.byref=LPPOINT]
  IDM_TRIED_MAKE_ABSOLUTE       = 4;
  IDM_TRIED_LOCK_ELEMENT        = 5;
  IDM_TRIED_SEND_TO_BACK        = 6;
  IDM_TRIED_SEND_TO_FRONT       = 7;
  IDM_TRIED_SEND_BACKWARD       = 8;
  IDM_TRIED_SEND_FORWARD        = 9;
  IDM_TRIED_SEND_BEHIND_1D     = 10; 
  IDM_TRIED_SEND_FRONT_1D      = 11;
  IDM_TRIED_CONSTRAIN          = 12;   //[in,VT_BOOL]
  IDM_TRIED_SET_2D_DROP_MODE   = 13;   //[in,VT_BOOL]
  IDM_TRIED_INSERTROW          = 14;
  IDM_TRIED_INSERTCOL          = 15;
  IDM_TRIED_DELETEROWS         = 16;
  IDM_TRIED_DELETECOLS         = 17;
  IDM_TRIED_MERGECELLS         = 18;
  IDM_TRIED_SPLITCELL          = 19;
  IDM_TRIED_INSERTCELL         = 20;
  IDM_TRIED_DELETECELLS        = 21;
  IDM_TRIED_INSERTTABLE        = 22;   //[in, VT_ARRAY]
  IDM_TRIED_ACTIVATEACTIVEXCONTROLS = 23;
  IDM_TRIED_ACTIVATEAPPLETS    = 24;
  IDM_TRIED_ACTIVATEDTCS       = 25;
  IDM_TRIED_BACKCOLOR          = 26;
  IDM_TRIED_BLOCKFMT           = 27;
  IDM_TRIED_BOLD               = 28;
  IDM_TRIED_BROWSEMODE         = 29;
  IDM_TRIED_COPY               = 30;
  IDM_TRIED_CUT                = 31;
  IDM_TRIED_DELETE             = 32;
  IDM_TRIED_EDITMODE           = 33;
  IDM_TRIED_FIND               = 34;
  IDM_TRIED_FONT               = 35;
  IDM_TRIED_FONTNAME           = 36;
  IDM_TRIED_FONTSIZE           = 37;
  IDM_TRIED_FORECOLOR          = 38;
  IDM_TRIED_GETBLOCKFMTS       = 39;
  IDM_TRIED_HYPERLINK          = 40;
  IDM_TRIED_IMAGE              = 41;
  IDM_TRIED_INDENT             = 42;
  IDM_TRIED_ITALIC             = 43;
  IDM_TRIED_JUSTIFYCENTER      = 44;
  IDM_TRIED_JUSTIFYLEFT        = 45;
  IDM_TRIED_JUSTIFYRIGHT       = 46;
  IDM_TRIED_ORDERLIST          = 47;
  IDM_TRIED_OUTDENT            = 48;
  IDM_TRIED_PASTE              = 50;
  IDM_TRIED_PRINT              = 51;
  IDM_TRIED_REDO               = 52;
  IDM_TRIED_REMOVEFORMAT       = 53;
  IDM_TRIED_SELECTALL          = 54;
  IDM_TRIED_SHOWBORDERS        = 55;
  IDM_TRIED_SHOWDETAILS        = 56;
  IDM_TRIED_UNDERLINE          = 57;
  IDM_TRIED_UNDO               = 58;
  IDM_TRIED_UNLINK             = 59;
  IDM_TRIED_UNORDERLIST        = 60;
  IDM_TRIED_DOVERB             = 61;

//WARNING WARNING WARNING!!! Don't forget to modify IDM_TRIED_LAST_CID
//when you add new Command IDs

  IDM_TRIED_LAST_CID           = IDM_TRIED_DOVERB;


type
  PDOCHOSTUIINFO = ^TDOCHOSTUIINFO;
  TDOCHOSTUIINFO = record
    cbSize: ULONG;
    dwFlags: Cardinal;
    dwDoubleClick: Cardinal;
  end;
type
  IDocHostUIHandler = interface(IUnknown)
    ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
    function ShowContextMenu( const dwID: Cardinal; const ppt: PPOINT;
      const pcmdtReserved: IUnknown; const pdispReserved: IDispatch ): HRESULT; stdcall;
    function GetHostInfo( var pInfo: TDOCHOSTUIINFO ): HRESULT; stdcall;
    function ShowUI( const dwID: Cardinal; const pActiveObject: IOleInPlaceActiveObject;
      const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
      const pDoc: IOleInPlaceUIWindow ): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless( const fEnable: BOOL ): HRESULT; stdcall;
    function OnDocWindowActivate( const fActivate: BOOL ): HRESULT; stdcall;
    function OnFrameWindowActivate( const fActivate: BOOL ): HRESULT; stdcall;
    function ResizeBorder( const prcBorder: PRECT;
      const pUIWindow: IOleInPlaceUIWindow;
      const fRameWindow: BOOL ): HRESULT; stdcall;
    function TranslateAccelerator( const lpMsg: PMSG; const pguidCmdGroup: PGUID;
      const nCmdID: Cardinal): HRESULT; stdcall;
    function GetOptionKeyPath( var pchKey: POLESTR; const dw: Cardinal ): HRESULT; stdcall;
    function GetDropTarget( const pDropTarget: IDropTarget;
      out ppDropTarget: IDropTarget ): HRESULT; stdcall;
    function GetExternal( out ppDispatch: IDispatch ): HRESULT; stdcall;
    function TranslateUrl( const dwTranslate: Cardinal; const pchURLIn: POLESTR;
      var ppchURLOut: POLESTR ): HRESULT; stdcall;
    function FilterDataObject( const pDO: IDataObject;
      out ppDORet: IDataObject ): HRESULT; stdcall;
  end; // IDocHostUIHandler

  ICustomDoc = interface(IUnknown)
   ['{3050f3f0-98b5-11cf-bb82-00aa00bdce0b}']

   function SetUIHandler (const pUIHandler : IDocHostUIHandler) : HRESULT; stdcall;

  end; // ICustomDoc 

  IDocHostShowUI = interface(IUnknown)
     ['{c4d244b0-d43e-11cf-893b-00aa00bdce1a}']

     function ShowMessage(hwnd : THandle; 
                          lpstrText : POLESTR;
                          lpstrCaption : POLESTR;
                          dwType : longint;
                          lpstrHelpFile : POLESTR;
                          dwHelpContext : longint;
                          var plResult : LRESULT) : HRESULT; stdcall;
                           
      function ShowHelp(hwnd : THandle;
                        pszHelpFile : POLESTR;
                        uCommand : integer;
                        dwData : longint;
                        ptMouse : TPoint;
                        var pDispachObjectHit : IDispatch) : HRESULT; stdcall;
  
  end; // IDocHostShowUI


implementation

end.
