unit fChangeLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, uCore, ORNet, uHTMLTools, VAUtils;

type
  TfrmChangeLog = class(TForm)
    wbChangeLog: TWebBrowser;
    btnClose: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChangeLog: TfrmChangeLog;

procedure ViewChangeLog(CPRSVersion:string);

implementation

{$R *.dfm}

procedure ViewChangeLog(CPRSVersion:string);
var ChangeLog:TStringList;
    HTMLFile:String;
    frmChangeLog: TfrmChangeLog;
begin
   ChangeLog := TStringList.create();
   tCallV(ChangeLog,'TMG CPRS CHANGE LOG',[User.DUZ,CPRSVersion]);
   if piece(ChangeLog[0],'^',1)='1' then begin
     ChangeLog.Delete(0);
     HTMLFile := CPRSCacheDir+'ChangeLog.html';
     ChangeLog.SaveToFile(HTMLFile);
     frmChangeLog := TfrmChangeLog.create(nil);
     frmChangeLog.wbChangeLog.Navigate(HTMLFile);
     frmChangeLog.ShowModal;
     frmChangeLog.Free;
   end;
   ChangeLog.Free;
end;



end.

