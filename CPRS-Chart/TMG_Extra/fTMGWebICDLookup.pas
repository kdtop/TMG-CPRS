unit fTMGWebICDLookup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  HTTPUtil,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls;

type
  TfrmWebICDLookup = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    WebBrowser: TWebBrowser;
    Label1: TLabel;
    procedure WebBrowserDownloadComplete(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetSearchTerm(Term : string);
  end;

//var
//  frmWebICDLookup: TfrmWebICDLookup;

implementation

{$R *.dfm}

  procedure TfrmWebICDLookup.SetSearchTerm(Term : string);
  var
    URL : wideString;
  begin
    URL := 'https://www.whatismybrowser.com/'; //'http://www.icd10data.com';
    if Term <> '' then begin
      URL := URL + '/search?s=' + HTTPUtil.HTMLEscape(Term);
    end;
    WebBrowser.Navigate(URL);
  end;


procedure TfrmWebICDLookup.WebBrowserDownloadComplete(Sender: TObject);
begin
   Label1.Caption := WebBrowser.LocationName;
end;

end.
