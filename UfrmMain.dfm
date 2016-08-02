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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 37
    Width = 209
    Height = 442
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 416
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
      OnKeyDown = LabeledEdit3KeyDown
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
      OnKeyDown = LabeledEdit4KeyDown
    end
    object BitBtn1: TBitBtn
      Left = 88
      Top = 296
      Width = 75
      Height = 25
      Caption = #26597#35810
      TabOrder = 4
      OnClick = BitBtn1Click
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 16
      Width = 193
      Height = 81
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #19981#38480
        #24403#22825
        #26368#36817'3'#22825
        #26368#36817'1'#21608
        #26368#36817'1'#26376)
      TabOrder = 5
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 328
      Width = 193
      Height = 81
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #19981#38480
        #24403#22825
        #26368#36817'3'#22825
        #26368#36817'1'#21608
        #26368#36817'1'#26376)
      TabOrder = 6
    end
    object RadioGroup3: TRadioGroup
      Left = 8
      Top = 104
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
      object ToolButton1: TToolButton
        Left = 305
        Top = 2
        Width = 3
        Caption = 'ToolButton1'
        Style = tbsSeparator
      end
      object SpeedButton4: TSpeedButton
        Left = 308
        Top = 2
        Width = 88
        Height = 22
        Caption = #36873#39033
        OnClick = SpeedButton4Click
      end
      object ToolButton2: TToolButton
        Left = 396
        Top = 2
        Width = 3
        Caption = 'ToolButton2'
        ImageIndex = 0
        Style = tbsSeparator
      end
      object SpeedButton5: TSpeedButton
        Left = 399
        Top = 2
        Width = 112
        Height = 22
        Caption = #25253#34920#32534#36753#22120
        OnClick = SpeedButton5Click
      end
    end
  end
  object Panel2: TPanel
    Left = 209
    Top = 37
    Width = 703
    Height = 442
    Align = alClient
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 301
      Top = 1
      Height = 440
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 300
      Height = 440
      Align = alLeft
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      OnDrawColumnCell = DBGrid1DrawColumnCell
    end
    object Panel3: TPanel
      Left = 304
      Top = 1
      Width = 398
      Height = 440
      Align = alClient
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 1
        Top = 293
        Width = 396
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object DBGrid2: TDBGrid
        Left = 1
        Top = 1
        Width = 396
        Height = 292
        Align = alClient
        DataSource = DataSource2
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid2DrawColumnCell
      end
      object Memo1: TMemo
        Left = 1
        Top = 296
        Width = 396
        Height = 143
        Align = alBottom
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 479
    Width = 912
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 90
      end
      item
        Width = 100
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 100
      end
      item
        Width = 70
      end
      item
        Text = #25480#26435#20351#29992#21333#20301':'
        Width = 100
      end
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 265
    Top = 125
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 537
    Top = 102
  end
  object ADOQuery1: TADOQuery
    Connection = DM.ADOConnection1
    AfterOpen = ADOQuery1AfterOpen
    AfterScroll = ADOQuery1AfterScroll
    Parameters = <>
    Left = 297
    Top = 125
  end
  object ADOQuery2: TADOQuery
    Connection = DM.ADOConnection1
    AfterOpen = ADOQuery2AfterOpen
    Parameters = <>
    Left = 569
    Top = 102
  end
end
