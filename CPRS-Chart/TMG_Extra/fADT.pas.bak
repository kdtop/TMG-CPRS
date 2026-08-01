unit fADT;
 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
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

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Registry, FileCtrl,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ORFn, ORNet, TRPCB, uCore, ORCtrls, ORDtTm, fFrame, rCore, OleCtrls, SHDocVw;

type
  TfrmADT = class(TForm)
    PageControl1: TPageControl;
    Admit: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    rgrpAdmitType: TRadioGroup;
    cmbPhysicians: TORComboBox;
    cmbFTSPEC: TORComboBox;
    Label3: TLabel;
    cmbWard: TORComboBox;
    Label4: TLabel;
    cmbRoomBed: TORComboBox;
    Label5: TLabel;
    edtDiag: TEdit;
    Label6: TLabel;
    dtAdmit: TORDateBox;
    ADTType: TRadioGroup;
    Label7: TLabel;
    cmbMovement: TORComboBox;
    Census: TTabSheet;
    cmbWardForCensus: TORComboBox;
    Label8: TLabel;
    Memo1: TMemo;
    btnPrint: TButton;
    WebBrowser1: TWebBrowser;
    btnExport: TButton;
    Label9: TLabel;
    edtReferral: TEdit;
    procedure btnExportClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure cmbWardForCensusChange(Sender: TObject);
    procedure ADTTypeClick(Sender: TObject);
    procedure btnDischargeClick(Sender: TObject);
    procedure cmbWardChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    tsBed : TStringList;
    //Admitted : boolean;
    AdmissionNumber : string;
    procedure SaveADT;
    procedure SetType;
  public
    { Public declarations }
  end;

//var
//  frmADT: TfrmADT;

procedure OpenADT;

implementation

{$R *.dfm}
uses  uTMGOptions;

procedure OpenADT;
var
  frmADT: TfrmADT;
begin
  frmADT := TfrmADT.Create(Application);
  frmADT.tsBed := TStringList.Create();
  frmADT.ShowModal;
  frmADT.Free;
end;


procedure TfrmADT.btnDischargeClick(Sender: TObject);
begin
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'VEFA ADT DISCHARGE PATIENT';
    Param[0].PType := list;
    //[Required,Numeric] Patient IEN
    Param[0].Mult['"ADMIFN"'] := AdmissionNumber;
    //[Required, DateTime] Admission date FMDate with time
    //remove  Param[0].Mult['"DATE"'] := floattostr(dtAdmit.FMDateTime); //(dtAdmit.FMDateTime); //  '3/14/15';
    Param[0].Mult['"DATE"'] := '3130505.1122';
    Param[0].Mult['"TYPE"'] := '0';
  end;
//PARAM(“DATE”) [Required, DateTime] Discharge date
//PARAM(“TYPE”) [Required,Numeric] Discharge type (one of the codes returned by LSTDTYP^DGPMAPI7)
//PARAM(“ADMIFN”) [Required,Numeric] Admission IEN
end;

procedure TfrmADT.btnExportClick(Sender: TObject);
    function GetDesktopFolder:string;
    var
     theReg  : TRegistry;
     KeyName : String;
    begin
     result := '';
     theReg := TRegistry.Create;
     KeyName := 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
     if (theReg.KeyExists(KeyName)) then begin
         theReg.OpenKey(KeyName, False);
         Result := theReg.ReadString('Desktop');
         if result='' then result := theReg.ReadString('Common Desktop');
         if result='' then result := 'C:\';
     end else begin
         theReg.OpenKey(KeyName, True);
         result := 'C:\';
       end;
     theReg.Free;
    end;
var
    tslist :tstringlist;
    //i : integer;
    chosenDirectory,saveFile : string;
begin
  inherited;
  tslist := tstringlist.Create;

  // Ask the user to select a required directory, starting with C:
  if not SelectDirectory('Select a directory to save file.', GetDesktopFolder, chosenDirectory) then begin
    ShowMessage('A directory was not chosen.');
    exit;
  end;
  saveFile := chosenDirectory+'\'+cmbWardForCensus.Text+'.csv';

  if FileExists(saveFile) then begin
    if messagedlg('File exists at '+chosenDirectory+'. Would you like to replace this file?',mtWarning,[mbYes,mbNo],0)=mrYes then begin
      DeleteFile(saveFile);
    end else begin
      exit;
    end;
  end;

  tCallV(tslist,'VEFA ADT CENSUS REPORT CSV',[piece(cmbWardForCensus.Items[cmbWardForCensus.ItemIndex],'^',2)]);
  tslist.SaveToFile(saveFile);
  tslist.Free;
  if FileExists(saveFile) then
    ShowMessage('File saved at: '+saveFile)
  else
    ShowMessage('File Not Saved! Ensure you have proper permission to save at this location.');
