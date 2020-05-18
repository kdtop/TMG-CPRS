unit fSignItem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, rCore, Hash, ORCtrls, fBase508Form, VA508AccessibilityManager, ExtCtrls;

type
  TfrmSignItem = class(TfrmBase508Form)
    txtESCode: TCaptionEdit;
    lblESCode: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblText: TMemo;
    imgPWSaved: TImage;
    Timer1: TTimer;
    CLBubble: TShape;
    CLLabel: TLabel;
    procedure Timer1Timer(Sender: TObject);  //kt added
    procedure txtESCodeKeyPress(Sender: TObject; var Key: Char);   //kt added
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FESCode: string;
  public
    { Public declarations }
  end;

procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);

implementation

{$R *.DFM}
uses
  uSavedSignature;  //kt added 11/15

const
  TX_INVAL_MSG = 'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP = 'Unrecognized Signature Code';


procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);
var
  frmSignItem: TfrmSignItem;
begin
  frmSignItem := TfrmSignItem.Create(Application);
  try
    ResizeAnchoredFormToFont(frmSignItem);
    with frmSignItem do
    begin
      FESCode := '';
      Caption := ACaption;
      lblText.Text := AText;
      txtESCode.Text := SavedSignature.Value; //kt added 11/15 -- returns '' unless saved in past few minutes.
      imgPWSaved.Visible := (Trim(txtESCode.Text) <> '');  //kt added 11/15
      ShowModal;
      ESCode := FESCode;
    end;
  finally
    frmSignItem.Release;
  end;
end;

procedure TfrmSignItem.cmdOKClick(Sender: TObject);
begin
  if not ValidESCode(txtESCode.Text) then
  begin
    InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
    txtESCode.SetFocus;
    txtESCode.SelectAll;
    SavedSignature.Clear;  //kt added 11/5
    Exit;
  end;
  FESCode := Encrypt(txtESCode.Text);
  SavedSignature.Remember(txtESCode.Text);  //kt added 11/15.  Save for default duration (2 minutes)
  Close;
end;

procedure TfrmSignItem.Timer1Timer(Sender: TObject);
var
  KeyState: TKeyboardState;
begin
  inherited;
  GetKeyboardState(KeyState) ;
  CLBubble.Visible := (KeyState[VK_CAPITAL] = 1);
  CLLabel.Visible := (KeyState[VK_CAPITAL] = 1);
end;

procedure TfrmSignItem.txtESCodeKeyPress(Sender: TObject; var Key: Char);
//kt added 11/18/15
begin
  inherited;
  imgPWSaved.Visible := false;
end;

procedure TfrmSignItem.cmdCancelClick(Sender: TObject);
begin
  FESCode := '';
  Close;
end;



end.
