unit Report;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ToolWin, Menus, Solapin;

type
  TFramePos = array[0..9, 0..1] of integer;

  TInforme = class(TForm)
    MainMenu1: TMainMenu;
    ImprimirCmd: TMenuItem;
    Salir1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImprimirCmdClick(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ToPrint: TBitmap;
    procedure Clear;
    procedure AddSolapin(const Number: integer);
    procedure SaveToFile(const FileName: TFileName);
    procedure LoadFromFile(const FileName: TFileName);
  end;

const
  fpLeft = 0;
  fpTop  = 1;
  FramePos: TFramePos = ((10, 10),(360,10),(10,230),(360,230),(10,450),(360,450),(10,670),(360,670),(10,890),(360,890));

var
  Informe: TInforme;

const
  slpHeader = 'TpRchvSlpns1-00';

implementation

uses Main, StreamUtils;

{$R *.DFM}

procedure TInforme.AddSolapin(const Number: integer);
var
  Solapin1: TFrameSolapin;
begin
  Solapin1 := MainForm.TheSolapin.Clone(Number);
  InsertControl(Solapin1);
  VertScrollBar.Position := 0;
  HorzScrollBar.Position := 0;
  Solapin1.Left := FramePos[Number, fpLeft];
  Solapin1.Top  := FramePos[Number, fpTop];
  ToPrint.Canvas.Lock;
  Solapin1.PaintTo(ToPrint.Canvas.Handle, Solapin1.Left, Solapin1.Top);
  ToPrint.Canvas.Unlock;
end;

procedure TInforme.Clear;
var
  i: integer;
begin
  ToPrint.Canvas.Brush.Color := clWhite;
  ToPrint.Canvas.FillRect(Informe.ToPrint.Canvas.ClipRect);
  for i := pred(ControlCount) downto 0 do
    Controls[i].free;
end;

procedure TInforme.FormCreate(Sender: TObject);
begin
  ToPrint := TBitmap.Create;
  try
    ToPrint.Width := 720;
    ToPrint.Height := 1400;
  except
    ToPrint.free;
    raise;
  end;
end;

procedure TInforme.FormDestroy(Sender: TObject);
begin
  ToPrint.free;
end;

procedure TInforme.ImprimirCmdClick(Sender: TObject);
begin
  MainForm.ImprimirClick(Self);
end;

procedure TInforme.LoadFromFile(const FileName: TFileName);
var
  i: integer;
  Stream: TFileStream;
  TheHeader: string;
  SlpCount: string;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(TheHeader, length(slpHeader));
    Stream.Read(TheHeader[1], length(slpHeader));
    if TheHeader <> slpHeader
      then raise Exception.Create('El archivo no tiene un formato válido');
    SlpCount := ReadStringFromStream(Stream);
    for i := 0 to pred(StrToInt(SlpCount)) do
      begin
        MainForm.TheSolapin.LoadFromStream(Stream);
        AddSolapin(i);
      end;
  finally
    Stream.free;
  end;
end;

procedure TInforme.Salir1Click(Sender: TObject);
begin
  Close;
end;

procedure TInforme.SaveToFile(const FileName: TFileName);
var
  i: integer;
  Stream: TFileStream;
  Header: string;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  Header := slpHeader;
  Stream.Write(Header[1], length(Header));
  WriteStringToStream(IntToStr(ControlCount), Stream);
  for i := 0 to pred(ControlCount) do
    TFrameSolapin(Controls[i]).SaveToStream(Stream);
  Stream.free;
end;

end.