end;


procedure TfrmADT.btnPrintClick(Sender: TObject);
var
   vIn, vOut: OleVariant;
begin
   WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vIn, vOut) ;
end;

procedure TfrmADT.Button1Click(Sender: TObject);
begin
  SaveADT;
end;

procedure TfrmADT.cmbWardChange(Sender: TObject);
var
   BedList : TStringList;
   i : integer;
begin     
  BedList := TStringList.Create();
  for i := 0 to tsBed.Count - 1 do begin
     if piece(tsBed[i],'^',1)=inttostr(cmbWard.itemindex) then begin
       BedList.add(piece(tsBed[i],'^',2)+'^'+piece(tsBed[i],'^',3));
     end;
  end;
  cmbRoomBed.Items.Clear;
  if BedList.Count>0 then begin
     cmbRoomBed.Items.Assign(BedList);
  //   Button1.Enabled := true;
  end else begin
     cmbRoomBed.Items.Add('No Beds Available');
  //   Button1.Enabled := false;
  end;
  cmbRoomBed.ItemIndex := 0;
  BedList.free;

end;

procedure TfrmADT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tsBed.Free;
  //frmADT.release;
end;

procedure TfrmADT.FormShow(Sender: TObject);
var
  PtRec: TPtIDInfo;
  DfltValue : String;
  RPCResult: TStringList;
  TempTSList: TStringList;
  i,j :integer;
begin
   rgrpAdmitType.ItemIndex := 0;
   RPCResult := TStringList.Create();
   if Patient.Inpatient then begin
     tCallV(RPCResult,'ORWPT ADMITLST',[Patient.DFN]);
     AdmissionNumber := piece(RPCResult[0],'^',5);
   end;
   tCallV(RPCResult,'VEFA ADT GET PARAMS', ['FTSPEC']);
   cmbFTSPEC.Items.Assign(RPCResult);
   DfltValue := uTMGOptions.ReadString('ADT Default Specialty','');
   if DfltValue = '' then
     j := -1
   else
     j := cmbFTSPEC.Items.IndexOf(DfltValue);

   if j < 0  then j := 0;

   cmbFTSPEC.ItemIndex := j;
   RPCResult.Clear;
   tCallV(RPCResult,'VEFA ADT GET PARAMS', ['ATNDPHY']);
   cmbPhysicians.Items.Assign(RPCResult);
   cmbPhysicians.ItemIndex := 0;
   RPCResult.Clear;
   tCallV(RPCResult,'VEFA ADT GET PARAMS', ['ROOMBED']);
   TempTSList := TStringList.Create();
   tsBed.clear;
   for i := 0 to RPCResult.Count - 1 do begin
     if piece(RPCResult[i],'^',1)='WARD' then
       TempTSList.Add(piece(RPCResult[i],'^',2)+'^'+piece(RPCResult[i],'^',3))
     else
       tsBed.Add(RPCResult[i]);
    cmbWard.Items.Assign(TempTSList);
    cmbWard.ItemIndex := 0;
    cmbWardForCensus.Items.Clear;
    cmbWardForCensus.Items.Add('Aggregate Report^AggRpt');
    cmbWardForCensus.Items.Add('Summary Report^SumRpt');
    for j := 0 to TempTSList.Count - 1 do begin
       cmbWardForCensus.Items.Add(TempTSList[j]);
    end;
    cmbWardForCensus.ItemIndex := 0;
   end;
   TempTSList.free;
   cmbWardChange(self);
   tCallV(RPCResult,'VEFA ADT GET PARAMS', ['MOVEMENT']);
   cmbMovement.Items.Assign(RPCResult);

   DfltValue := uTMGOptions.ReadString('ADT Default Movement','');
   if DfltValue = '' then
     j := -1
   else
     j := cmbMovement.Items.IndexOf(DfltValue);

   if j < 0  then j := 0;

   cmbMovement.ItemIndex := j;
   RPCResult.Clear;
    //Load all comboboxes here
   RPCResult.Free;
   if AdmissionNumber<>'' then begin
    TRadioButton(ADTType.Controls[0]).Enabled := False;
    ADTType.ItemIndex :=1;
    PtRec := GetPtIDInfo(Patient.DFN);
    ADTType.Caption := 'Currently admitted to ' + PtRec.Location + ' ' + PtRec.RoomBed;
  end else begin
    TRadioButton(ADTType.Controls[1]).Enabled := False;
    TRadioButton(ADTType.Controls[2]).Enabled := False;
    ADTType.Caption := 'Patient is NOT admitted';
    ADTType.ItemIndex := 0;
  end;
   SetType;
   cmbWardForCensusChange(nil);
   PageControl1.ActivePageIndex := 0;
end;

