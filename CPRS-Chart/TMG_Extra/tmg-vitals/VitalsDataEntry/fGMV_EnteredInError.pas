unit fGMV_EnteredInError;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 4/29/05 3:20p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Utility for marking vitals in error.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry/fGMV_EnteredInError.pas $
*
* $History: fGMV_EnteredInError.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
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
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 5/22/03    Time: 10:16a
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Preparation to CCOW
 * MessageDLG changed to MessageDLGS
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:46p
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Version 5.0.1.5
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 5  *****************
 * User: Vhaishandria Date: 12/20/02   Time: 3:02p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 10/11/02   Time: 6:21p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version vT32_1
 * 
 * *****************  Version 3  *****************
 * User: Vhaishpetitd Date: 6/20/02    Time: 9:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * t27 Build
 *
 * *****************  Version 2  *****************
 * User: Vhaishpetitd Date: 6/06/02    Time: 11:14a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Roll-up to 5.0.0.27
 *
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 11:58a
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
  Buttons,
  CheckLst,
  MFunStr,
  uGMV_Common,
  ComCtrls;

type
  TfrmGMV_EnteredInError = class(TForm)
    GroupBox1: TGroupBox;
    rgReason: TRadioGroup;
    dtpDate: TDateTimePicker;
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    lvVitals: TListView;
    procedure DateChange(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkToProceed(Sender: TObject);
    procedure ClearList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvVitalsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPatientIEN: string;
    { Private declarations }
  public
    { Public declarations }
  end;

function EnterVitalsInError(DFN: string): Integer;
function EnteredInErrorByDate(DFN: string;aDate:TDateTime): Integer;

implementation

uses uGMV_FileEntry, uGMV_User, uGMV_Engine, fGMV_PtInfo
;

{$R *.DFM}

function EnterVitalsInError(DFN: string): Integer;
var
  TimeToStart: TDateTime;
begin
  TimeToStart := getServerWDateTime;
  TimeToStart := Trunc(TimeToStart)+1 - 1/(3600*24);
  Result := EnteredInErrorByDate(DFN,TimeToStart);
end;

function EnteredInErrorByDate(DFN: string;aDate:TDateTime): Integer;
begin
  with TfrmGMV_EnteredInError.Create(Application) do
    try
      FPatientIEN := DFN;
      dtpDate.Date := aDate;
      if dtpDate.Date = 0 then
          dtpDate.Date := Now;
      DateChange(nil);
      Result := ShowModal;
    finally
      free;
    end;
end;

procedure TfrmGMV_EnteredInError.FormCreate(Sender: TObject);
begin
  ClearList;
  dtpDate.Date := getServerWDateTime;
  if dtpDate.Date = 0 then
    begin
      dtpDate.Date := Now;
    end;
end;

procedure TfrmGMV_EnteredInError.DateChange(Sender: TObject);
var
  s: String;
  dt: Double;
  i: integer;
  RetList : TStrings;
begin
  ClearList;
  dt := WindowsDateToFMDate(dtpDate.Date);

  RetList := getGMVRecord(FPatientIEN + '^' + FloatToStr(dt) + '^^' + FloatToStr(dt));

  if (RetList.Count > 0) and (Piece(RetList[0], '^', 1) <> '0') then
    for i := 0 to RetList.Count - 1 do
      if Copy(RetList[i], 1, 1) <> ' ' then
        with lvVitals.Items.Add do
          begin
            s := RetList[i];
            Caption := Piece(Piece(RetList[i], '^', 2), ' ', 1);
            s := trim(Copy(RetList[i], Pos(' ', RetList[i]), 255));
            SubItems.Add(piece(s,'_',1));
            SubItems.Add(piece(s,'_',2));
            Data := TGMV_FileEntry.CreateFromRPC('120.51;' + RetList[i]);
          end;
  RetList.Free;
end;

procedure TfrmGMV_EnteredInError.ClearList;
begin
  lvVitals.Items.BeginUpdate;
  while lvVitals.Items.Count > 0 do
    begin
      if lvVitals.Items[0].Data <> nil then
        TGMV_FileEntry(lvVitals.Items[0].Data).Free;
      lvVitals.Items.Delete(0);
    end;
  lvVitals.Items.EndUpdate;
  btnOK.Enabled := False;
  rgReason.Enabled := False;
  rgReason.ItemIndex := -1;
end;

procedure TfrmGMV_EnteredInError.OkButtonClick(Sender: TObject);
var
  j,i: integer;
  sDUZ,
  s: String;
  RetList:TStrings;
begin
  if rgReason.ItemIndex < 0 then
    MessageDlg('No reason has been selected.', mtError, [mbok], 0)
  else
    begin
      S := '';
      j := 0;
      for i := 0 to lvVitals.Items.Count - 1 do
        if lvVitals.Items[i].Selected then
          begin
            inc(j);
            S := S + lvVitals.Items[i].Caption +'  '
              + lvVitals.Items[i].SubItems[0]
              + #13;
          end;
{
      if AskConfirmation('Entered In Error Confirmation Request',
        'Are you sure you want to mark the next list of vitals as "'+rgReason.Items[rgReason.ItemIndex]+'"?',
         s
        )
}
      if MessageDlg('Are you sure you want to mark '+IntToStr(j)+' vitals sign records as '
        + rgReason.Items[rgReason.ItemIndex]+'?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
           Exit;

      sDUZ := getUserDUZString;
      for i := 0 to lvVitals.Items.Count - 1 do
        if lvVitals.Items[i].Selected then
          with TGMV_FileEntry(lvVitals.Items[i].Data) do
            begin
              RetList := setGMVErrorRecord(IEN + '^' + sDUZ + '^' + IntToStr(rgReason.ItemIndex + 1));
              RetList.Free;
            end;
//      MessageDlg('Vitals:'+#13#10#13#10+s+#13#10#13#10+'marked as ' + rgReason.Items[rgReason.ItemIndex],mtInformation,[mbOk],0);
//      ShowInfo('Entered In Error Result','Vitals:'+#13#10#13#10+s+#13#10#13#10+'marked as ' + rgReason.Items[rgReason.ItemIndex]);
      ModalResult := mrOK;
    end;
end;

procedure TfrmGMV_EnteredInError.OkToProceed(Sender: TObject);
begin
  btnOK.Enabled := (rgReason.ItemIndex > -1)
    and (lvVitals.SelCount > 0) and  (rgReason.ItemIndex >= 0);
end;

procedure TfrmGMV_EnteredInError.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearList;
end;

procedure TfrmGMV_EnteredInError.lvVitalsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  rgReason.Enabled := (lvVitals.ItemFocused <> nil) or (lvVitals.SelCount > 0);
end;

procedure TfrmGMV_EnteredInError.FormResize(Sender: TObject);
begin
  lvVitals.Columns[1].Width := lvVitals.Width - lvVitals.Columns[0].Width - lvVitals.Columns[2].Width- 4;
end;

procedure TfrmGMV_EnteredInError.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

end.

