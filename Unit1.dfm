object Form1: TForm1
  Left = 351
  Top = 157
  Width = 736
  Height = 516
  Caption = 'sbrf3ToBankier'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 439
    Width = 720
    Height = 19
    Panels = <>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 720
    Height = 406
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1057#1077#1088#1074#1080#1089
      object SGIN: TStringGrid
        Left = 0
        Top = 0
        Width = 712
        Height = 378
        Align = alClient
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 50
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        ColWidths = (
          64
          64
          424
          117
          64)
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 712
        Height = 378
        Align = alClient
        TabOrder = 0
        object Label4: TLabel
          Left = 16
          Top = 24
          Width = 94
          Height = 13
          Caption = #1042#1093#1086#1076#1103#1097#1080#1081' '#1082#1072#1090#1072#1083#1086#1075
        end
        object Label5: TLabel
          Left = 144
          Top = 24
          Width = 32
          Height = 13
          Caption = 'Label5'
        end
        object Label6: TLabel
          Left = 16
          Top = 48
          Width = 114
          Height = 13
          Caption = #1050#1072#1090#1072#1083#1086#1075' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1093#1101#1096
        end
        object Label7: TLabel
          Left = 144
          Top = 48
          Width = 32
          Height = 13
          Caption = 'Label7'
        end
        object Label8: TLabel
          Left = 16
          Top = 72
          Width = 109
          Height = 13
          Caption = #1050#1072#1090#1072#1083#1086#1075' '#1082#1086#1085#1074#1077#1088#1090#1072#1094#1080#1080
        end
        object Label9: TLabel
          Left = 144
          Top = 72
          Width = 32
          Height = 13
          Caption = 'Label9'
        end
        object Label10: TLabel
          Left = 16
          Top = 96
          Width = 93
          Height = 13
          Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1082#1072#1090#1072#1083#1086#1075
        end
        object Label11: TLabel
          Left = 144
          Top = 96
          Width = 38
          Height = 13
          Caption = 'Label11'
        end
        object Label12: TLabel
          Left = 16
          Top = 120
          Width = 79
          Height = 13
          Caption = #1050#1072#1090#1072#1083#1086#1075' '#1072#1088#1093#1080#1074#1072
        end
        object Label13: TLabel
          Left = 144
          Top = 120
          Width = 38
          Height = 13
          Caption = 'Label13'
        end
        object Label14: TLabel
          Left = 16
          Top = 144
          Width = 100
          Height = 13
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1087#1088#1086#1074#1077#1088#1082#1080
        end
        object Label15: TLabel
          Left = 144
          Top = 144
          Width = 38
          Height = 13
          Caption = 'Label15'
        end
        object Label16: TLabel
          Left = 144
          Top = 168
          Width = 38
          Height = 13
          Caption = 'Label16'
        end
        object Label17: TLabel
          Left = 16
          Top = 192
          Width = 90
          Height = 13
          Caption = #1055#1091#1090#1100' '#1076#1086' check.bat'
        end
        object Label18: TLabel
          Left = 144
          Top = 192
          Width = 38
          Height = 13
          Caption = 'Label18'
        end
        object Label19: TLabel
          Left = 16
          Top = 216
          Width = 74
          Height = 13
          Caption = #1052#1072#1089#1082#1072' '#1092#1072#1081#1083#1086#1074
        end
        object Label20: TLabel
          Left = 144
          Top = 216
          Width = 38
          Height = 13
          Caption = 'Label20'
        end
        object CheckBox1: TCheckBox
          Left = 16
          Top = 168
          Width = 97
          Height = 17
          Caption = #1051#1086#1075#1080
          Enabled = False
          TabOrder = 0
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 712
        Height = 41
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 40
          Height = 13
          Caption = #1044#1072#1090#1072' '#1086#1090
        end
        object Label2: TLabel
          Left = 472
          Top = 16
          Width = 130
          Height = 13
          Caption = #1055#1086#1084#1077#1095#1072#1077#1084' '#1089' '#1085#1072#1078#1072#1090#1099#1084' Ctrl'
        end
        object Label3: TLabel
          Left = 168
          Top = 8
          Width = 12
          Height = 13
          Caption = #1076#1086
        end
        object DateTimePicker1: TDateTimePicker
          Left = 56
          Top = 8
          Width = 105
          Height = 21
          Date = 42348.636536932870000000
          Time = 42348.636536932870000000
          TabOrder = 0
          OnChange = DateTimePicker1Change
          OnKeyPress = DateTimePicker1KeyPress
        end
        object Button1: TButton
          Left = 336
          Top = 8
          Width = 121
          Height = 25
          Caption = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
          TabOrder = 1
          OnClick = Button1Click
        end
        object DateTimePicker2: TDateTimePicker
          Left = 192
          Top = 8
          Width = 105
          Height = 21
          Date = 42348.636536932870000000
          Time = 42348.636536932870000000
          TabOrder = 2
          OnChange = DateTimePicker1Change
          OnKeyPress = DateTimePicker1KeyPress
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 41
        Width = 712
        Height = 337
        Align = alClient
        Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        TabOrder = 1
        object DBGrid1: TDBGrid
          Left = 2
          Top = 15
          Width = 708
          Height = 320
          Align = alClient
          DataSource = DataSource1
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          PopupMenu = PopupMenu1
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnCellClick = DBGrid1CellClick
          OnDblClick = DBGrid1DblClick
        end
      end
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 720
    Height = 33
    Bands = <>
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 392
    Top = 8
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=VFPOLEDB.1;Data Source=D:\sbrf\base.dbf;Collating Seque' +
      'nce=MACHINE;'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'VFPOLEDB.1'
    Left = 424
    Top = 8
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from base')
    Left = 488
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    Left = 276
    Top = 152
    object N1: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 0
      ShortCut = 16464
      OnClick = N1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1074#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      OnClick = N6Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1086#1090#1084#1077#1095#1077#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      OnClick = N7Click
    end
    object N7: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      OnClick = DBGrid1DblClick
    end
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery2
    Left = 436
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 16
    object N3: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N4: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N4Click
      end
    end
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    SQL.Strings = (
      'select * from base')
    Left = 460
    Top = 8
  end
  object ImageList1: TImageList
    Left = 504
    Top = 56
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000CA650000C9620000C660
      0000C35C0000BF570000BA510000B44A0000AF420000A9390000A5300000A028
      00009D1F00009B1500009A0B00009A0B00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC660B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009B1600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CD681700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D1F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CF6A2000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A12800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D26C2B00FFFFFF00FFFFFF00FFFF
      FF009A110B009A110B00FFFFFF00FFFFFF009A110B009A110B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A53100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D56F3400FFFFFF00FFFFFF00FFFF
      FF00A22A2000A22A2000FFFFFF00FFFFFF00A22A2000A22A2000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00AA3A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DA733E00FFFFFF00FFFFFF00FFFF
      FF00AF423200AF423200AF423200FFFFFF00AF423200AF423200AF423200FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00AF4200000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE784700FFFFFF00FFFFFF00FFFF
      FF00C1594500C1594500C1594500FFFFFF00C1594500C1594500C1594500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B54A00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E37C5000FFFFFF00FFFFFF00FFFF
      FF00D46E5400FFFFFF00D46E5400D1644900D46E5400D46E5400D46E5400D46E
      5400FFFFFF00FFFFFF00FFFFFF00BA5100000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E8815800FFFFFF00FFFFFF00FFFF
      FF00E57D6100FFFFFF00E57D6100E57D6100E57D6100E57D6100E4755800E57D
      6100FFFFFF00FFFFFF00FFFFFF00BF5800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EC845E00FFFFFF00FFFFFF00FFFF
      FF00EF876800FFFFFF00FFFFFF00EF876800EF876800EF876800FFFFFF00EF87
      6800EF876800FFFFFF00FFFFFF00C35D00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0886300FFFFFF00FFFFFF00FFFF
      FF00F68D6C00FFFFFF00FFFFFF00F68D6C00F68D6C00F68D6C00FFFFFF00F68D
      6C00F68D6C00FFFFFF00FFFFFF00C76000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F38A6700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C96300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F58D6A00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CB6500000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F78E6C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F88F6D00F88F6E00F78E6C00F58D
      6B00F38B6800F0886400ED855E00E8815800E47D5100DE784800DA743E00D670
      3500D26C2B00D06A2200CE681900CC670B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0001000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
