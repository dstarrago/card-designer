unit Acceso;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

const
  MAXFAILS = 3;

type
  TFormAcceso = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    FailCount: integer;
  end;

var
  FormAcceso: TFormAcceso;

implementation

uses CheckAccess;

{$R *.DFM}

procedure TFormAcceso.BitBtn1Click(Sender: TObject);
begin
  if not PasswordManager.TryPassWord(Edit1.Text)
    then
      begin
        ShowMessage('La clave de accesso es incorrecta');
        Edit1.Text := '';
        inc(FailCount);
        Edit1.SetFocus;
        ModalResult := mrNone;
      end;
  if FailCount = MAXFAILS
    then ModalResult := mrCancel;
end;

end.
