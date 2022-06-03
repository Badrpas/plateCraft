unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlateCraft, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Button1: TButton;
//    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
      Map : TClientMap;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.Button1Click(Sender: TObject);
var i,j : integer;
begin
  for i := 0 to ClientHeight+1 do
   begin
   image1.Canvas.MoveTo((i+1)*10,0);
   Image1.Canvas.LineTo((i+1)*10,260);
   for j := 0 to ClientWidth+1 do
    begin
      image1.Canvas.FillRect(rect(i*10,j*10,i*10+10,j*10+10));
      Image1.Canvas.TextOut(i*10,j*10,inttostr(Form2.map[i,j].ObjectID));
      Image1.Canvas.TextOut(i*10,j*10,inttostr(Form2.map[i,j].GroundID));
      Application.ProcessMessages;
    end;
   end;
end;

end.
