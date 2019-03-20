unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg, Buttons, Solapin, ImgList, ExtDlgs, SyncObjs,
  Mask, ActnList, Menus, ComCtrls, ToolWin;

type
  TGlyphs = array[0..9] of TImage;

  TMainForm = class(TForm)
    NameInput: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    PositionInput: TEdit;
    Label4: TLabel;
    TheSolapin: TFrameSolapin;
    Panel1: TPanel;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Image6: TImage;
    Image5: TImage;
    Image7: TImage;
    Image2: TImage;
    Image8: TImage;
    Image10: TImage;
    Image9: TImage;
    Label1: TLabel;
    LabelCount: TLabel;
    Domain: TComboBox;
    Label6: TLabel;
    Access: TComboBox;
    Label7: TLabel;
    FotoBtn: TBitBtn;
    OpenPicture: TOpenPictureDialog;
    PrintDialog1: TPrintDialog;
    CodeInput: TMaskEdit;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    CrearNuevo: TAction;
    Adicionar: TAction;
    Remover: TAction;
    VistaPrevia: TAction;
    Imprimir: TAction;
    PegarFoto: TAction;
    Guardar: TAction;
    GuardarComo: TAction;
    Archivo: TMenuItem;
    Edicion1: TMenuItem;
    Nuevo1: TMenuItem;
    Salvar1: TMenuItem;
    SalvarComo1: TMenuItem;
    N1: TMenuItem;
    VistaPrevia1: TMenuItem;
    Imprimir1: TMenuItem;
    Cerrar1: TMenuItem;
    PegarFoto1: TMenuItem;
    Salir: TAction;
    N2: TMenuItem;
    Adicionar1: TMenuItem;
    Remover1: TMenuItem;
    N3: TMenuItem;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    Abrir: TAction;
    Abrir1: TMenuItem;
    ToolButton2: TToolButton;
    ToolBar2: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Help: TAction;
    ToolButton8: TToolButton;
    OpenDialog1: TOpenDialog;
    ChangePassword: TAction;
    CambiarClave1: TMenuItem;
    N4: TMenuItem;
    procedure NameInputChange(Sender: TObject);
    procedure PositionInputChange(Sender: TObject);
    procedure CodeInputChange(Sender: TObject);
    procedure ImprimirClick(Sender: TObject);
    procedure AdicionarClick(Sender: TObject);
    procedure VistaPreviaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DomainChange(Sender: TObject);
    procedure AccessChange(Sender: TObject);
    procedure NuevoBtnClick(Sender: TObject);
    procedure RemoverBtnClick(Sender: TObject);
    procedure FotoBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PegarFotoExecute(Sender: TObject);
    procedure SalirExecute(Sender: TObject);
    procedure GuardarComoExecute(Sender: TObject);
    procedure AbrirExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GuardarExecute(Sender: TObject);
    procedure ChangePasswordExecute(Sender: TObject);
  private
    FCount: integer;
    FReportName: string;
    procedure Clear;
    procedure SetCount(const Value: integer);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure SetReportName(const Value: string);
  public
    Glyphs: TGlyphs;
    property Count: integer read FCount write SetCount;
    property ReportName: string read FReportName write SetReportName;
  end;

const
  Title = 'Solapines - ';
  NuevoReporte = 'Nuevo reporte';

var
  MainForm: TMainForm;

implementation

uses Printers, Report, ShellAPI, ClipBrd, ChangePassword;

resourcestring
  sOverWrite = '¿Sobreescribir %s?';
  
{$R *.DFM}

procedure TMainForm.NameInputChange(Sender: TObject);
begin
  TheSolapin.Worker := NameInput.Text;
end;

procedure TMainForm.PositionInputChange(Sender: TObject);
begin
  TheSolapin.Ocupation := PositionInput.Text;
end;

procedure TMainForm.CodeInputChange(Sender: TObject);
begin
//  TheSolapin.Codify := Format('*%s*', [CodeInput.Text]);
  TheSolapin.Codify := CodeInput.Text;