procedure TfrmADT.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePageIndex=0 then begin
    Button1.visible := True;
    Button2.Caption := '&Cancel';
  end else if PageControl1.ActivePageIndex=1 then begin
    Button1.Visible := False;
    Button2.Caption := '&Close';
  end;
end;

procedure TfrmADT.cmbWardForCensusChange(Sender: TObject);
  procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
    var
       MyHTML: TStringList;
       TempFile: string;
    begin
       MyHTML := TStringList.create;
       //TempFile := ExtractFilePath(ParamStr(0))+ 'Cache'+'\Temp.html';
       TempFile := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\Temp.html';
       try
         MyHTML.add(HTMLCode);
         MyHTML.SaveToFile(TempFile);
        finally
         MyHTML.Free;
        end;
       WebBrowser.Navigate(TempFile) ;

       while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;
    end;  {WBLoadHTML}
//var
   //tsPatientList: TStringList;
   //ptstring : string;
   //i : integer;
begin
  Memo1.Clear;
  tCallV(Memo1.Lines,'VEFA ADT CENSUS REPORT',[piece(cmbWardForCensus.Items[cmbWardForCensus.ItemIndex],'^',2)]);
  WBLoadHTML(WebBrowser1,Memo1.Lines.Text);
  {tsPatientList := TStringList.Create();
  Memo1.Lines.Add('Census Report For: ' + cmbWardForCensus.text);  
  ListPtByWard(tsPatientList, strtoint(piece(cmbWardForCensus.Items[cmbWard.ItemIndex],'^',2)));
  for i := 0 to tsPatientList.Count - 1 do begin
    ptstring := ' -- '+piece(tsPatientList.Strings[i],'^',2);
    if piece(tsPatientList.Strings[i],'^',3)<>'' then
      ptstring := ptstring + '('+piece(tsPatientList.Strings[i],'^',3)+')';
    Memo1.Lines.Add(ptstring);
  end;
  tsPatientList.Free;}
end;

procedure TfrmADT.ADTTypeClick(Sender: TObject);
begin
  SetType;
end;

procedure TfrmADT.SetType;
begin
  if ADTType.ItemIndex=0 then begin
    Label1.Caption := 'Admission Date';
  end else if ADTType.ItemIndex=1 then begin
    Label1.Caption := 'Transfer Date';
  end else begin
    Label1.Caption := 'Discharge Date';
  end;


  Label2.Visible := (ADTType.ItemIndex=0);
  Label3.visible := (ADTType.ItemIndex=0);
  Label4.visible := (ADTType.ItemIndex<>2);
  Label5.Visible := (ADTType.ItemIndex<>2);
  Label6.Visible := (ADTType.ItemIndex=0);
  Label7.Visible := (ADTType.ItemIndex<>0);
  Label9.Visible := (ADTType.ItemIndex=0);
  cmbMovement.visible := (ADTType.ItemIndex<>0);
  cmbPhysicians.visible := (ADTType.ItemIndex=0);
  rgrpAdmitType.visible := (ADTType.ItemIndex=0);
  cmbFTSPEC.visible := (ADTType.ItemIndex=0);
  cmbWard.visible := (ADTType.ItemIndex<>2);
  cmbRoomBed.visible := (ADTType.ItemIndex<>2);
  edtDiag.Visible := (ADTType.ItemIndex=0);
  edtReferral.Visible := (ADTType.ItemIndex=0);
end;

procedure TfrmADT.SaveADT;
VAR
  date:string;
