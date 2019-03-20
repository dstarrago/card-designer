unit CheckAccess;

interface

type
  TPasswordManager =
    class
      private
        Point1: integer;
        Point2: integer;
        procedure ResetTranslation;
        function GetTraslation: integer;
        function Encode(const Value: string): string;
        function Decode(const Value: string): string;
      public
        constructor Create;
        function RequestAccess: boolean;
        procedure SetRegistryKey;
        function TryPassWord(const Value: string): boolean;
        procedure SetPassword(const Value: string);
    end;

var
  PasswordManager: TPasswordManager;

implementation

uses Windows, Controls, SysUtils, Acceso, Registry;

const
  BASE_KEY = 'Software';
  ORGANIZATION = 'Daneloth Production';
  PRODUCT = 'Solapin Maker';
  PASSWORD = 'PassWord';

function TPasswordManager.Encode(const Value: string): string;
var
  i: integer;
begin
  ResetTranslation;
  Setlength(Result, length(Value));
  for i := 1 to length(Value) do
    Result[i] := chr(Ord(Value[i]) + GetTraslation);
end;

function TPasswordManager.Decode(const Value: string): string;
var
  i: integer;
begin
  ResetTranslation;
  Setlength(Result, length(Value));
  for i := 1 to length(Value) do
    Result[i] := chr(Ord(Value[i]) - GetTraslation);
end;

function TPasswordManager.RequestAccess: boolean;
var
  FormAcceso: TFormAcceso;
begin
  FormAcceso := TFormAcceso.Create(nil);
  try
    Result := FormAcceso.ShowModal = mrOk;
  finally
    FormAcceso.free;
  end;
end;

procedure TPasswordManager.SetPassword(const Value: string);
var
  IniFile: TRegIniFile;
begin
  IniFile := TRegIniFile.Create('');
  try
    IniFile.RootKey := HKEY_CURRENT_USER;
    IniFile.OpenKeyReadOnly(BASE_KEY);
    IniFile.OpenKey(ORGANIZATION, true);
    IniFile.OpenKey(PRODUCT, true);
    TRegistry(IniFile).WriteString(PASSWORD, Encode(Value));
  finally
    IniFile.free;
  end;
end;

procedure TPasswordManager.SetRegistryKey;
var
  IniFile: TRegIniFile;
begin
  IniFile := TRegIniFile.Create('');
  try
    IniFile.RootKey := HKEY_CURRENT_USER;
    IniFile.OpenKeyReadOnly(BASE_KEY);
    IniFile.OpenKey(ORGANIZATION, true);
    IniFile.OpenKey(PRODUCT, true);
    if not IniFile.ValueExists(PASSWORD)
      then TRegistry(IniFile).WriteString(PASSWORD, Encode('nespilaso'));
  finally
    IniFile.free;
  end;
end;

function TPasswordManager.TryPassWord(const Value: string): boolean;
var
  IniFile: TRegIniFile;
  Str: string;
begin
  IniFile := TRegIniFile.Create('');
  try
    IniFile.RootKey := HKEY_CURRENT_USER;
    IniFile.OpenKeyReadOnly(BASE_KEY);
    IniFile.OpenKey(ORGANIZATION, true);
    IniFile.OpenKey(PRODUCT, true);
    Str := TRegistry(IniFile).ReadString(PASSWORD);
    if Str = ''
      then raise Exception.Create('Problemas en el registro');
  finally
    Result := Decode(Str) = Value;
    IniFile.free;
  end;
end;

function TPasswordManager.GetTraslation: integer;
var
  Pt: integer;
begin
  Pt := Point1 + Point2;  // Fi Translation
  Point1 := Point2;
  Point2 := Pt;
  Result := Pt mod 128;
end;

constructor TPasswordManager.Create;
begin
  inherited;
  ResetTranslation;
end;

procedure TPasswordManager.ResetTranslation;
begin
  Point1 := 1;
  Point2 := 1;
end;

initialization

  PasswordManager := TPasswordManager.Create;

finalization

  PasswordManager.free;

end.
