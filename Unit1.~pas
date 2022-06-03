unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlateCraft, ExtCtrls, ImgList, StdCtrls, ScktComp, XPMan, unit2,
  ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Timer1: TTimer;
    ClientSocket1: TClientSocket;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Button6: TButton;
    Button7: TButton;
    Memo2: TMemo;
    ImageList3: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Button2Click(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button5Click(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button7Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Map :  TClientMap;
  BufferImage : TBitmap;
  PlayerX,PlayerY : integer;
  GridID : boolean;
  TrafficMessage : array of char;
  TrafficSize : longint;
  MX : integer;
  MY : integer;
implementation

{$R *.dfm}

procedure wl(s : string);
begin
  writeln(output,s);
end;

procedure wr(s : string);
begin
  Form1.Memo1.Lines.Add(s);
end;

procedure wd(s : widestring);
begin
  form1.Memo2.Lines.Add(s);
end;


procedure PictureShow;
begin
  Form1.Image1.Canvas.Draw(0,0,BufferImage);
end;
procedure PictureClear;
begin
//  BufferImage.Canvas.FillRect(rect(0,0,BufferImage.Width,BufferImage.Height));
end;
procedure SDraw(Code : Shortint);
begin
 if Code = 0 then Form1.ImageList1.Draw(BufferImage.Canvas,0,0,0)    else
  if Code > 0 then Form1.ImageList1.Draw(BufferImage.Canvas,0,0,Code) else
                   Form1.ImageList2.Draw(BufferImage.Canvas,0,0,abs(Code));
end;

procedure CellDraw(X,Y : shortint);
var Code : integer;
begin
  Code := Map[x,y].GroundID;
  Form1.ImageList2.Draw(BufferImage.Canvas,(x-1)*20,(y-1)*20,Code);
  Code := Map[x,y].ObjectID;
  Form1.ImageList1.Draw(BufferImage.Canvas,(x-1)*20,(y-1)*20,Code);
end;

procedure PictureCalc;
var i,j : integer;sb:string;
begin
  PictureShow;
  PictureClear;
  For i := 1 to ClientWidth do
  begin
   for j := 1 to ClientHeight do
    begin
     CellDraw(i,j);
    end;
  end;

  if GridID then
   begin
  For i := 1 to ClientWidth do
  begin
   for j := 1 to ClientHeight do
    begin
      BufferImage.Canvas.TextOut((i-1)*20,(j-1)*20,inttostr(map[i,j].ObjectID));
    end;
  end;
  end;
    Form1.ImageList3.Draw(BufferImage.Canvas,mx div 20 * 20, my div 20 * 20,5);
  //BufferImage.Canvas.TextOut(mx div 20 * 20, my div 20 * 20,inttostr(mx div 20)+'^'+inttostr(my div 20 ));


  Form1.ImageList1.Draw(BufferImage.Canvas,PlayerX,PlayerY,1);
end;

procedure TForm1.FormCreate(Sender: TObject);
var i : byte;

begin

   Caption := FloatToStr(39/52);
  AssignFile(output,'lastLog.txt');
  rewrite(Output);
  Randomize;
  BufferImage := TBitmap.Create;
  BufferImage.Height := Image1.Height;
  BufferImage.Width  := Image1.Width;
  DoubleBuffered := true;
  for i := 5 to 15 do
    map[i,5].ObjectID := 2;
  for i := 5 to 15 do
    map[i,7].GroundID := 1;
  Timer1.Enabled := true;
  PlayerX := BufferImage.Width  div 2 - 20;
  PlayerY := BufferImage.Height div 2 - 20;
  map[16,12].GroundID := GGrass;
  map[16,13].GroundID := GGrass;
  map[17,13].GroundID := GGrass;
  map[17,12].GroundID := GGrass;
  
end;



procedure CalcTraffic;
var
  x,y,i,k : integer;
  calculated : boolean;
  R : widestring;

  function TS : Integer;
   begin
    result := length(TrafficMessage);
   end;

 procedure Erasing(N:longint);
 var i : longint; sb : string;
  begin
   sb := '<<<';
   for i := 0 to TS-1-N do
   begin{
    if ord( TrafficMessage[i-N]) = 254 then sb := sb+' ';
    Sb := sb + inttostr(ord( TrafficMessage[i-N]))+';' ; //}
    TrafficMessage[i] := TrafficMessage[i+5];
   end;
  SetLength(TrafficMessage,ts-N);
 end;

begin
calculated := true;
R := '';
k := 0;
while (ts>0)and(calculated) do
 begin
  if (ord(TrafficMessage[0]) = 254) and (ts >= 5) then
    begin
      X := Ord(TrafficMessage[1]);
      Y := Ord(TrafficMessage[2]);
      Map [x,y].ObjectID := Ord(TrafficMessage[3]);
      Map [x,y].GroundID := Ord(TrafficMessage[4]);
      Erasing(5);
      R := R + '[--(' + inttostr(x) + ';' + inttostr(y) + '): ' + inttostr(Map [x,y].ObjectID) + ',' + inttostr(Map [x,y].GroundID)+'--] ' ;
      k:=k+1;
      if k = 4 then
       begin
        k := 0;
        wd(r);
        r := '';
       end;
      Application.ProcessMessages;
    end
  else calculated := false;
 end ;
if not (k = 0) then  
wd(r);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  PictureCalc;
end;

procedure TForm1.Button1Click(Sender: TObject);
var code : Shortint;
begin
ClientSocket1.Address := Edit1.Text;
ClientSocket1.Active  := true;
Application.ProcessMessages;
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
WR(IntToStr(ErrorCode));
ErrorCode := 0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   ClientSocket1.Active := false;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
wr('Connected');
wl('>--->Connected');
end;



procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
bb : TClientMap;i,j,TS:integer; sb : string;
begin

  sb := ClientSocket1.Socket.ReceiveText;
  wr('read: '+sb);
  TS := length(TrafficMessage);
  SetLength(TrafficMessage,TS+length(sb));
  for i := 0 to Length(sb)-1 do
   TrafficMessage[TS +i] := sb[i+1];
 // TrafficSize := TrafficSize + Length(sb);

  CalcTraffic;
end;


procedure TForm1.Button5Click(Sender: TObject);
begin
GridID := not GridID;
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
wr('Connection Lost');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
ClientSocket1.Active := false;
Halt;
end;

procedure TForm1.Button6Click(Sender: TObject);
var i,j : integer;
begin       //    Timer1.Enabled := false;
wl('>---> Двигаем вправо');

  for i := 1 to platecraft.ClientWidth-1 do
  for j := 1 to platecraft.ClientHeight do
   begin
    Map[i,j] := Map[i+1,j];
    Application.ProcessMessages;
   end;
    
  if ClientSocket1.Active then ClientSocket1.Socket.SendText(chr(211));


  Timer1.Enabled := true;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = VK_RETURN then Button1Click(sender);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CloseFile(output);
end;

procedure TForm1.Button7Click(Sender: TObject);
var i,j : integer;
begin
wl('<---< Двигаем влево');

  for i := platecraft.ClientWidth downto 1 do
  for j := 1 to platecraft.ClientHeight do
   begin
    Map[i,j] := Map[i+1,j];
    Application.ProcessMessages;
   end;

  if ClientSocket1.Active then ClientSocket1.Socket.SendText(chr(211));


//  Timer1.Enabled := true;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
MX := x;
MY := Y;

end;

end.