end;

procedure TMainForm.ImprimirClick(Sender: TObject);
var
  Info: PBitmapInfo;
  InfoSize: DWORD;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  PrintWidth, PrintHeight: Longint;
begin
  if PrintDialog1.Execute
    then
      begin
        Printer.BeginDoc;
        try
          Informe.ToPrint.Canvas.Lock;
          try
            { Paint bitmap to the printer }
            with Printer, Informe.ToPrint.Canvas do
            begin
              Bits := Informe.ToPrint.Handle;
              GetDIBSizes(Bits, InfoSize, ImageSize);
              Info := AllocMem(InfoSize);
              try
                Image := AllocMem(ImageSize);
                try
                  GetDIB(Bits, 0, Info^, Image^);
                  with Info^.bmiHeader do
                  begin
                    DIBWidth := biWidth;
                    DIBHeight := biHeight;
                  end;
                  case PrintScale of
                    poProportional:
                      begin
                        PrintWidth := MulDiv(DIBWidth, GetDeviceCaps(Printer.Handle,
                          LOGPIXELSX), PixelsPerInch);
                        PrintHeight := MulDiv(DIBHeight, GetDeviceCaps(Printer.Handle,
                          LOGPIXELSY), PixelsPerInch);
                      end;
                    poPrintToFit:
                      begin
                        PrintWidth := MulDiv(DIBWidth, PageHeight, DIBHeight);
                        if PrintWidth < PageWidth then
                          PrintHeight := PageHeight
                        else
                        begin
                          PrintWidth := PageWidth;
                          PrintHeight := MulDiv(DIBHeight, PageWidth, DIBWidth);
                        end;
                      end;
                  else
                    PrintWidth := DIBWidth;
                    PrintHeight := DIBHeight;
                  end;
                  StretchDIBits(Canvas.Handle, 0, 0, PrintWidth, PrintHeight, 0, 0,
                    DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
                finally
                  FreeMem(Image, ImageSize);
                end;
              finally
                FreeMem(Info, InfoSize);
              end;
            end;
          finally
            Informe.ToPrint.Canvas.Unlock;
          end;
        finally
          Printer.EndDoc;
        end;
      end;
end;

procedure TMainForm.AdicionarClick(Sender: TObject);
begin
  Informe.AddSolapin(Count);
  Glyphs[FCount].Visible := true;
  Count := Count + 1;
  NameInput.Text := '';
  CodeInput.Text := '';
  PositionInput.Text := '';
  NameInput.SetFocus;
end;

procedure TMainForm.VistaPreviaClick(Sender: TObject);
begin
  Informe.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Glyphs[0] := Image1;
  Glyphs[1] := Image2;
  Glyphs[2] := Image3;
  Glyphs[3] := Image4;
  Glyphs[4] := Image5;
  Glyphs[5] := Image6;
  Glyphs[6] := Image7;
  Glyphs[7] := Image8;
  Glyphs[8] := Image9;
  Glyphs[9] := Image10;
  Domain.ItemIndex := 0;
  Access.ItemIndex := 0;
  OnCloseQuery := FormCloseQuery;
end;

procedure TMainForm.DomainChange(Sender: TObject);
begin
  TheSolapin.Domain := Domain.ItemIndex;
end;

procedure TMainForm.NuevoBtnClick(Sender: TObject);
begin
  ReportName := '';
  Clear;
  Informe.Clear;
end;

procedure TMainForm.RemoverBtnClick(Sender: TObject);
var
  Frame: TFrameSolapin;
begin
  Frame := TFrameSolapin(Informe.Controls[pred(Informe.ControlCount)]);
  Glyphs[pred(Informe.ControlCount)].Visible := false;
  Informe.VertScrollBar.Position := 0;
  Informe.HorzScrollBar.Position := 0;
  Informe.ToPrint.Canvas.Brush.Color := clWhite;
  Informe.ToPrint.Canvas.FillRect(Frame.BoundsRect);
  Frame.free;
  Count := Count - 1;
end;

procedure TMainForm.SetCount(const Value: integer);
begin
  FCount := Value;
  LabelCount.Caption := Format('%d / 10', [FCount]);
end;

procedure TMainForm.FotoBtnClick(Sender: TObject);
begin
  if OpenPicture.Execute
    then TheSolapin.Image2.Picture.LoadFromFile(OpenPicture.FileName);
end;

procedure TMainForm.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0
      then
        begin
          try
            TheSolapin.Photo.LoadFromFile(CFileName);
            Msg.Result := 0;
          except
            // Do nothing
          end;
        end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;

procedure TMainForm.PegarFotoExecute(Sender: TObject);
var
  TheClipBoard: TClipBoard;
begin
  TheClipBoard := ClipBoard;
  if TheClipBoard.HasFormat(CF_PICTURE)
    then TheSolapin.Photo.Assign(TheClipBoard);
end;

procedure TMainForm.SalirExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.GuardarComoExecute(Sender: TObject);
var
  CurrentPath: string;
begin
  CurrentPath := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(Application.ExeName));
  if (Count > 0) and SaveDialog1.Execute
    then
      begin
        if FileExists(SaveDialog1.FileName) then
          if MessageDlg(Format(sOverWrite, [SaveDialog1.FileName]),
            mtConfirmation, mbYesNoCancel, 0) = idYes
            then Informe.SaveToFile(SaveDialog1.FileName);
        ReportName := OpenDialog1.FileName;
      end;
  SetCurrentDir(CurrentPath);
