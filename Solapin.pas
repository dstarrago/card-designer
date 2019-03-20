unit Solapin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, MyJpeg;

type
  TBackGrounds = array[0..20] of string;

  TFrameSolapin = class(TFrame)
    Panel1: TPanel;
    Image1: TImage;
    FullName: TLabel;
    Charge: TLabel;
    Image2: TImage;
    Code: TPanel;
  private
    FDomain: integer;
    FAccess: integer;
    procedure SetDomain(const Value: integer);
    procedure SetAccess(const Value: integer);
    procedure UpDateBackGround;
    function GetWorker: string;
    procedure SetWorker(const Value: string);
    function GetOcupation: string;
    procedure SetOcupation(const Value: string);
    function GetCodify: string;
    procedure SetCodify(const Value: string);
    function GetPhoto: TPicture;
    function GetBackGround: TPicture;
    procedure SavePhotoToStream(Stream: TFileStream);
    procedure LoadPhotoFromStream(Stream: TFileStream);
  public
    property Domain: integer read FDomain write SetDomain;
    property Access: integer read FAccess write SetAccess;
    property Worker: string read GetWorker write SetWorker;
    property Ocupation: string read GetOcupation write SetOcupation;
    property Codify: string read GetCodify write SetCodify;
    property Photo: TPicture read GetPhoto;
    property BackGround: TPicture read GetBackGround;
    function Clone(const Number: integer): TFrameSolapin;
    procedure SaveToStream(Stream: TFileStream);
    procedure LoadFromStream(Stream: TFileStream);
  end;

const
  BackGrounds: TBackGrounds = ('BackGrounds\Hilanderia.jpg',
                               'BackGrounds\HilanderiaLA.jpg',
                               'BackGrounds\Tejeduria.jpg',
                               'BackGrounds\TejeduriaLA.jpg',
                               'BackGrounds\Acabado.jpg',
                               'BackGrounds\AcabadoLA.jpg',
                               'BackGrounds\Energetica.jpg',
                               'BackGrounds\EnergeticaLA.jpg',
                               'BackGrounds\ElectroMecanica.jpg',
                               'BackGrounds\ElectroMecanicaLA.jpg',
                               'BackGrounds\OficCentral.jpg',
                               'BackGrounds\OficCentralLA.jpg',
                               'BackGrounds\Aseguramiento.jpg',
                               'BackGrounds\AseguramientoLA.jpg',
                               'BackGrounds\Atm.jpg',
                               'BackGrounds\AtmLA.jpg',
                               'BackGrounds\Estudiante.jpg',
                               'BackGrounds\Medico.jpg',
                               'BackGrounds\Visitante.jpg',
                               'BackGrounds\PerfEmpresarial.jpg',
                               'BackGrounds\LAPermanente.jpg');

implementation

uses StreamUtils;

{$R *.DFM}

{ TFrameSolapin }

function TFrameSolapin.Clone(const Number: integer): TFrameSolapin;
begin
  Result := TFrameSolapin.Create(Owner);
  Result.Name := Result.Name + IntToStr(Number);
  Result.Image1.Picture.Assign(Image1.Picture);
  Result.Image2.Picture.Assign(Image2.Picture);
  Result.FullName.Caption := FullName.Caption;
  Result.Charge.Caption := Charge.Caption;
  Result.Code.Caption := Code.Caption;
  Result.Domain := Domain;
  Result.Access := Access;
end;

function TFrameSolapin.GetBackGround: TPicture;
begin
  Result := Image1.Picture;
end;

function TFrameSolapin.GetCodify: string;
begin
  Result := Code.Caption;
end;

function TFrameSolapin.GetOcupation: string;
begin
  Result := Charge.Caption;
end;

function TFrameSolapin.GetPhoto: TPicture;
begin
  Result := Image2.Picture;
end;

function TFrameSolapin.GetWorker: string;
begin
  Result := FullName.Caption;
end;

procedure TFrameSolapin.LoadFromStream(Stream: TFileStream);
begin
  FullName.Caption := ReadStringFromStream(Stream);
  Charge.Caption := ReadStringFromStream(Stream);
  Code.Caption := ReadStringFromStream(Stream);
  Domain := StrToInt(ReadStringFromStream(Stream));
  Access := StrToInt(ReadStringFromStream(Stream));
  LoadPhotoFromStream(Stream);
end;

procedure TFrameSolapin.LoadPhotoFromStream(Stream: TFileStream);
var
  jpeg: TMyJPEGImage;
  Bitmap: TBitmap;
begin
  jpeg := TMyJPEGImage.Create;
  try
    jpeg.LoadFromStream(Stream);
    Bitmap := TBitmap.Create;
    try
      Bitmap.Assign(jpeg);
      Photo.Graphic.Assign(Bitmap);
    finally
      Bitmap.free;
    end;
  finally
    jpeg.free;
  end;
end;

procedure TFrameSolapin.SavePhotoToStream(Stream: TFileStream);
var
  jpeg: TMyJPEGImage;
  Bitmap: TBitmap;
begin
  jpeg := TMyJPEGImage.Create;
  try
    Bitmap := TBitmap.Create;
    try
      Bitmap.Assign(Photo.Graphic);
      jpeg.Assign(Bitmap);
    finally
      Bitmap.free;
    end;
    jpeg.SaveToStream(Stream);
  finally
    jpeg.free;
  end;
end;

procedure TFrameSolapin.SaveToStream(Stream: TFileStream);
begin
  WriteStringToStream(FullName.Caption, Stream);
  WriteStringToStream(Charge.Caption, Stream);
  WriteStringToStream(Code.Caption, Stream);
  WriteStringToStream(IntToStr(Domain), Stream);
  WriteStringToStream(IntToStr(Access), Stream);
  SavePhotoToStream(Stream);
end;

procedure TFrameSolapin.SetAccess(const Value: integer);
begin
  if Value <> FAccess
    then
      begin
        FAccess := Value;
        UpDateBackGround;
      end;
end;

procedure TFrameSolapin.SetCodify(const Value: string);
begin
  Code.Caption := Value;
end;

procedure TFrameSolapin.SetDomain(const Value: integer);
begin
  if Value <> FDomain
    then
      begin
        FDomain := Value;
        UpDateBackGround;
      end;
end;

procedure TFrameSolapin.SetOcupation(const Value: string);
begin
  Charge.Caption := Value;
end;

procedure TFrameSolapin.SetWorker(const Value: string);
begin
  FullName.Caption := Value;
end;

procedure TFrameSolapin.UpDateBackGround;
var
  index: integer;
  CurrentPath: string;
begin
  if Access = 2
    then index := 20
    else
      if Domain >= 8
        then index := Domain + 8
        else
          if Access = 0
            then index := Domain * 2
            else index := Domain * 2 + 1;
  CurrentPath := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(Application.ExeName));
  BackGround.LoadFromFile(BackGrounds[index]);
  SetCurrentDir(CurrentPath);
end;

end.
