object FormAcceso: TFormAcceso
  Left = 407
  Top = 240
  BorderStyle = bsDialog
  Caption = 'Acceso'
  ClientHeight = 88
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 81
    Height = 13
    Caption = 'Clave de Acceso'
  end
  object Edit1: TEdit
    Left = 96
    Top = 16
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 96
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