end;

procedure TMainForm.AccessChange(Sender: TObject);
begin
  TheSolapin.Access := Access.ItemIndex;
end;

procedure TMainForm.AbrirExecute(Sender: TObject);
var
  i: integer;
  CurrentPath: string;
begin
  CurrentPath := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(Application.ExeName));
  if OpenDialog1.Execute
    then
      begin
        Informe.LoadFromFile(OpenDialog1.FileName);
        Clear;
        for i := pred(Informe.ControlCount) downto 0 do
          Glyphs[i].Visible := true;
        Count := Informe.ControlCount;
        ReportName := OpenDialog1.FileName;
      end;
  SetCurrentDir(CurrentPath);
end;

procedure TMainForm.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  CrearNuevo.Enabled  := Count > 0;
  Adicionar.Enabled   := Count < 10;
  Remover.Enabled     := CrearNuevo.Enabled;
  VistaPrevia.Enabled := CrearNuevo.Enabled;
  Imprimir.Enabled    := CrearNuevo.Enabled;
  Guardar.Enabled     := CrearNuevo.Enabled;
  GuardarComo.Enabled := CrearNuevo.Enabled;
  PegarFoto.Enabled   := ClipBoard.HasFormat(CF_PICTURE);
  Handled             := true;
end;

procedure TMainForm.Clear;
var
  i: integer;
begin
  for i := 9 downto 0 do
    Glyphs[i].Visible := false;
  Count := 0;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDlg('¿Está seguro que quiere salir?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes;
end;

procedure TMainForm.SetReportName(const Value: string);
begin
  if Value <> FReportName
    then
      begin
        FReportName := Value;
        if Value = ''
          then Caption := Title + NuevoReporte
          else Caption := ExtractFileName(Value);
      end;
end;

procedure TMainForm.GuardarExecute(Sender: TObject);
begin
  if ReportName = ''
    then GuardarComoExecute(Self)
    else Informe.SaveToFile(ReportName);
end;

procedure TMainForm.ChangePasswordExecute(Sender: TObject);
var
  FormChangePassword: TFormChangePassword;
begin
  FormChangePassword := TFormChangePassword.Create(Self);
  FormChangePassword.ShowModal;
  FormChangePassword.free;
end;

end.
