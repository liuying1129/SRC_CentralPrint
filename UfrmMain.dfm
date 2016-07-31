object frmMain: TfrmMain
  Left = 192
  Top = 122
  Width = 928
  Height = 536
  Caption = #38598#20013#25171#21360
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 37
    Width = 209
    Height = 461
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 432
      Width = 104
      Height = 13
      Caption = #20849#8212#8212#20154#27425#26410#25171#21360
    end
    object LabeledEdit1: TLabeledEdit
      Left = 78
      Top = 160
      Width = 121
      Height = 21
      EditLabel.Width = 72
      EditLabel.Height = 13
      EditLabel.Caption = #38376#35786'/'#20303#38498#21495
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 72
      Top = 192
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object LabeledEdit3: TLabeledEdit
      Left = 72
      Top = 224
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #36865#26816#31185#23460
      LabelPosition = lpLeft
      TabOrder = 2
    end
    object LabeledEdit4: TLabeledEdit
      Left = 72
      Top = 256
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #36865#26816#21307#29983
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object BitBtn1: TBitBtn
      Left = 88
      Top = 304
      Width = 75
      Height = 25
      Caption = #26597#35810
      TabOrder = 4
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 344
      Width = 193
      Height = 81
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #24403#22825
        #26368#36817'3'#22825
        #26368#36817'1'#21608
        #26368#36817'1'#26376
        #19981#38480)
      TabOrder = 5
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 16
      Width = 193
      Height = 81
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #24403#22825
        #26368#36817'3'#22825
        #26368#36817'1'#21608
        #26368#36817'1'#26376
        #19981#38480)
      TabOrder = 6
    end
    object RadioGroup3: TRadioGroup
      Left = 8
      Top = 112
      Width = 193
      Height = 41
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #19981#38480
        #26410#25171#21360)
      TabOrder = 7
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 912
    Height = 37
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 33
        Width = 908
      end>
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 895
      Height = 33
      Caption = 'ToolBar1'
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 2
        Width = 81
        Height = 22
        Caption = #25171#21360
      end
      object SpeedButton2: TSpeedButton
        Left = 81
        Top = 2
        Width = 112
        Height = 22
        Caption = #20840#37096#25171#21360
      end
      object SpeedButton3: TSpeedButton
        Left = 193
        Top = 2
        Width = 112
        Height = 22
        Caption = #25171#21360#35813#30149#20154
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 216
    Top = 56
    Width = 289
    Height = 417
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object DBGrid2: TDBGrid
    Left = 520
    Top = 56
    Width = 369
    Height = 281
    TabOrder = 3
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Memo1: TMemo
    Left = 520
    Top = 352
    Width = 369
    Height = 121
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
end
