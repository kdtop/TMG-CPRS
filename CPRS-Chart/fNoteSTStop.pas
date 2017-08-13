unit fNoteSTStop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fAutoSz, VA508AccessibilityManager;

type
  TfrmSearchStop = class(TfrmAutoSz)
    btnSearchStop: TButton;
    lblSearchStatus: TStaticText;
    procedure btnSearchStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//kt 9/25/15 commented out, and removed from auto-create forms list
//   Will change to be created in fNotes.
//NOTE!:  restoring 9/28/15
var
  frmSearchStop: TfrmSearchStop;

implementation

{$R *.dfm}
uses fNotes, ORFn;

procedure TfrmSearchStop.btnSearchStopClick(Sender: TObject);
begin
  SearchTextStopFlag := True;
end;

procedure TfrmSearchStop.FormShow(Sender: TObject);
begin
  //ResizeFormToFont(frmSearchStop);
  ResizeFormToFont(Self);
end;

end.
