object Informe: TInforme
  Left = 224
  Top = 103
  Width = 544
  Height = 375
  Caption = 'Solapines para Imprimir'
  Color = clNone
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object ImprimirCmd: TMenuItem
      Caption = 'Im&primir'
      OnClick = ImprimirCmdClick
    end
    object Salir1: TMenuItem
      Caption = '&Cerrar'
      OnClick = Salir1Click
    end
  end
end
