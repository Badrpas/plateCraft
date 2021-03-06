unit Unit1;
//              Server
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlateCraft, StdCtrls, ScktComp, ExtCtrls, unit2, XPMan, ImgList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    ServerSocket1: TServerSocket;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button2: TButton;
    Image1: TImage;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    TimerPicture: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ServerSocket1Listen(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocket1Accept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerPictureTimer(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//end;
var
  Form1:        TForm1;
//  GlobalMap:    TGlobalMap;
  Mapa:         TClientMap;     // Temporary buffer for client map
  SendM,
  MapShowing:   boolean;        // Showing right-side map
  MS:           TMemoryStream;  // Testing TSockets
  MX,MY,x,y   : Integer;        // Variables for Mouse x,y & x, y of showing area (rightside map)
  MouseButton : TMouseButton;   // ???
  MousePressed: Boolean;        // For manipulating of rightside map

implementation

{$R *.dfm}

procedure wr(s : string);         // Write to console
begin
  Form1.Memo1.Lines.Add(s);
end;

procedure SendXY(X,Y,Index : integer);        // Sending cellXY to ServerSocket1.Socket.Connections[index]
var S : string; Cell : TCell;
begin
  Cell := Mapa[x,y];                                                         // Taking values from ClientMap
  S := Chr(254) + Chr(X) + Chr(Y) + Chr(Cell.ObjectID) + Chr(Cell.GroundID); // Formating sending string
                                                                             // Need to change this method!
  Form1.ServerSocket1.Socket.Connections[index].SendText(S);
end;

procedure SendMap(Index : word);                                          // Cycle of SendXY
var map:        TClientMap;   i,j : word;
begin
  if Form1.ServerSocket1.Socket.Connections[Index].Connected then         // for all connected clients do
  begin
    for i:= 1 to platecraft.ClientWidth do                                // 1..32
      for j:= 1 to platecraft.ClientHeight do                             // 1..24
        SendXY(i,j,index);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i : integer;
begin
 if SendM then
  begin
   for i:= 0 to  ServerSocket1.Socket.ActiveConnections-1 do
    sendmap(i);
  end;    //
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ServerSocket1.Active := true;
end;

procedure TForm1.ServerSocket1Listen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  wr('Listen');
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;         // On connecting client
  Socket: TCustomWinSocket);
begin
  wr('Client connect '+Socket.RemoteAddress);
  SendMap(ServerSocket1.Socket.ActiveConnections-1);
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  wr('Client disconnect '+Socket.RemoteAddress);
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  wr('Client error ('+inttostr(ErrorCode)+') '+Socket.RemoteAddress);
  ErrorCode := 0;
end;

procedure TForm1.ServerSocket1Accept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  wr('Accept '+Socket.RemoteAddress);
end;

procedure TForm1.Button2Click(Sender: TObject);    // Changing state of autosending map
var someint : integer;
begin
  SendM := not sendM;
  if SendM then Button2.Caption := '+' else Button2.Caption := '-';
end;


procedure CellDraw(X,Y : shortint);
var Code : integer;
begin
  Code := Mapa[x,y].GroundID;
  Form1.ImageList2.Draw(form1.image1.Canvas,(x-1)*20,(y-1)*20,Code);
  Code := Mapa[x,y].ObjectID;
  Form1.ImageList1.Draw(form1.image1.Canvas,(x-1)*20,(y-1)*20,Code);
end;

procedure PictureCalc;
var i,j : integer; sb : string;
begin
Form1.Image1.Canvas.FillRect(rect(0,0,Form1.Image1.Width,Form1.Image1.Height));
  For i := 1 to ClientWidth do
  begin
   for j := 1 to ClientHeight do
    begin
     CellDraw(i,j);
    end;
  end;
Form1.Image1.Refresh;
end;




procedure TForm1.FormCreate(Sender: TObject);
var i,j : integer;
begin
    Width := 700;
    Height := 423;
DoubleBuffered := true;
SendM  := true;
Randomize;
  for i := 1 to 32 do
   for j := 1 to 24 do
    begin
     mapa[i,j].GroundID := random(4);
     mapa[i,j].ObjectID := random(3);
     if mapa[i,j].ObjectID = 1 then mapa[i,j].ObjectID := 2;
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ServerSocket1.Active := false;
wr('Stop');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
ServerSocket1.Active := false;
Halt;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
MapShowing := not MapShowing;
if MapShowing then
  begin
    ClientWidth := 1360;
    ClientHeight := 500;
    PictureCalc;
  end
else
  begin
    Width := 700;
    Height := 423;
  end
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  GlobalMapGeneration;
  Mapa := ClientMapArea(X,Y);
end;

procedure TForm1.Button7Click(Sender: TObject);
var i: integer;
begin
for i:= 0 to ServerSocket1.Socket.ActiveConnections - 1 do
sendmap(i);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin



//  PictureCalc;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  MX := X;
  MY := Y;
end;

procedure TForm1.TimerPictureTimer(Sender: TObject);
begin
if MousePressed then
  begin
    if MouseButton = mbLeft  then  Mapa[MX div 20 + 1, MY div 20 + 1].GroundID := strtoint(ComboBox1.Text);
    if MouseButton = mbRight then  Mapa[MX div 20 + 1, MY div 20 + 1].ObjectID := strtoint(ComboBox2.Text);
  end;
PictureCalc;

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseButton :=  Button;
  MousePressed := true;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MousePressed := false;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var Sb : string;

  procedure SendXY(X,Y : integer);
   var S : string; Cell : TCell;
  begin
    Cell := GlobalMap[x,y];
    S := Chr(254) + Chr(X) + Chr(Y) + Chr(Cell.ObjectID) + Chr(Cell.GroundID);
    Socket.SendText(S);
  end;

  procedure CalcReceive;
  var i : word;
  begin
    while length(sb)>0 do
     begin
      case ord(sb[1]) of
        211 :
          begin
            for i := 1 to platecraft.ClientHeight do
              SendXY(platecraft.ClientWidth,i);
            delete(sb,1,1);
          end;
      end;
     end;
  end;

begin

  Sb := Socket.ReceiveText;
  CalcReceive;

end;

end.
