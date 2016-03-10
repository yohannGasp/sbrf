object AboutBox: TAboutBox
  Left = 434
  Top = 242
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 213
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 281
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 16
      Top = 16
      Width = 140
      Height = 13
      Caption = #1050#1086#1085#1074#1077#1088#1090#1086#1088' SBRF3 - formlang'
      IsControl = True
    end
    object Version: TLabel
      Left = 16
      Top = 40
      Width = 126
      Height = 13
      Caption = #1042#1077#1088#1089#1080#1103' 1.2 '#1086#1090' 23.12.2015'
      IsControl = True
    end
  end
  object OKButton: TButton
    Left = 111
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
