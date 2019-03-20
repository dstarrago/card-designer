program Solapines;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Solapin in 'Solapin.pas' {FrameSolapin: TFrame},
  Report in 'Report.pas' {Informe},
  StreamUtils in 'StreamUtils.pas',
  MyJPEG in 'MyJPEG.PAS',
  Acceso in 'Acceso.pas' {FormAcceso},
  CheckAccess in 'CheckAccess.pas',
  ChangePassword in 'ChangePassword.pas' {FormChangePassword};

{$R *.RES}

begin
  PasswordManager.SetRegistryKey;
  if PasswordManager.RequestAccess
    then
      begin
        Application.Initialize;
        Application.CreateForm(TMainForm, MainForm);
        Application.CreateForm(TInforme, Informe);
        Application.CreateForm(TFormChangePassword, FormChangePassword);
        Application.Run;
      end;
end.