begin
  date := FormatFMDateTime('mm/dd/yy@hh:nn', dtAdmit.FMDateTime);
  if ADTType.ItemIndex=0 then begin
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'VEFA ADT ADMIT PATIENT';
      Param[0].PType := list;
      //[Required,Numeric] Patient IEN
      Param[0].Mult['"PATIENT"'] := Patient.DFN;
      //[Required, DateTime] Admission date FMDate with time
      //Param[0].Mult['"DATE"'] := floattostr(dtAdmit.FMDateTime); //(dtAdmit.FMDateTime); //  '3/14/15';
      Param[0].Mult['"DATE"'] := date;
      //Param[0].Mult['"DATE"'] := '3/14/15';
      //[Required,Numeric] Admission type
      if rgrpAdmitType.ItemIndex=0 then
         Param[0].Mult['"TYPE"'] := '1' //1 (Direct) or 5 (Transfer)
      else
         Param[0].Mult['"TYPE"'] := '5';
            //Need more categories or just hide it say direct and use a free text comment for the census report.
      //[Required,Numeric] Admitting regulation
      Param[0].Mult['"ADMREG"'] := '4';  //4 -  17.45
      //[Required,Numeric] Attending physician
      Param[0].Mult['"ATNDPHY"'] := piece(cmbPhysicians.items[cmbPhysicians.itemIndex],'^',2); //ToDo;    //Drop down pick list.
      //[Required,Boolean] Set to 1 if patient wants to be excluded from Facility Directory for this admission
      Param[0].Mult['"FDEXC"'] := '1';
      //[Required,String] A brief description of the diagnosis
      Param[0].Mult['"SHDIAG"'] :=  edtDiag.Text; //ToDo; //Drop down of problem list and pick from problem list.
      //[Optional,Boolean] Set to 1 if patient is admitted for service connected
      Param[0].Mult['"ADMSCC"'] := '0';
      //[Required,Numeric] Facility treating specialty
      Param[0].Mult['"FTSPEC"'] := piece(cmbFTSPEC.Items[cmbFTSPEC.ItemIndex],'^',2); //ToDo; //PSYCHIATRIC OBSERVATION
      //[Required,Numeric] Ward location
      Param[0].Mult['"WARD"'] := piece(cmbWard.Items[cmbWard.ItemIndex],'^',2); //ToDo; //Pick list.
      //[Optional,Boolean] Set to 1 if patient is admitted for service connected condition
      Param[0].Mult['"ADMSCC"'] := '3'; // 3 ????
      //[Optional,Numeric] Source of admission
      //Param[0].Mult['"ADMSRC"'] := ToDo;
      //[Optional,Numeric] Admitting eligibility
      //Param[0].Mult['"ELIGIB"'] := ToDo;
      //[Optional,Numeric] Primary physician
      //Param[0].Mult['"PRYMPHY"'] := ToDo; //Ignore.
      //[Optional,Numeric] Roombed
      Param[0].Mult['"ROOMBED"'] := piece(cmbRoomBed.Items[cmbRoomBed.ItemIndex],'^',2); //Pick list.
      //[Optional,Numeric] Admitting Category
      //Param[0].Mult['"ADMCAT"'] := ToDo; //
      //[Optional,Boolean] Set to 1 if this admission is a result of a previously scheduled appt
      //Param[0].Mult['"SCADM"'] := ToDo;
      //[Optional,String] Array of diagnoses
      //Param[0].Mult['"DIAG"'] := ToDo;   //;”,#) [Optional,String] Array of diagnoses
      Param[0].Mult['"REFER"'] := edtReferral.text;
      CallBroker;
    end;
  end else if ADTType.ItemIndex=1 then begin
    date := FormatFMDateTime('mm/dd/yy@hh:nn', dtAdmit.FMDateTime);
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'VEFA ADT TRANSFER PATIENT';
      Param[0].PType := list;
      Param[0].Mult['"ADMIFN"'] := AdmissionNumber;
      Param[0].Mult['"TYPE"'] := piece(cmbMovement.Items[cmbMovement.ItemIndex],'^',2);
      Param[0].Mult['"DATE"'] := date;
      Param[0].Mult['"ROOMBED"'] := piece(cmbRoomBed.Items[cmbRoomBed.ItemIndex],'^',2); //Pick list.
      Param[0].Mult['"WARD"'] := piece(cmbWard.Items[cmbWard.ItemIndex],'^',2); //ToDo; //Pick list.
      CallBroker;
      //messagedlg(Results.Text,mtinformation,[mbOK],0);
    end;
  end else if ADTType.ItemIndex=2 then begin
    date := FormatFMDateTime('mm/dd/yy@hh:nn', dtAdmit.FMDateTime);
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'VEFA ADT DISCHARGE PATIENT';
      Param[0].PType := list;
      //[Required,Numeric] Patient IEN
     // temp := floattostr(dtAdmit.FMDateTime);
     // showmessage(temp);
      Param[0].Mult['"ADMIFN"'] := AdmissionNumber;
      //[Required, DateTime] Admission date FMDate with time
      //Param[0].Mult['"DATE"'] := temp;  //floattostr(dtAdmit.FMDateTime); //(dtAdmit.FMDateTime); //  '3/14/15';
      //temp := '3/14/15'; //'3140611.1122';
      //temp := FormatFMDateTime('mm/dd/yy', dtAdmit.FMDateTime);
      //temp := dtAdmit.text;
      Param[0].Mult['"DATE"'] := date;
      Param[0].Mult['"TYPE"'] := piece(cmbMovement.Items[cmbMovement.ItemIndex],'^',2);
      CallBroker;
      //messagedlg(Results.Text,mtinformation,[mbOK],0);
    end;
  end;
  if piece(RPCBrokerV.Results.Strings[0],'^',1)='0' then begin
    messagedlg(piece(RPCBrokerV.Results.Strings[0],'^',3),mtinformation,[mbOK],0);
  end else begin
    frmFrame.UpdatePtInfoOnRefresh;
    ModalResult := mrOK;
  end;
end;

end.

