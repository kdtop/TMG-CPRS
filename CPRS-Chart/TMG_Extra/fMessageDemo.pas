unit fMessageDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTMGOptions, StdCtrls, ORNet, VAUtils;

type
  TfrmMessageDemo = class(TForm)
    Memo1: TMemo;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadUsers;
  public
    { Public declarations }
  end;

var
  frmMessageDemo: TfrmMessageDemo;
  procedure SendMessenger(InitialMsg:string);


implementation

{$R *.dfm}

procedure SendMessenger(InitialMsg:string);
var
  MessageDemo:TfrmMessageDemo;
begin
  MessageDemo := TfrmMessageDemo.create(nil);
  MessageDemo.Memo1.Lines.Clear;
  MessageDemo.Memo1.Lines.Add(InitialMsg);
  MessageDemo.LoadUsers;
  MessageDemo.ShowModal;
  MessageDemo.free;
end;

procedure TfrmMessageDemo.LoadUsers;
var Users:TStringList;
    i :integer;
begin
  Users := TStringList.Create;
  Users.LoadFromFile('\\server1\Public\NetworkMessenger\NetworkMessengerUsers.ini');
  ComboBox1.Items.Clear;
  for I := 1 to Users.Count - 1 do begin
    ComboBox1.Items.Add(piece(Users[i],'=',1));
  end;
  Users.Free;
end;

procedure TfrmMessageDemo.Button1Click(Sender: TObject);
var //MyMsg : TStringList;
  FileName:string;
begin
  //MyMsg := TStringList.Create;
  //try
  //  MyMsg.Add('Here is a test message');
  //  MyMsg.Add('From');
  //  MyMsg.Add('CPRS');
  //  MyMsg.SaveToFile('\\server1\Public\NetworkMessenger\Eddie-CPRS.mgr');
  FileName := '\\server1\Public\NetworkMessenger\'+ComboBox1.Text+'-CPRS.mgr';
  Memo1.Lines.SaveToFile(FileName);
  //finally
  //  MyMsg.free;
  //end;
  Modalresult := mrok;
end;

end.

