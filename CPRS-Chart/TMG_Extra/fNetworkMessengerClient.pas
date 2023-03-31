unit fNetworkMessengerClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTMGOptions, StdCtrls, ORNet, VAUtils, Trpcb;

type
  TfrmNetworkMessagerClient = class(TForm)
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
  frmNetworkMessagerClient: TfrmNetworkMessagerClient;
  procedure SendMessenger(InitialMsg:string);
  function SendOneMessage(ToUser,FromUser:string;MsgArr:TStrings):string;
  function LabOrderMsgRecip(UsrType:string):string;
  function GetMyName():string;


implementation

{$R *.dfm}

procedure SendMessenger(InitialMsg:string);
var
  MessageDemo:TfrmNetworkMessagerClient;
begin
  MessageDemo := TfrmNetworkMessagerClient.create(nil);
  MessageDemo.Memo1.Lines.Clear;
  MessageDemo.Memo1.Lines.Add(InitialMsg);
  MessageDemo.LoadUsers;
  MessageDemo.ShowModal;
  MessageDemo.free;
end;

procedure TfrmNetworkMessagerClient.LoadUsers;
var Users:TStringList;
    i :integer;
begin
  Users := TStringList.Create;
  //Users.LoadFromFile('\\server1\Public\NetworkMessenger\NetworkMessengerUsers.ini');
  ComboBox1.Items.Clear;
  tCallV(Users,'TMG MESSENGER GETUSERS',[]);
  for I := 1 to Users.Count - 1 do begin
    ComboBox1.Items.Add(piece(Users[i],'^',1));
  end;
  Users.Free;
  ComboBox1.ItemIndex := 0;
end;

procedure TfrmNetworkMessagerClient.Button1Click(Sender: TObject);
var FileName:string;
begin
  //FileName := '\\server1\Public\NetworkMessenger\'+ComboBox1.Text+'-CPRS.mgr';
  //Memo1.Lines.SaveToFile(FileName);
  SendOneMessage(ComboBox1.Text,GetMyName,Memo1.Lines);
  Modalresult := mrok;
end;

function SendOneMessage(ToUser,FromUser:string;MsgArr:TStrings):string;
//Public function to send a NetworkMessenger message
var
  i : integer;
begin
  RPCBrokerV.remoteprocedure := 'TMG MESSENGER SEND MESSAGE';
  RPCBrokerV.Param[0].Value := ToUser;  // not used
  RPCBrokerV.param[0].ptype := literal;
  RPCBrokerV.Param[1].Value := FromUser;  // not used
  RPCBrokerV.param[1].ptype := literal;
  RPCBrokerV.param[2].ptype := list;
  for I := 0 to MsgArr.Count - 1 do begin
    RPCBrokerV.Param[2].Mult[inttostr(i)] := MsgArr.Strings[i];
  end;
  CallBroker;
  Result := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
end;

function LabOrderMsgRecip(UsrType:string):string;
//Public function to get the User who is to get a Lab Order Message
begin
  Result := sCallV('TMG MESSENGER LAB ORDER RECIP',[UsrType]);
  if piece(Result,'^',1)='1' then
    Result := piece(Result,'^',2);
end;

function GetMyName():string;
//Public function to get the current user's name, based on IP Address
begin
  Result := sCallV('TMG MESSENGER GET MY NAME',[DottedIPStr]);
  if piece(Result,'^',1)='1' then
    Result := piece(Result,'^',2);
end;

end.

