object FormChangePassword: TFormChangePassword
  Left = 259
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Cambiar clave de acceso'
  ClientHeight = 175
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 59
    Height = 13
    Caption = 'Clave actual'
  end
  object Label2: TLabel
    Left = 8
    Top = 60
    Width = 61
    Height = 13
    Caption = 'Nueva clave'
  end
  object Label3: TLabel
    Left = 8
    Top = 100
    Width = 73
    Height = 13
    Caption = 'Confirmar clave'
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
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 3
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object Edit2: TEdit
    Left = 96
    Top = 56
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 96
    Top = 96
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
end
