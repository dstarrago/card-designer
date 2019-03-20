unit StreamUtils;

interface

uses Classes, SysUtils;

  procedure WriteStringToStream(const value: string; Stream: TStream);
  function ReadStringFromStream(Stream: TStream): string;

implementation

function ReadStringFromStream(Stream: TStream): string;
var
  Len: string;
begin
  SetLength(Len, 3);
  Stream.Read(Len[1], 3);
  SetLength(Result, StrToInt(Len));
  Stream.Read(Result[1], Length(Result));
end;

procedure WriteStringToStream(const value: string; Stream: TStream);
var
  Len: string;
begin
  Len := Format('%.3d', [Length(value)]);
  Stream.Write(Len[1], 3);
  Stream.Write(value[1], Length(value));
end;

end.
