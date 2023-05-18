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
    Height = 441
    Align = alLeft
    Color = 16767438
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 52
      Height = 13
      Caption = #24320#22987#26085#26399
    end
    object Label2: TLabel
      Left = 8
      Top = 79
      Width = 52
      Height = 13
      Caption = #32467#26463#26085#26399
    end
    object Label3: TLabel
      Left = 35
      Top = 191
      Width = 39
      Height = 13
      Caption = #24037#20316#32452
    end
    object LabeledEdit1: TLabeledEdit
      Left = 78
      Top = 212
      Width = 121
      Height = 19
      Ctl3D = False
      EditLabel.Width = 72
      EditLabel.Height = 13
      EditLabel.Caption = #38376#35786'/'#20303#38498#21495
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 78
      Top = 236
      Width = 121
      Height = 19
      Ctl3D = False
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 1
    end
    object LabeledEdit3: TLabeledEdit
      Left = 78
      Top = 260
      Width = 121
      Height = 19
      Ctl3D = False
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #36865#26816#31185#23460
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 2
      OnKeyDown = LabeledEdit3KeyDown
    end
    object LabeledEdit4: TLabeledEdit
      Left = 78
      Top = 284
      Width = 121
      Height = 19
      Ctl3D = False
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #36865#26816#21307#29983
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 3
      OnKeyDown = LabeledEdit4KeyDown
    end
    object BitBtn1: TBitBtn
      Left = 78
      Top = 385
      Width = 121
      Height = 25
      Caption = #26597#35810'F3'
      TabOrder = 4
      OnClick = BitBtn1Click
    end
    object RadioGroup3: TRadioGroup
      Left = 8
      Top = 130
      Width = 193
      Height = 41
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #19981#38480
        #26410#25171#21360)
      TabOrder = 5
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 415
      Width = 75
      Height = 17
      Caption = #25171#21360#39044#35272
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
    end
    object CheckBox2: TCheckBox
      Left = 128
      Top = 415
      Width = 75
      Height = 17
      Caption = #25353#32452#20998#39029
      TabOrder = 7
    end
    object DateTimePicker1: TDateTimePicker
      Left = 8
      Top = 33
      Width = 95
      Height = 21
      Date = 45272.000000000000000000
      Time = 45272.000000000000000000
      TabOrder = 8
    end
    object DateTimePicker2: TDateTimePicker
      Left = 8
      Top = 95
      Width = 95
      Height = 21
      Date = 45272.999988425920000000
      Time = 45272.999988425920000000
      TabOrder = 9
    end
    object RadioGroup1: TRadioGroup
      Left = 108
      Top = 17
      Width = 93
      Height = 100
      Caption = #24555#36895#36873#25321#26085#26399
      Ctl3D = True
      ItemIndex = 0
      Items.Strings = (
        #20170#22825
        #26368#36817'1'#21608
        #26368#36817'1'#26376)
      ParentCtl3D = False
      TabOrder = 10
      OnClick = RadioGroup1Click
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 329
      Width = 193
      Height = 49
      Caption = #25490#24207
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        #24739#32773#22995#21517
        #30149#21382#21495
        #25152#23646#20844#21496)
      TabOrder = 11
    end
    object ComboBox1: TComboBox
      Left = 78
      Top = 187
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 12
    end
    object LabeledEdit5: TLabeledEdit
      Left = 78
      Top = 308
      Width = 121
      Height = 19
      Ctl3D = False
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #25152#23646#20844#21496
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 13
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
    Color = 16767438
    ParentColor = False
    object ToolBar1: TToolBar
      Left = 9
      Top = 0
      Width = 895
      Height = 33
      ButtonWidth = 100
      Caption = 'ToolBar1'
      Color = 16767438
      ParentColor = False
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 2
        Width = 81
        Height = 22
        Caption = #25171#21360'F7'
        OnClick = SpeedButton1Click
      end
      object SpeedButton6: TSpeedButton
        Left = 81
        Top = 2
        Width = 112
        Height = 22
        Caption = #20998#32452#25171#21360'F9'
        OnClick = SpeedButton6Click
      end
      object ToolButton1: TToolButton
        Left = 193
        Top = 2
        Width = 3
        Caption = 'ToolButton1'
        Style = tbsSeparator
      end
      object SpeedButton4: TSpeedButton
        Left = 196
        Top = 2
        Width = 88
        Height = 22
        Caption = #36873#39033
        OnClick = SpeedButton4Click
      end
      object ToolButton2: TToolButton
        Left = 284
        Top = 2
        Width = 3
        Caption = 'ToolButton2'
        ImageIndex = 0
        Style = tbsSeparator
      end
      object SpeedButton5: TSpeedButton
        Left = 287
        Top = 2
        Width = 112
        Height = 22
        Caption = #25253#34920#32534#36753#22120
        OnClick = SpeedButton5Click
      end
      object ToolButton3: TToolButton
        Left = 399
        Top = 2
        Width = 3
        Caption = 'ToolButton3'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object SpeedButton2: TSpeedButton
        Left = 402
        Top = 2
        Width = 112
        Height = 22
        Caption = #20999#25442#24080#21495
        OnClick = SpeedButton2Click
      end
      object ToolButton4: TToolButton
        Left = 514
        Top = 2
        Width = 3
        Caption = 'ToolButton4'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object SpeedButton8: TSpeedButton
        Left = 517
        Top = 2
        Width = 112
        Height = 22
        Caption = #20462#25913#23494#30721
        OnClick = SpeedButton8Click
      end
      object ToolButton5: TToolButton
        Left = 629
        Top = 2
        Width = 3
        Caption = 'ToolButton5'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object SpeedButton3: TSpeedButton
        Left = 632
        Top = 2
        Width = 35
        Height = 22
        Caption = #20840#36873
        OnClick = SpeedButton3Click
      end
      object SpeedButton7: TSpeedButton
        Left = 667
        Top = 2
        Width = 45
        Height = 22
        Caption = #20840#19981#36873
        OnClick = SpeedButton7Click
      end
    end
  end
  object Panel2: TPanel
    Left = 209
    Top = 37
    Width = 703
    Height = 441
    Align = alClient
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 305
      Top = 1
      Height = 439
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 304
      Height = 439
      Align = alLeft
      Color = 16767438
      Ctl3D = False
      DataSource = DataSource1
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      OnDrawColumnCell = DBGrid1DrawColumnCell
    end
    object Panel3: TPanel
      Left = 308
      Top = 1
      Width = 394
      Height = 439
      Align = alClient
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 1
        Top = 292
        Width = 392
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object Memo1: TMemo
        Left = 1
        Top = 295
        Width = 392
        Height = 143
        Align = alBottom
        Color = 16767438
        Ctl3D = False
        ParentCtl3D = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object PageControl1: TPageControl
        Left = 1
        Top = 1
        Width = 392
        Height = 291
        ActivePage = TabSheet2
        Align = alClient
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = #26816#39564#32467#26524
          object DBGrid2: TDBGrid
            Left = 0
            Top = 0
            Width = 384
            Height = 263
            Align = alClient
            Color = 16767438
            Ctl3D = False
            DataSource = DataSource2
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = #23435#20307
            TitleFont.Style = []
            OnDrawColumnCell = DBGrid2DrawColumnCell
          end
        end
        object TabSheet2: TTabSheet
          Caption = #22270#20687
          ImageIndex = 1
          object ScrollBoxPicture: TScrollBox
            Left = 0
            Top = 0
            Width = 384
            Height = 263
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 478
    Width = 912
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Text = #25805#20316#20154#21592#24037#21495':'
        Width = 82
      end
      item
        Width = 100
      end
      item
        Text = #25805#20316#20154#21592#22995#21517':'
        Width = 82
      end
      item
        Width = 70
      end
      item
        Text = #25480#26435#20351#29992#21333#20301':'
        Width = 82
      end
      item
        Width = 200
      end
      item
        Text = #26381#21153#21517':'
        Width = 47
      end
      item
        Width = 150
      end
      item
        Text = #25968#25454#24211':'
        Width = 47
      end
      item
        Width = 50
      end>
  end
  object DataSource1: TDataSource
    DataSet = ADObasic
    Left = 265
    Top = 125
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 537
    Top = 102
  end
  object ADObasic: TADOQuery
    Connection = DM.ADOConnection1
    AfterOpen = ADObasicAfterOpen
    AfterScroll = ADObasicAfterScroll
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
  object frReport1: TfrReport
    Dataset = frDBDataSet1
    InitialZoom = pzDefault
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    RebuildPrinter = False
    OnGetValue = frReport1GetValue
    OnBeforePrint = frReport1BeforePrint
    OnPrintReport = frReport1PrintReport
    Left = 305
    Top = 253
    ReportForm = {19000000}
  end
  object ado_print: TADOQuery
    Connection = DM.ADOConnection1
    Parameters = <>
    Left = 273
    Top = 333
  end
  object frDBDataSet1: TfrDBDataSet
    DataSet = ado_print
    Left = 337
    Top = 253
  end
  object ActionList1: TActionList
    Left = 377
    Top = 253
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 114
      OnExecute = BitBtn1Click
    end
    object Action2: TAction
      Caption = 'Action2'
      ShortCut = 116
    end
    object Action3: TAction
      Caption = 'Action3'
      ShortCut = 118
      OnExecute = SpeedButton1Click
    end
    object Action4: TAction
      Caption = 'Action4'
      ShortCut = 120
      OnExecute = SpeedButton6Click
    end
  end
end
