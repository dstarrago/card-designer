unit ChangePassword;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFormChangePassword = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChangePassword: TFormChangePassword;

implementation

uses CheckAccess;

{$R *.DFM}

procedure TFormChangePassword.BitBtn1Click(Sender: TObject);
begin
  if not PasswordManager.TryPassWord(Edit1.Text)
    then
      begin
        Edit1.Text := '';
        Edit1.SetFocus;
        ShowMessage('La clave de accesso es incorrecta');
        ModalResult := mrNone;
      end
    else
      begin
        if Edit2.Text = ''
          then
            begin
              ShowMessage('Inadmisible clave nula');
              ModalResult := mrNone;
            end
          else
            if Edit2.Text = Edit3.Text
              then
                begin
                  PasswordManager.SetPassword(Edit2.Text);
                  ShowMessage('La clave fue cambiada satisfactoriamente');
                end
              else
                begin
                  ShowMessage('Las claves no concuerdan');
                  ModalResult := mrNone;
                end
      end;
end;

end.
