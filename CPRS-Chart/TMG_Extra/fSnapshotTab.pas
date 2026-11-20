unit fSnapshotTab;
//kt //codex added entire unit 11/20/26

interface

uses
  Classes, Controls, ExtCtrls, Buttons, OleCtrls, SHDocVw, fPage,
  VA508AccessibilityManager, Vcl.StdCtrls;

type
  TfrmSnapshotTab = class(TfrmPage)
    pnlSnapshotBanner: TPanel;
    pnlSnapshotBottom: TPanel;
    btnCloseSnapshot: TBitBtn;
    pnlSnapshotContent: TPanel;
    procedure btnCloseSnapshotClick(Sender: TObject);
  private
    FBrowser: TWebBrowser;
    FPendingHTML: string;
    FHasPendingHTML: Boolean;
    FOnCloseClick: TNotifyEvent;
    procedure BrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
  public
    constructor CreateSnapshot(AOwner: TComponent; AParent: TWinControl; const HTML: string; OnCloseClick: TNotifyEvent);
    procedure LoadSnapshot;
  end;

var
  frmSnapshotTab: TfrmSnapshotTab;

implementation

uses SysUtils, Variants, MSHTML, ActiveX;

{$R *.dfm}

constructor TfrmSnapshotTab.CreateSnapshot(AOwner: TComponent; AParent: TWinControl; const HTML: string; OnCloseClick: TNotifyEvent);
//kt //codex added entire procedure 11/20/26
begin
  inherited Create(nil);
  Name := '';
  if Assigned(AOwner) then begin
    AOwner.InsertComponent(Self);
  end;
  Parent := AParent;
  Align := alClient;
  Visible := False;
  FPendingHTML := HTML;
  FHasPendingHTML := True;
  FOnCloseClick := OnCloseClick;
  FBrowser := TWebBrowser.Create(Self);
  TWinControl(FBrowser).Parent := pnlSnapshotContent;
  FBrowser.Align := alClient;
  FBrowser.OnDocumentComplete := BrowserDocumentComplete;
end;

procedure TfrmSnapshotTab.btnCloseSnapshotClick(Sender: TObject);
//kt //codex added entire procedure 11/20/26
begin
  if Assigned(FOnCloseClick) then begin
    FOnCloseClick(Sender);
  end;
end;

procedure TfrmSnapshotTab.LoadSnapshot;
//kt //codex added entire procedure 11/20/26
begin
  FBrowser.Navigate('about:blank');
end;

procedure TfrmSnapshotTab.BrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
//kt //codex added entire procedure 11/20/26
var
  WebDoc: IHTMLDocument2;
  Content: OleVariant;
  HTML: string;
begin
  if not FHasPendingHTML or not Assigned(FBrowser.Document) then begin
    Exit;
  end;
  FHasPendingHTML := False;
  HTML := FPendingHTML;
  FPendingHTML := '';
  WebDoc := FBrowser.Document as IHTMLDocument2;
  Content := VarArrayCreate([0, 0], varVariant);
  Content[0] := HTML;
  WebDoc.write(PSafeArray(TVarData(Content).VArray));
  WebDoc.close;
  if Assigned(WebDoc.body) then begin
    WebDoc.body.setAttribute('contentEditable', 'false', 0);
    WebDoc.body.style.cssText := WebDoc.body.style.cssText +
      ';background-image:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA5MDAgNTAwIj48ZyB0cmFuc2Zvcm09InJvdGF0ZSgtMjUgNDUwIDI1MCkiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXdlaWdodD0iYm9sZCIgZmlsbD0iIzkwMzAyMCIgZmlsbC1vcGFjaXR5PSIwLjEyIj48dGV4dCB4PSI0NTAiIHk9IjI1MCIgZm9udC1zaXplPSIxMTAiPlNOQVBTSE9UPC90ZXh0Pjx0ZXh0IHg9IjQ1MCIgeT0iMzI1IiBmb250LXNpemU9IjUwIj5WSUVXIE9OTFk8L3RleHQ+PC9nPjwvc3ZnPg==);' +
      'background-repeat:no-repeat;background-position:center center;' +
      'background-attachment:fixed;background-size:80% auto;';
  end;
end;

end.
