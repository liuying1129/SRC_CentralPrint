unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils, ADOLYGetcode,ShellAPI, FR_Class,Printers,
  FR_DSet, FR_DBSet,Jpeg,Chart,FR_Chart,Series,Math, ActnList,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, EhLibADO,
  frxClass, frxDBSet, frxExportPDF, frxChart, FileCtrl;

//==为了通过发送消息更新主窗体状态栏而增加==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    BitBtn1: TBitBtn;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    RadioGroup3: TRadioGroup;
    ToolButton1: TToolButton;
    SpeedButton4: TSpeedButton;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Splitter2: TSplitter;
    SpeedButton5: TSpeedButton;
    ToolButton2: TToolButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADObasic: TADOQuery;
    ADOQuery2: TADOQuery;
    frReport1: TfrReport;
    ado_print: TADOQuery;
    frDBDataSet1: TfrDBDataSet;
    SpeedButton6: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid2: TDBGrid;
    ScrollBoxPicture: TScrollBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    ToolButton5: TToolButton;
    SpeedButton8: TSpeedButton;
    ComboBox1: TComboBox;
    Label3: TLabel;
    LabeledEdit5: TLabeledEdit;
    DBGrid1: TDBGridEh;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxDBDataset2: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    SpeedButton3: TSpeedButton;
    SpeedButton9: TSpeedButton;
    RadioGroup2: TRadioGroup;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabeledEdit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ADObasicAfterScroll(DataSet: TDataSet);
    procedure ADObasicAfterOpen(DataSet: TDataSet);
    procedure ADOQuery2AfterOpen(DataSet: TDataSet);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure frReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure frReport1BeforePrint(Memo: TStringList; View: TfrView);
    procedure frReport1PrintReport;
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure DBGrid1TitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure DBGrid1SelectionChanged(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure frxReport1PrintReport(Sender: TObject);
    procedure frxReport1GetValue(const VarName: String;
      var Value: Variant);
    procedure frxReport1BeforePrint(Sender: TfrxReportComponent);
    procedure frxReport1BeginDoc(Sender: TObject);
  private
    procedure WriteProfile;
    procedure ReadConfig;
    procedure ReadIni;
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
    procedure ShowPictureValue(const ACheckUnid,AifCompleted: integer);
  public
    procedure Draw_MVIS2035_Curve(Chart_XLB:TChart;const X1,Y1,X2,Y2,X1_MIN,Y1_MIN,X2_MIN,Y2_MIN,
                                                   X1_MAX,Y1_MAX,X2_MAX,Y2_MAX:Real);
    procedure updatechart(ChartHistogram:TChart;const strHistogram:string;const strEnglishName:string;const strXTitle:string);
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM, UfrmModifyPwd;
var
  lsGroupShow:TStrings;

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;

  PageControl1.ActivePageIndex:=0;
  
  ReadConfig;
  UpdateStatusBar(#$2+'6:'+SCSYDW);
  UpdateStatusBar(#$2+'8:'+gServerName);
  UpdateStatusBar(#$2+'10:'+gDbName);
  
  LoadGroupName(ComboBox1,'select name from CommCode where TypeName=''检验组别'' group by name');
end;

procedure TfrmMain.ReadConfig;
var
  configini:tinifile;
begin
  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  RadioGroup2.ItemIndex:=configini.ReadInteger('Interface','ifPreview',0);{记录打印预览、直接打印、导出PDF}
  DBGrid1.Width:=configini.ReadInteger('Interface','gridBaseInfoWidth',680);{记录基本信息框宽度}
  Memo1.Height:=configini.ReadInteger('Interface','memoLogHeight',150);{记录组合项目选择框高度}

  RadioGroup3.ItemIndex:=configini.ReadInteger('Interface','ifPrintRadio',0);

  LabeledEdit4.Text:=configini.ReadString('Interface','check_doctor','');{记录送检医生,实现“仅看自己送检的样本”功能}
  
  ReadIni();

  configini.Free;
end;

procedure TfrmMain.ReadIni;
var
  configini:tinifile;

  pInStr,pDeStr:Pchar;
  i:integer;
begin
  //读系统代码
  SCSYDW:=ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''系统代码'' and ReMark=''授权使用单位'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'未授权单位'加密后的字符串
  //======解密SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========
  BASE_URL:=ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''系统代码'' and ReMark=''远程请求地址'' ');
  //if trim(BASE_URL)='' then BASE_URL:='http://211.97.0.5:8080/YkAPI/service';

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  SmoothNum:=configini.ReadInteger('报表','直方图光滑次数',0);
  ifShowPrintDialog:=configini.ReadBool('报表','打印对话框',false);
  ifEnterGetCode:=configini.ReadBool('选项','填写病人基本信息时,直接回车弹出取码框',false);
  deptname_match:=configini.ReadString('选项','送检科室取码的匹配方式','');
  check_doctor_match:=configini.ReadString('选项','送检医生取码的匹配方式','');

  WorkGroup_T1:=configini.ReadString('打印模板','特殊模板1工作组','');
  TempFile_T1:=configini.ReadString('打印模板','特殊模板1文件','');
  WorkGroup_T2:=configini.ReadString('打印模板','特殊模板2工作组','');
  TempFile_T2:=configini.ReadString('打印模板','特殊模板2文件','');
  WorkGroup_T3:=configini.ReadString('打印模板','特殊模板3工作组','');
  TempFile_T3:=configini.ReadString('打印模板','特殊模板3文件','');  
  WorkGroup_T4:=configini.ReadString('打印模板','特殊模板4工作组','');
  TempFile_T4:=configini.ReadString('打印模板','特殊模板4文件','');
  WorkGroup_T5:=configini.ReadString('打印模板','特殊模板5工作组','');
  TempFile_T5:=configini.ReadString('打印模板','特殊模板5文件','');
  WorkGroup_T6:=configini.ReadString('打印模板','特殊模板6工作组','');
  TempFile_T6:=configini.ReadString('打印模板','特殊模板6文件','');
  WorkGroup_T7:=configini.ReadString('打印模板','特殊模板7工作组','');
  TempFile_T7:=configini.ReadString('打印模板','特殊模板7文件','');
  WorkGroup_T8:=configini.ReadString('打印模板','特殊模板8工作组','');
  TempFile_T8:=configini.ReadString('打印模板','特殊模板8文件','');
  WorkGroup_T9:=configini.ReadString('打印模板','特殊模板9工作组','');
  TempFile_T9:=configini.ReadString('打印模板','特殊模板9文件','');  
  WorkGroup_T10:=configini.ReadString('打印模板','特殊模板10工作组','');
  TempFile_T10:=configini.ReadString('打印模板','特殊模板10文件','');
  WorkGroup_T11:=configini.ReadString('打印模板','特殊模板11工作组','');
  TempFile_T11:=configini.ReadString('打印模板','特殊模板11文件','');
  WorkGroup_T12:=configini.ReadString('打印模板','特殊模板12工作组','');
  TempFile_T12:=configini.ReadString('打印模板','特殊模板12文件','');
  WorkGroup_T13:=configini.ReadString('打印模板','特殊模板13工作组','');
  TempFile_T13:=configini.ReadString('打印模板','特殊模板13文件','');
  WorkGroup_T14:=configini.ReadString('打印模板','特殊模板14工作组','');
  TempFile_T14:=configini.ReadString('打印模板','特殊模板14文件','');
  WorkGroup_T15:=configini.ReadString('打印模板','特殊模板15工作组','');
  TempFile_T15:=configini.ReadString('打印模板','特殊模板15文件','');  

  GP_WorkGroup_T1:=configini.ReadString('打印模板','分组模板1工作组','');
  GP_TempFile_T1:=configini.ReadString('打印模板','分组模板1文件','');
  GP_WorkGroup_T2:=configini.ReadString('打印模板','分组模板2工作组','');
  GP_TempFile_T2:=configini.ReadString('打印模板','分组模板2文件','');
  GP_WorkGroup_T3:=configini.ReadString('打印模板','分组模板3工作组','');
  GP_TempFile_T3:=configini.ReadString('打印模板','分组模板3文件','');  

  configini.Free;
end;

procedure TfrmMain.SpeedButton4Click(Sender: TObject);
var                                                                           
  ss:string;
  sWorkGroup:string;
  adotemp3:tadoquery;
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  adotemp3:=tadoquery.Create(nil);
  adotemp3.Connection:=DM.ADOConnection1;
  adotemp3.Close;
  adotemp3.SQL.Clear;
  adotemp3.SQL.Text:='select name from CommCode where TypeName=''检验组别'' group by name';
  adotemp3.Open;
  while not adotemp3.Eof do
  begin
    sWorkGroup:=sWorkGroup+#13+trim(adotemp3.fieldbyname('name').AsString);
    adotemp3.Next;
  end;
  adotemp3.Free;
  sWorkGroup:=trim(sWorkGroup);

  ss:='直方图光滑次数'+#2+'Edit'+#2+#2+'0'+#2+'注:次数越多曲线越光滑,但曲线偏离越多'+#2+#3+
      '打印对话框'+#2+'CheckListBox'+#2+#2+'0'+#2+'打印预览模式的高级选项(打印机、页码、份数等)'+#2+#3+
      '填写病人基本信息时,直接回车弹出取码框'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '送检科室取码的匹配方式'+#2+'Combobox'+#2+'模糊匹配'+#13+'左匹配'+#13+'右匹配'+#13+'全匹配'+#2+'1'+#2+#2+#3+
      '送检医生取码的匹配方式'+#2+'Combobox'+#2+'模糊匹配'+#13+'左匹配'+#13+'右匹配'+#13+'全匹配'+#2+'1'+#2+#2+#3+
      '特殊模板1工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板1文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板2工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板2文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板3工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板3文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板4工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板4文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板5工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板5文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板6工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板6文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板7工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板7文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板8工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板8文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板9工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板9文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板10工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板10文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板11工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板11文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板12工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板12文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板13工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板13文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板14工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板14文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板15工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板15文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '分组模板1工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '分组模板1文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '分组模板2工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '分组模板2文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '分组模板3工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '分组模板3文件'+#2+'File'+#2+#2+'2'+#2+#2+#3;
  if ShowOptionForm('选项','报表'+#2+'选项'+#2+'打印模板',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
	  ReadIni;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
var
  i,J2Pos,J2Len,TextLen,j:integer;
  tmpText:string;
begin
  TextLen:=length(text);
  for i :=0 to StatusBar1.Panels.Count-1 do
  begin
    J2Pos:=pos(#$2+inttostr(i)+':',text);
    J2Len:=length(#$2+inttostr(i)+':');
    if J2Pos<>0 then
    begin
      tmpText:=text;
      tmpText:=copy(tmpText,J2Pos+J2Len,TextLen-J2Pos-J2Len+1);
      j:=pos(#$2,tmpText);
      if j<>0 then tmpText:=leftstr(tmpText,j-1);
      StatusBar1.Panels[i].Text:=tmpText;
    end;
  end;
end;

procedure TfrmMain.WMUpdateTextStatus(var message: twmupdatetextstatus);
begin
  UpdateStatusBar(pchar(message.Text));
  message.Result:=-1;
end;

procedure TfrmMain.WriteProfile;
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  if DBGrid1.Width<60 then DBGrid1.Width:=60;
  configini.WriteInteger('Interface','gridBaseInfoWidth',DBGrid1.Width);{记录基本信息框宽度}
  if Memo1.Height<60 then Memo1.Height:=60;
  configini.WriteInteger('Interface','memoLogHeight',Memo1.Height);{记录结果框高度}
  
  configini.WriteInteger('Interface','ifPrintRadio',RadioGroup3.ItemIndex);
  configini.WriteInteger('Interface','ifPreview',RadioGroup2.ItemIndex);{记录是否打印预览模式}

  configini.WriteString('Interface','check_doctor',LabeledEdit4.Text);{记录送检医生,实现“仅看自己送检的样本”功能}

  configini.Free;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  WriteProfile;

  lsGroupShow.Free;
end;

procedure TfrmMain.LabeledEdit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmpADOLYGetcode:TADOLYGetcode;
begin
  if key<>13 then exit;
  tmpADOLYGetcode:=TADOLYGetcode.create(nil);
  tmpADOLYGetcode.Connection:=DM.ADOConnection1;
  if deptname_match='全匹配' then tmpADOLYGetcode.GetCodePos:=gcAll
    else if deptname_match='左匹配' then tmpADOLYGetcode.GetCodePos:=gcLeft
      else if deptname_match='右匹配' then tmpADOLYGetcode.GetCodePos:=gcRight
        else tmpADOLYGetcode.GetCodePos:=gcNone;
  tmpADOLYGetcode.IfNullGetCode:=ifEnterGetCode;
  tmpADOLYGetcode.OpenStr:='select name as 名称 from CommCode where TypeName=''部门'' ';
  tmpADOLYGetcode.InField:='id,wbm,pym';
  tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
  tmpADOLYGetcode.ShowX:=left+tLabeledEdit(SENDER).Parent.Left+tLabeledEdit(SENDER).Left;
  tmpADOLYGetcode.ShowY:=top+22{当前窗体标题栏高度}+21{当前窗体菜单高度}+tLabeledEdit(SENDER).Parent.Top+tLabeledEdit(SENDER).Parent.Parent.Top{Panel7}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Height;

  if tmpADOLYGetcode.Execute then
  begin
    tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
  end;
  tmpADOLYGetcode.Free;
end;

procedure TfrmMain.LabeledEdit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmpADOLYGetcode:TADOLYGetcode;
begin
  if key<>13 then exit;
  tmpADOLYGetcode:=TADOLYGetcode.create(nil);
  tmpADOLYGetcode.Connection:=DM.ADOConnection1;
  if check_doctor_match='全匹配' then tmpADOLYGetcode.GetCodePos:=gcAll
    else if check_doctor_match='左匹配' then tmpADOLYGetcode.GetCodePos:=gcLeft
      else if check_doctor_match='右匹配' then tmpADOLYGetcode.GetCodePos:=gcRight
        else tmpADOLYGetcode.GetCodePos:=gcNone;
  tmpADOLYGetcode.IfNullGetCode:=ifEnterGetCode;
  tmpADOLYGetcode.OpenStr:='select name as 名称 from worker';
  tmpADOLYGetcode.InField:='id,wbm,pinyin';
  tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
  tmpADOLYGetcode.ShowX:=left+tLabeledEdit(SENDER).Parent.Left+tLabeledEdit(SENDER).Left;
  tmpADOLYGetcode.ShowY:=top+22{当前窗体标题栏高度}+21{当前窗体菜单高度}+tLabeledEdit(SENDER).Parent.Top+tLabeledEdit(SENDER).Parent.Parent.Top{Panel7}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Height;

  if tmpADOLYGetcode.Execute then
  begin
    tLabeledEdit(SENDER).Text:=tmpADOLYGetcode.OutValue[0];
  end;
  tmpADOLYGetcode.Free;
end;

procedure TfrmMain.SpeedButton5Click(Sender: TObject);
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if ShellExecute(Handle, 'Open', Pchar(ExtractFilePath(application.ExeName)+'FrfSet.exe'), '', '', SW_ShowNormal)<=32 then
    MessageDlg((Sender as TSpeedButton).Caption+'(FrfSet.exe)打开失败!',mtError,[mbOK],0);
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  strsql22,strsql44,STRSQL45,STRSQL46,STRSQL47,STRSQL48,{STRSQL49,}STRSQL50,STRSQL51,STRSQL55: string;
begin
  strsql44:=' check_date between :P_DateTimePicker1 and :P_DateTimePicker2 and ';  
  if RadioGroup3.ItemIndex=1 then
    STRSQL46:=' isnull((case when len(caseno)=8 and LEFT(caseno,1)=''8'' then 1 else printtimes end),0)<=0 and '
  else STRSQL46:='';
  if trim(ComboBox1.Text)<>'' then STRSQL51:=' combin_id='''+trim(ComboBox1.Text)+''' and '
  else STRSQL51:='';
  if trim(LabeledEdit1.Text)<>'' then STRSQL48:=' Caseno='''+trim(LabeledEdit1.Text)+''' and '
  else STRSQL48:='';
  if trim(LabeledEdit2.Text)<>'' then STRSQL22:=' patientname like ''%'+trim(LabeledEdit2.Text)+'%'' and '
  else STRSQL22:='';
  if trim(LabeledEdit3.Text)<>'' then STRSQL45:=' deptname='''+trim(LabeledEdit3.Text)+''' and '
  else STRSQL45:='';
  if trim(LabeledEdit4.Text)<>'' then STRSQL50:=' check_doctor='''+trim(LabeledEdit4.Text)+''' and '
  else STRSQL50:='';
  if trim(LabeledEdit5.Text)<>'' then STRSQL55:=' WorkCompany like ''%'+trim(LabeledEdit5.Text)+'%'' and '
  else STRSQL55:='';
  STRSQL47:=' isnull(report_doctor,'''')<>'''' ';  
  //if RadioGroup2.ItemIndex=1 then STRSQL49:=' order by caseno '//南沙慢病关医生要求按病历号排序
  //  else if RadioGroup2.ItemIndex=2 then STRSQL49:=' order by WorkCompany '//北京景像要求按所属公司排序
  //    else STRSQL49:=' order by patientname ';
  ADObasic.Close;
  ADObasic.SQL.Clear;
  ADObasic.SQL.Add(SHOW_CHK_CON);
  ADObasic.SQL.Add(' where ');
  ADObasic.SQL.Add(strsql44);
  ADObasic.SQL.Add(strsql46);
  ADObasic.SQL.Add(strsql51);
  ADObasic.SQL.Add(strsql48);
  ADObasic.SQL.Add(strsql22);
  ADObasic.SQL.Add(strsql45);
  ADObasic.SQL.Add(strsql50);
  ADObasic.SQL.Add(strsql55);
  ADObasic.SQL.Add(strsql47);
  //ADObasic.SQL.Add(strsql49);
  ADObasic.Parameters.ParamByName('P_DateTimePicker1').Value :=DateTimePicker1.DateTime;//设计期Time设置为00:00:00.放心,下拉选择日期时不会改变Time值
  ADObasic.Parameters.ParamByName('P_DateTimePicker2').Value :=DateTimePicker2.DateTime;//设计期Time设置为23:59:59.放心,下拉选择日期时不会改变Time值
  ADObasic.Open;
end;

procedure TfrmMain.ADObasicAfterScroll(DataSet: TDataSet);
var
  strsql11:string;
begin
  if not ADObasic.Active then exit;

  strsql11:='select '+
            '(case when photo is null then null else ''图'' end) as 图,'+
            'combin_Name as 组合项目,name as 名称,english_name as 英文名,itemvalue as 检验结果,'+
            'min_value as 最小值,max_value as 最大值,'+
            'unit as 单位,'+
            'pkcombin_id as 组合项目号,itemid as 项目编号,valueid as 唯一编号 '+
            ' from '+
            ifThen(ADObasic.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' WITH(NOLOCK) where pkunid=:pkunid and issure=1 '+
            ' order by pkcombin_id,printorder ';

  ADOQuery2.Close;
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Text:=strsql11;
  ADOQuery2.Parameters.ParamByName('pkunid').Value:=ADObasic.FieldByName('唯一编号').AsInteger;
  try
    ADOQuery2.Open;
  except
  end;

  ShowPictureValue(DataSet.fieldbyname('唯一编号').AsInteger,DataSet.fieldbyname('ifCompleted').AsInteger);
end;

procedure TfrmMain.ADObasicAfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;

  dbgrid1.Columns[0].Width:=42;//姓名
  dbgrid1.Columns[1].Width:=30;//性别
  dbgrid1.Columns[2].Width:=30;//年龄
  dbgrid1.Columns[3].Width:=30;//打印次数
  dbgrid1.Columns[4].Width:=65;//病历号
  dbgrid1.Columns[5].Width:=30;//床号
  dbgrid1.Columns[6].Width:=60;//送检科室
  dbgrid1.Columns[7].Width:=55;//送检医生
  dbgrid1.Columns[8].Width:=135;//检查日期
  dbgrid1.Columns[9].Width:=72;//申请日期
  dbgrid1.Columns[10].Width:=42;//审核者
  //dbgrid1.Columns[11].Width:=150;//组合项目串
  dbgrid1.Columns[11].Width:=42;//工作组
  dbgrid1.Columns[12].Width:=42;//操作者
  dbgrid1.Columns[13].Width:=60;
  dbgrid1.Columns[14].Width:=60;
  dbgrid1.Columns[15].Width:=60;
  dbgrid1.Columns[16].Width:=60;
  dbgrid1.Columns[17].Width:=60;
  dbgrid1.Columns[18].Width:=60;
  dbgrid1.Columns[19].Width:=60;
  dbgrid1.Columns[20].Width:=60;
  dbgrid1.Columns[21].Width:=60;

  dbgrid1.Columns[0].Title.TitleButton:=true;//排序,姓名
  dbgrid1.Columns[4].Title.TitleButton:=true;//排序,病历号
  dbgrid1.Columns[21].Title.TitleButton:=true;//排序,所属公司

  dbgrid1.FrozenCols:=1;//第1列冻结
end;

procedure TfrmMain.ADOQuery2AfterOpen(DataSet: TDataSet);
var
  adotemp11:tadoquery;
  strsql11:string;
begin
  //用不同的颜色进行分组标识(此过程放在要分组的数据集的AfterOpen过程中)
  strsql11:='select '+
            'DISTINCT pkcombin_id '+
            'from '+
            ifThen(ADObasic.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' WITH(NOLOCK) where pkunid=:pkunid and issure=1 order by pkcombin_id ';

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=dm.ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:=strsql11;
  adotemp11.Parameters.ParamByName('pkunid').Value :=ADObasic.FieldByName('唯一编号').AsInteger;
  adotemp11.Open;
  lsGroupShow.Clear;
  while not adotemp11.Eof do
  begin
    lsGroupShow.Add(adotemp11.fieldbyname('pkcombin_id').AsString);

    adotemp11.Next;
  end;
  adotemp11.Free;
  //========================

  if not DataSet.Active then exit;
  
  dbgrid2.Columns[1].Width:=80;//组合项目中文名
  dbgrid2.Columns[2].Width:=80;//中文名
  dbgrid2.Columns[3].Width:=50;//英文名
  dbgrid2.Columns[4].Width:=70;//检验结果
    
  dbgrid2.Columns[5].Width:=50;
  dbgrid2.Columns[6].Width:=50;
  dbgrid2.Columns[7].Width:=50;

  VisibleColumn(dbgrid2,'项目编号',false);
  VisibleColumn(dbgrid2,'组合项目号',false);
  VisibleColumn(dbgrid2,'唯一编号',false);
end;

procedure TfrmMain.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  i:integer;
  ItemChnName,cur_value,min_value,max_value:string;//,nst_value
  sGroup:string;
  adotemp22:tadoquery;
begin
  //======================检验结果超出参考范围时变化颜色======================//
  if (datacol=4) then
  begin
    ItemChnName:=trim(ADOQuery2.fieldbyname('项目编号').AsString);
    cur_value:=trim(ADOQuery2.fieldbyname('检验结果').AsString);
    min_value:=trim(ADOQuery2.fieldbyname('最小值').AsString);
    max_value:=trim(ADOQuery2.fieldbyname('最大值').AsString);

    adotemp22:=Tadoquery.Create(nil);
    adotemp22.Connection:=dm.ADOConnection1;
    adotemp22.Close;
    adotemp22.SQL.Clear;
    adotemp22.SQL.Text:='select dbo.uf_ValueAlarm('''+ItemChnName+''','''+min_value+''','''+max_value+''','''+cur_value+''') as ifValueAlarm';
    try//uf_ValueAlarm中的convert函数可能抛出异常
      adotemp22.Open;
      i:=adotemp22.fieldbyname('ifValueAlarm').AsInteger;
    except
      i:=0;
    end;
    adotemp22.Free;

    if i=1 then
      tdbgrid(sender).Canvas.Font.Color:=clblue
    else if i=2 then
          tdbgrid(sender).Canvas.Font.Color:=clred;
    tdbgrid(sender).DefaultDrawColumnCell(rect,datacol,column,Grids.TGridDrawState(State));
  end;
  //==========================================================================//

  //用不同的颜色进行分组标识
  if (datacol=1)and(lsGroupShow.Count>1) then//起码有两个组才用颜色进行标识
  begin
    sGroup:=tdbgrid(sender).DataSource.DataSet.FieldByName('组合项目号').AsString;
    for  i:=0  to lsGroupShow.Count-1 do
    begin
      if sGroup=lsGroupShow[i] then
      begin
        case (i+1) mod 2 = 0  of
          true : tdbgrid(sender).Canvas.Brush.color:=$00AAD5D5;
          false: tdbgrid(sender).Canvas.Brush.color:=clInfoBk;//$00FFD9CE;
        end;
        if ((State = [gdSelected]) or (State=[gdSelected,gdFocused])) then
        begin
            tdbgrid(sender).Canvas.Brush.color:=clhighlight;
            tdbgrid(sender).Canvas.Font.Color:=clwindow;
        end;
        tdbgrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,Grids.TGridDrawState(State));
        break;
      end;
    end;
  end;
  //========================//}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  lsGroupShow:=tstringlist.Create;
  
  DateTimePicker1.Date:=Date;
  DateTimePicker2.Date:=Date;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
var
  strsqlPrint:string;
  sUnid,sCombin_Id:string;
  iIfCompleted:integer;

  i:integer;

  sPatientname,sSex,sAge:string;
  
  Save_Cursor:TCursor;
  OldCurrent:TBookmark;
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  if DBGrid1.SelectedRows.Count<=0 then exit;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  //Grid勾选记录判断方式二 begin
  //该方式无需循环全部数据集,只需循环所选记录
  OldCurrent:=DBGrid1.DataSource.DataSet.GetBookmark;
  DBGrid1.DataSource.DataSet.DisableControls;
  for i:=0 to DBGrid1.SelectedRows.Count-1 do
  begin
    DBGrid1.DataSource.DataSet.Bookmark:=DBGrid1.SelectedRows[i];

    sUnid:=DBGrid1.DataSource.DataSet.fieldbyname('唯一编号').AsString;
    sCombin_Id:=DBGrid1.DataSource.DataSet.FieldByName('工作组').AsString;
    iIfCompleted:=DBGrid1.DataSource.DataSet.FieldByName('ifCompleted').AsInteger;
    sPatientname:=trim(DBGrid1.DataSource.DataSet.fieldbyname('姓名').AsString);
    sSex:=DBGrid1.DataSource.DataSet.fieldbyname('性别').AsString;
    sAge:=DBGrid1.DataSource.DataSet.fieldbyname('年龄').AsString;

    //判断该就诊人员是否存在未审核结果START
    if strtoint(ScalarSQLCmd(LisConn,'select count(*) from chk_con where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+''') and isnull(report_doctor,'''')='''' '))>0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':就诊人员['+sPatientname+']存在未审核报告!');
      WriteLog(pchar('就诊人员['+sPatientname+']存在未审核报告!'));
    end;
    //================================STOP

    if (sCombin_Id=WorkGroup_T1)
      and frReport1.LoadFromFile(TempFile_T1) then//加载模板文件是不区分大小写的.空字符串将加载失败
    begin
    end else
    if (sCombin_Id=WorkGroup_T2)
      and frReport1.LoadFromFile(TempFile_T2) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T3)
      and frReport1.LoadFromFile(TempFile_T3) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T4)
      and frReport1.LoadFromFile(TempFile_T4) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T5)
      and frReport1.LoadFromFile(TempFile_T5) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T6)
      and frReport1.LoadFromFile(TempFile_T6) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T7)
      and frReport1.LoadFromFile(TempFile_T7) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T8)
      and frReport1.LoadFromFile(TempFile_T8) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T9)
      and frReport1.LoadFromFile(TempFile_T9) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T10)
      and frReport1.LoadFromFile(TempFile_T10) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T11)
      and frReport1.LoadFromFile(TempFile_T11) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T12)
      and frReport1.LoadFromFile(TempFile_T12) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T13)
      and frReport1.LoadFromFile(TempFile_T13) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T14)
      and frReport1.LoadFromFile(TempFile_T14) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T15)
      and frReport1.LoadFromFile(TempFile_T15) then
    begin
    end else
    if not frReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_cur.frf') then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']加载默认通用打印模板report_cur.frf失败，请设置:选项->打印模板');
      WriteLog(pchar('['+sPatientname+']加载默认通用打印模板report_cur.frf失败，请设置:选项->打印模板'));
      
      continue;
    end;

    strsqlPrint:='select itemid as 项目代码,name as 名称,english_name as 英文名,'+
            ' itemvalue as 检验结果,'+
            ' min_value as 最小值,max_value as 最大值,'+
            ' dbo.uf_Reference_Value_B1(min_value,max_value) as 前段参考范围,dbo.uf_Reference_Value_B2(min_value,max_value) as 后段参考范围,'+
            ' unit as 单位,'+
            ' min(printorder) as 打印编号,'+
            ' min(pkcombin_id) as 组合项目号, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' from '+
            ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
            ' WITH(NOLOCK) where pkunid='+sUnid+
            ' and issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
            ' group by itemid,name,english_name,itemvalue,min_value,max_value,unit, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' order by 组合项目号,打印编号 ';
    ado_print.Close;
    ado_print.SQL.Clear;
    ado_print.SQL.Text:=strsqlPrint;
    ado_print.Open;
    if ADO_print.RecordCount=0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']无效结果!');
      WriteLog(pchar('['+sPatientname+']无效结果!'));
      
      continue;
    end;

    if RadioGroup2.ItemIndex=0 then  //预览模式
      frReport1.ShowReport
    else  //直接打印模式
    begin
      if frReport1.PrepareReport then frReport1.PrintPreparedReport('', 1, True, frAll);
    end;    
  end;
  DBGrid1.DataSource.DataSet.GotoBookmark(OldCurrent);
  DBGrid1.DataSource.DataSet.EnableControls;
  //Grid勾选记录判断方式二 end}

  Screen.Cursor := Save_Cursor;  { Always restore to normal }
  
  MessageDlg('打印操作完成！',mtInformation,[mbOK],0);
end;

procedure TfrmMain.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
var
  ItemChnName:string;
  cur_value:string;
  min_value:string;
  max_value:string;
  i:integer;
  adotemp22:Tadoquery;
begin
    if parname='SCSYDW' then ParValue:=SCSYDW;

    if parname='CXZF' then
    BEGIN
      ItemChnName:=trim(ADO_print.fieldbyname('项目代码').AsString);
      cur_value:=trim(ADO_print.fieldbyname('检验结果').AsString);
      min_value:=trim(ADO_print.fieldbyname('最小值').AsString);
      max_value:=trim(ADO_print.fieldbyname('最大值').AsString);

      adotemp22:=Tadoquery.Create(nil);
      adotemp22.Connection:=dm.ADOConnection1;
      adotemp22.Close;
      adotemp22.SQL.Clear;
      adotemp22.SQL.Text:='select dbo.uf_ValueAlarm('''+ItemChnName+''','''+min_value+''','''+max_value+''','''+cur_value+''') as ifValueAlarm';
      try//uf_ValueAlarm中的convert函数可能抛出异常
        adotemp22.Open;
        i:=adotemp22.fieldbyname('ifValueAlarm').AsInteger;
      except
        i:=0;
      end;
      adotemp22.Free;
      if i=1 then
        ParValue := '↓'
      else if i=2 then
        ParValue := '↑'
      else ParValue:='';
    END;

    if parname='打印者' then ParValue:=operator_name;
    if parname='所属公司' then ParValue:=trim(ADObasic.fieldbyname('所属公司').AsString);
    if parname='姓名' then ParValue:=trim(ADObasic.fieldbyname('姓名').AsString);
    if parname='性别' then ParValue:=trim(ADObasic.fieldbyname('性别').AsString);
    if parname='体检日期' then ParValue:=ADObasic.fieldbyname('检查日期').AsDateTime;
    if parname='年龄' then ParValue:=trim(ADObasic.fieldbyname('年龄').AsString);
    if parname='婚否' then ParValue:=trim(ADObasic.fieldbyname('婚否').AsString);
    if parname='工种' then ParValue:=trim(ADObasic.fieldbyname('工种').AsString);
    if parname='籍贯' then ParValue:=trim(ADObasic.fieldbyname('籍贯').AsString);
    if parname='住址' then ParValue:=trim(ADObasic.fieldbyname('住址').AsString);
    if parname='电话' then ParValue:=trim(ADObasic.fieldbyname('电话').AsString);

    if parname='检验设备' then ParValue:=ScalarSQLCmd(LisConn,'select dbo.uf_GetEquipFromChkUnid('+ADObasic.fieldbyname('ifCompleted').AsString+','+ADObasic.fieldbyname('唯一编号').AsString+')');
end;

procedure TfrmMain.frReport1BeforePrint(Memo: TStringList; View: TfrView);
var
  adotemp11:tadoquery;
  unid,iIfCompleted:integer;
  
  strsqlPrint,strEnglishName,strHistogram,strXTitle:string;
  MS:tmemorystream;
  tempjpeg:TJPEGImage;
  Chart_ZFT:TChart;

  //血流变变量start
  Reserve8_1,Reserve8_2:single;//切变率
  mPa_1,mPa_2:string;//粘度
  mPa_min_1,mPa_min_2:string;//粘度
  mPa_max_1,mPa_max_2:string;//粘度
  Chart_XLB:TChart;
  //血流变变量stop
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('唯一编号').AsInteger;
  iIfCompleted:=ADObasic.FieldByName('ifCompleted').AsInteger;

  //加载血流变曲线、直方图、散点图 start
  if(View is TfrChartView)and(pos('CURVE',uppercase(View.Name))>0)then
  begin
    View.Visible:=false;
    strsqlPrint:='select Reserve8,itemValue,Min_Value,Max_Value '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       ' and Reserve8 is not null '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    adotemp11.Open;
    if adotemp11.RecordCount=2 then
    begin
      View.Visible:=true;

      Chart_XLB:=TChart.Create(nil);
      Chart_XLB.Visible:=false;
      
      Reserve8_1:=adotemp11.fieldbyname('Reserve8').AsFloat;//切变率
      mPa_1:=adotemp11.fieldbyname('itemValue').AsString;//粘度
      mPa_min_1:=adotemp11.fieldbyname('Min_Value').AsString;//粘度
      mPa_max_1:=adotemp11.fieldbyname('Max_Value').AsString;//粘度
      adotemp11.Next;
      Reserve8_2:=adotemp11.fieldbyname('Reserve8').AsFloat;//切变率
      mPa_2:=adotemp11.fieldbyname('itemValue').AsString;//粘度
      mPa_min_2:=adotemp11.fieldbyname('Min_Value').AsString;//粘度
      mPa_max_2:=adotemp11.fieldbyname('Max_Value').AsString;//粘度
      Draw_MVIS2035_Curve(Chart_XLB,Reserve8_1,strtofloatdef(mPa_1,-1),Reserve8_2,strtofloatdef(mPa_2,-1),
                          Reserve8_1,strtofloatdef(mPa_min_1,-1),Reserve8_2,strtofloatdef(mPa_min_2,-1),
                          Reserve8_1,strtofloatdef(mPa_max_1,-1),Reserve8_2,strtofloatdef(mPa_max_2,-1));
      TfrChartView(View).Assignchart(Chart_XLB);//指定统计图給FastReport

      Chart_XLB.Free;
    end;
    adotemp11.Free;
  end;
    
  if(View is TfrChartView)and(pos('CHART',uppercase(View.Name))>0)then
  begin
    View.Visible:=false;
    strEnglishName:=(View as TfrChartView).Name;
    strEnglishName:=stringreplace(strEnglishName,'Chart','',[rfIgnoreCase]);
    strsqlPrint:='select top 1 histogram,Dosage1 '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       ' and english_name=:english_name '+
       ' and isnull(histogram,'''')<>'''' '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    adotemp11.Parameters.ParamByName('english_name').Value:=strEnglishName;
    adotemp11.Open;
    strHistogram:=trim(adotemp11.fieldbyname('histogram').AsString);
    strXTitle:=adotemp11.fieldbyname('Dosage1').AsString;
    adotemp11.Free;
    if strHistogram<>'' then
    begin
      View.Visible:=true;

      Chart_ZFT:=TChart.Create(nil);
      Chart_ZFT.Visible:=false;

      updatechart(Chart_ZFT,strHistogram,strEnglishName,strXTitle);
      TfrChartView(View).Assignchart(Chart_ZFT);//指定统计图給FastReport

      Chart_ZFT.Free;
    end;
  end;

  if(View is TfrPictureView)and(pos('PICTURE',uppercase(View.Name))>0)then
  begin
    View.Visible:=false;
    strEnglishName:=(View as TfrPictureView).Name;
    strEnglishName:=stringreplace(strEnglishName,'Picture','',[rfIgnoreCase]);
    strsqlPrint:='select top 1 Photo '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       //' and english_name=:english_name '+
       ' and itemid=:itemid '+//edit by liuying 20110414
       ' and Photo is not null '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    //adotemp11.Parameters.ParamByName('english_name').Value:=strEnglishName;
    adotemp11.Parameters.ParamByName('itemid').Value:=strEnglishName;//edit by liuying 20110414
    adotemp11.Open;
    if not adotemp11.fieldbyname('photo').IsNull then
    begin
      View.Visible:=true;
      MS:=TMemoryStream.Create;
      TBlobField(adotemp11.fieldbyname('photo')).SaveToStream(MS);
      MS.Position:=0;
      tempjpeg:=TJPEGImage.Create;
      tempjpeg.LoadFromStream(MS);
      MS.Free;
      TfrPictureView(View).Picture.assign(tempjpeg);
      tempjpeg.Free;
    end;
    adotemp11.Free;
  end;
  //加载血流变曲线、直方图、散点图 stop
end;

procedure TfrmMain.frReport1PrintReport;
var
  unid,printtimes,iIfCompleted:integer;
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('唯一编号').AsInteger;
  printtimes:=ADObasic.fieldbyname('打印次数').AsInteger;
  iIfCompleted:=ADObasic.FieldByName('ifCompleted').AsInteger;

  if printtimes=0 then//修改打印次数
    ExecSQLCmd(LisConn,'update '+ifThen(iIfCompleted=1,'chk_con_bak','chk_con')+' set printtimes='+inttostr(printtimes+1)+' where unid='+inttostr(unid));
  
  ExecSQLCmd(LisConn,'insert into pix_tran (pkunid,Reserve1,Reserve2,OpType) values ('+inttostr(unid)+','''+operator_name+''',''Class_Print'',''Nurse'')');
end;

procedure TfrmMain.Draw_MVIS2035_Curve(Chart_XLB: TChart; const X1, Y1, X2,
  Y2, X1_MIN, Y1_MIN, X2_MIN, Y2_MIN, X1_MAX, Y1_MAX, X2_MAX,
  Y2_MAX: Real);
//要利用Chart生成图片,故该函数不能写在DLL中                                    
VAR
  Y:Array[1..200] of real;
  Y_MIN:Array[1..200] of real;
  Y_MAX:Array[1..200] of real;
  A,B:real;
  A_MIN,B_MIN:real;
  A_MAX,B_MAX:real;
  i:integer;
  rMin,rMax:real;
  Series_Val,Series_Min,Series_Max:TFastLineSeries;
BEGIN
  if not CassonEquation(X1,Y1,X2,Y2,A,B) then exit;
  if not CassonEquation(X1_MIN,Y1_MIN,X2_MIN,Y2_MIN,A_MIN,B_MIN) then exit;
  if not CassonEquation(X1_MAX,Y1_MAX,X2_MAX,Y2_MAX,A_MAX,B_MAX) then exit;

  Chart_XLB.Width:=600;
  Chart_XLB.Height:=250;
  Chart_XLB.View3D:=false;
  Chart_XLB.Legend.Visible:=false;
  Chart_XLB.Color:=clWhite;
  Chart_XLB.BevelOuter:=bvNone;
  Chart_XLB.BottomAxis.Axis.Width:=1;
  Chart_XLB.LeftAxis.Axis.Width:=1;
  Chart_XLB.BackWall.Pen.Visible:=false;//隐藏top、right的框
  Chart_XLB.BottomAxis.Grid.Visible:=false;//隐藏横向的GRID线
  Chart_XLB.LeftAxis.Grid.Visible:=false;//隐藏纵向的GRID线
  Chart_XLB.Title.Font.Color:=clBlack;//默认是clBlue
  Chart_XLB.Title.Text.Clear;
  Chart_XLB.Title.Text.Add('血液粘度特性曲线');
  Chart_XLB.BottomAxis.Title.Caption:='切变率(1/s)';
  Chart_XLB.LeftAxis.Title.Caption:='粘度(mPa.s)';
  //for k:=Chart2.SeriesCount-1 downto 0 do Chart2.Series[k].Clear;//动态创建的Chart,肯定没Serie

  Series_Val:=TFastLineSeries.Create(Chart_XLB);
  Series_Val.ParentChart :=Chart_XLB;
  Series_Val.SeriesColor:=clBlack;//设置曲线颜色
  Chart_XLB.AddSeries(Series_Val);

  Series_Min:=TFastLineSeries.Create(Chart_XLB);
  Series_Min.ParentChart :=Chart_XLB;
  Series_Min.SeriesColor:=clBtnFace;//设置曲线颜色
  Series_Min.LinePen.Style:=psDashDotDot;
  Chart_XLB.AddSeries(Series_Min);

  Series_Max:=TFastLineSeries.Create(Chart_XLB);
  Series_Max.ParentChart :=Chart_XLB;
  Series_Max.SeriesColor:=clBtnFace;//设置曲线颜色
  Series_Max.LinePen.Style:=psDashDotDot;
  Chart_XLB.AddSeries(Series_Max);

  rMin:=0;rMax:=0;
  for i :=1 to 200 do
  begin
    Y[i]:=POWER(A+B*sqrt(1/I),2);
    Y_MIN[i]:=POWER(A_MIN+B_MIN*sqrt(1/I),2);
    Y_MAX[i]:=POWER(A_MAX+B_MAX*sqrt(1/I),2);

    Series_Val.Add(Y[i]);
    Series_Min.Add(Y_min[i]);
    Series_Max.Add(Y_max[i]);

    if i=1 then begin rMin:=Y[i];rMax:=Y[i];end;
    if Y[i]<rMin then rMin:=Y[i];
    if Y[i]>rMax then rMax:=Y[i];
  end;

  Chart_XLB.LeftAxis.Automatic:=false;
  Chart_XLB.LeftAxis.Maximum:=MaxInt;//如果不加这句,下句有可能报错(最小值必须=<最大值)
  Chart_XLB.LeftAxis.Minimum:=rMin-10*(rMax-rMin)/100;//下面留10%的空
  Chart_XLB.LeftAxis.Maximum:=rMax-10*(rMax-rMin)/100;//上面减少10%,这样图形才机子打出来的差不多
END;

procedure TfrmMain.updatechart(ChartHistogram: TChart; const strHistogram,
  strEnglishName, strXTitle: string);
var
    i,k:integer;
    sList:tstrings;
    fMin,fMax:single;
    Series_Val:TFastLineSeries;
begin
    ChartHistogram.Width:=194;
    ChartHistogram.Height:=90;
    ChartHistogram.View3D:=false;
    ChartHistogram.Legend.Visible:=false;
    ChartHistogram.Color:=clWhite;
    ChartHistogram.BevelOuter:=bvNone;//如不设置该属性,则打印时底部、右边各有一条灰色线
    ChartHistogram.BackWall.Pen.Visible:=false;//隐藏top、right的框
    ChartHistogram.BottomAxis.Axis.Width:=1;
    ChartHistogram.LeftAxis.Axis.Width:=1;
    ChartHistogram.BottomAxis.Grid.Visible:=false;//隐藏横向的GRID线
    ChartHistogram.LeftAxis.Grid.Visible:=false;//隐藏纵向的GRID线
    ChartHistogram.BottomAxis.Labels:=false;//隐藏X轴的刻度
    ChartHistogram.LeftAxis.Labels:=false;//隐藏Y轴的刻度
    ChartHistogram.Title.Font.Color:=clBlack;//默认是clBlue
    ChartHistogram.Title.Text.Clear;
    for k:=ChartHistogram.SeriesCount-1 downto 0 do ChartHistogram.Series[k].Clear;
    sList:=TStringList.Create;
    if SmoothLine(strHistogram,SmoothNum,sList,fMin,fMax)=0 then
    begin
      ChartHistogram.AxisVisible:=false;//轴上的Title也随之隐藏
      sList.Free;
      exit;
    end;

    ChartHistogram.Title.Text.Text:=strEnglishName;
    ChartHistogram.BottomAxis.Title.Caption:=strXTitle;
    ChartHistogram.LeftAxis.Automatic:=false;
    ChartHistogram.LeftAxis.Maximum:=MaxInt;//如果不加这句,下句有可能报错(最小值必须=<最大值)
    ChartHistogram.LeftAxis.Minimum:=fMin-5*(fMax-fMin)/100;//上面和下面分别留5%的空
    ChartHistogram.LeftAxis.Maximum:=fMax+5*(fMax-fMin)/100;

    Series_Val:=TFastLineSeries.Create(ChartHistogram);
    Series_Val.ParentChart :=ChartHistogram;
    Series_Val.SeriesColor:=clBlack;//设置曲线颜色
    ChartHistogram.AddSeries(Series_Val);

    for i:=0 to sList.Count-1 do
    begin
      Series_Val.Add(strtofloat(sList[i]));
    end;
    sList.Free;
end;

procedure TfrmMain.SpeedButton6Click(Sender: TObject);
var
  strsqlPrint:string;

  sUnid,sCombin_Id,sReport_Doctor:string;

  i,iIfCompleted:integer;

  sPatientname,sSex,sAge:string;

  Save_Cursor:TCursor;
  OldCurrent:TBookmark;
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  if DBGrid1.SelectedRows.Count<=0 then exit;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  //Grid勾选记录判断方式二 begin
  //该方式无需循环全部数据集,只需循环所选记录
  OldCurrent:=DBGrid1.DataSource.DataSet.GetBookmark;
  DBGrid1.DataSource.DataSet.DisableControls;
  for i:=0 to DBGrid1.SelectedRows.Count-1 do
  begin
    DBGrid1.DataSource.DataSet.Bookmark:=DBGrid1.SelectedRows[i];

    sUnid:=DBGrid1.DataSource.DataSet.fieldbyname('唯一编号').AsString;
    sCombin_Id:=DBGrid1.DataSource.DataSet.FieldByName('工作组').AsString;
    sReport_Doctor:=trim(DBGrid1.DataSource.DataSet.FieldByName('审核者').AsString);
    iIfCompleted:=DBGrid1.DataSource.DataSet.FieldByName('ifCompleted').AsInteger;
    sPatientname:=trim(DBGrid1.DataSource.DataSet.fieldbyname('姓名').AsString);
    sSex:=DBGrid1.DataSource.DataSet.fieldbyname('性别').AsString;
    sAge:=DBGrid1.DataSource.DataSet.fieldbyname('年龄').AsString;

    //判断该就诊人员是否存在未审核结果START
    if strtoint(ScalarSQLCmd(LisConn,'select count(*) from chk_con where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+''') and isnull(report_doctor,'''')='''' '))>0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':就诊人员['+sPatientname+']存在未审核报告!');
      WriteLog(pchar('就诊人员['+sPatientname+']存在未审核报告!'));
    end;
    //================================STOP

    if (sCombin_Id=GP_WorkGroup_T1)
      and frReport1.LoadFromFile(GP_TempFile_T1) then//加载模板文件是不区分大小写的.空字符串将加载失败
    begin
    end else
    if (sCombin_Id=GP_WorkGroup_T2)
      and frReport1.LoadFromFile(GP_TempFile_T2) then
    begin
    end else
    if (sCombin_Id=GP_WorkGroup_T3)
      and frReport1.LoadFromFile(GP_TempFile_T3) then
    begin
    end else
    if not frReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_Cur_group.frf') then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']加载默认分组打印模板report_Cur_group.frf失败，请设置:选项->打印模板');
      WriteLog(pchar('['+sPatientname+']加载默认分组打印模板report_Cur_group.frf失败，请设置:选项->打印模板'));
      
      continue;
    end;

    strsqlPrint:='select cv.combin_name as name,cv.name as 名称,cv.english_name as 英文名,cv.itemvalue as 检验结果,'+
      'cv.unit as 单位,cv.min_value as 最小值,cv.max_value as 最大值,'+
      ' dbo.uf_Reference_Value_B1(cv.min_value,cv.max_value) as 前段参考范围,dbo.uf_Reference_Value_B2(cv.min_value,cv.max_value) as 后段参考范围,'+
      ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10, '+
      ' cv.itemid as 项目代码 '+//cci.Reserve3,
      ' from '+
      ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
      ' cv WITH(NOLOCK) '+
      ' left join clinicchkitem cci on cci.itemid=cv.itemid '+
      ' where cv.pkunid='+sUnid+
      ' and cv.issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
      ' order by cv.pkcombin_id,cv.printorder ';//组合项目号,打印编号 '
    ADO_print.Close;
    ADO_print.SQL.Clear;
    ADO_print.SQL.Text:=strsqlPrint;
    ADO_print.Open;
    if ADO_print.RecordCount=0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']无效结果!');
      WriteLog(pchar('['+sPatientname+']无效结果!'));
      
      continue;
    end;

    if RadioGroup2.ItemIndex=0 then  //预览模式
      frReport1.ShowReport
    else  //直接打印模式
    begin
      if frReport1.PrepareReport then frReport1.PrintPreparedReport('', 1, True, frAll);
    end;
  end;
  DBGrid1.DataSource.DataSet.GotoBookmark(OldCurrent);
  DBGrid1.DataSource.DataSet.EnableControls;
  //Grid勾选记录判断方式二 end}

  Screen.Cursor := Save_Cursor;  { Always restore to normal }

  MessageDlg('打印操作完成！',mtInformation,[mbOK],0);
end;

procedure TfrmMain.SpeedButton2Click(Sender: TObject);
begin
  frmLogin.ShowModal;
end;

procedure TfrmMain.ShowPictureValue(const ACheckUnid,AifCompleted: integer);
var
  adotemp3:tadoquery;
  i,n,m,k:integer;
  GroupBox:array of TGroupBox;
  Chart:array of TChart;
  MS:tmemorystream;

  //血流变变量start
  Reserve8_1,Reserve8_2:single;//切变率
  mPa_1,mPa_2:string;//粘度
  mPa_min_1,mPa_min_2:string;//粘度
  mPa_max_1,mPa_max_2:string;//粘度
begin
  for i :=ScrollBoxPicture.ControlCount-1 downto 0 do
  begin
    if ScrollBoxPicture.Controls[i] is TGroupBox then ScrollBoxPicture.Controls[i].Free;
  end;

  adotemp3:=tadoquery.Create(nil);
  adotemp3.Connection:=DM.ADOConnection1;
  adotemp3.Close;
  adotemp3.SQL.Clear;
  adotemp3.SQL.Text:=
    'select * from ( '+
      'select ''绘点''   as PictureType,* from '+ifThen(AifCompleted=1,'chk_valu_bak','chk_valu')+' WITH(NOLOCK) where pkunid='+inttostr(ACheckUnid)+' and isnull(histogram,'''')<>'''' and issure=''1'' '+
      'union all '+
      'select ''图片''   as PictureType,* from '+ifThen(AifCompleted=1,'chk_valu_bak','chk_valu')+' WITH(NOLOCK) where pkunid='+inttostr(ACheckUnid)+' and Photo is not null and issure=''1'' '+
      'union all '+
      'select ''血流变'' as PictureType,* from '+ifThen(AifCompleted=1,'chk_valu_bak','chk_valu')+' WITH(NOLOCK) where pkunid='+inttostr(ACheckUnid)+' and Reserve8 is not null and issure=''1'' '+
    ' ) TempTable order by pkcombin_id,printorder ';
  adotemp3.Open;
  setlength(GroupBox,adotemp3.RecordCount);
  setlength(Chart,adotemp3.RecordCount);
  n:=0;m:=0;k:=-1;Reserve8_1:=-1;Reserve8_2:=-1;
  while not adotemp3.Eof do
  begin
    GroupBox[n]:=TGroupBox.Create(self);
    GroupBox[n].Parent:=ScrollBoxPicture;
    GroupBox[n].Left:=maxint;//使各个Panel按创建顺序排列
    GroupBox[n].Align:=alLeft;
    GroupBox[n].Width:=ScrollBoxPicture.Height;
    GroupBox[n].Caption:=adotemp3.FieldByName('name').AsString;
    GroupBox[n].Tag:=adotemp3.FieldByName('valueid').AsInteger;

    if adotemp3.FieldByName('PictureType').AsString='绘点' then
    begin
      Chart[n]:=TChart.Create(GroupBox[n]);//GroupBox负责释放Chart
      Chart[n].Parent:=GroupBox[n];
      Chart[n].Align:=alClient;
      updatechart(Chart[n],trim(adotemp3.FieldByName('histogram').AsString),adotemp3.FieldByName('english_name').AsString,adotemp3.FieldByName('Dosage1').AsString);
    end;

    if adotemp3.FieldByName('PictureType').AsString='图片' then
    begin
      if tblobfield(adotemp3.FieldByName('photo')).BlobSize <=0 then begin inc(n);adotemp3.Next;continue;end;
      
      MS:=TMemoryStream.Create;
      TBlobField(adotemp3.fieldbyname('photo')).SaveToStream(MS);
      MS.Position:=0;
      with TImage.Create(GroupBox[n]) do//GroupBox负责释放Image
      begin
        Parent:=GroupBox[n];
        Align:=alClient;
        Stretch:=true;
        Picture.Graphic:=nil;
        Picture.Graphic:=TJpegImage.Create;
        Picture.Graphic.LoadFromStream(MS);
      end;
      MS.Free;
    end;

    if adotemp3.FieldByName('PictureType').AsString='血流变' then
    begin
      inc(m);
      
      if m=1 then
      begin
        Reserve8_1:=adotemp3.fieldbyname('Reserve8').AsFloat;//切变率
        mPa_1:=adotemp3.fieldbyname('itemValue').AsString;//粘度
        mPa_min_1:=adotemp3.fieldbyname('Min_Value').AsString;//粘度
        mPa_max_1:=adotemp3.fieldbyname('Max_Value').AsString;//粘度
      end;
      
      if m=2 then
      begin
        Reserve8_2:=adotemp3.fieldbyname('Reserve8').AsFloat;//切变率
        mPa_2:=adotemp3.fieldbyname('itemValue').AsString;//粘度
        mPa_min_2:=adotemp3.fieldbyname('Min_Value').AsString;//粘度
        mPa_max_2:=adotemp3.fieldbyname('Max_Value').AsString;//粘度
        k:=n;
      end;
    end;

    inc(n);
    adotemp3.Next
  end;
  adotemp3.Free;

  if m=2 then//血流变
  begin
    Chart[k]:=TChart.Create(GroupBox[k]);//GroupBox负责释放Chart
    Chart[k].Parent:=GroupBox[k];
    Chart[k].Align:=alClient;
    Draw_MVIS2035_Curve(Chart[k],Reserve8_1,strtofloatdef(mPa_1,-1),Reserve8_2,strtofloatdef(mPa_2,-1),
                        Reserve8_1,strtofloatdef(mPa_min_1,-1),Reserve8_2,strtofloatdef(mPa_min_2,-1),
                        Reserve8_1,strtofloatdef(mPa_max_1,-1),Reserve8_2,strtofloatdef(mPa_max_2,-1));
  end;
end;

procedure TfrmMain.RadioGroup1Click(Sender: TObject);
begin
  if (Sender as TRadioGroup).ItemIndex=1 then
  begin
    DateTimePicker1.Date:=Date-7;
    DateTimePicker2.Date:=Date;
  end
  else if (Sender as TRadioGroup).ItemIndex=2 then
  begin
    DateTimePicker1.Date:=Date-30;
    DateTimePicker2.Date:=Date;
  end
  else begin
    DateTimePicker1.Date:=Date;
    DateTimePicker2.Date:=Date;
  end;  
end;

procedure TfrmMain.SpeedButton8Click(Sender: TObject);
begin
  frmModifyPwd.ShowModal;
end;

procedure TfrmMain.DBGrid1TitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
begin
  //因为排序时原有的勾选会产生紊乱,故点击排序按钮时索性清除掉所有勾选
  //另注意,点击排序按钮后会调用ADOQuery1AfterOpen事件
  DBGrid1.SelectedRows.Clear;
end;

procedure TfrmMain.DBGrid1SelectionChanged(Sender: TObject);
begin
  UpdateStatusBar(#$2+'0:'+IntToStr(DBGrid1.SelectedRows.Count));
end;

procedure TfrmMain.SpeedButton3Click(Sender: TObject);
var
  strsqlPrint:string;
  sUnid,sCombin_Id:string;
  iIfCompleted:integer;

  i:integer;

  sPatientname,sSex,sAge,sCheck_Date:string;
  
  Save_Cursor:TCursor;
  OldCurrent:TBookmark;
  PDFExportPath:String;

  frxMasterData:TfrxMasterData;  
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  if DBGrid1.SelectedRows.Count<=0 then exit;

  if RadioGroup2.ItemIndex=2 then
    if not SelectDirectory('请选择PDF导出目录','',PDFExportPath) then exit;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  //Grid勾选记录判断方式二 begin
  //该方式无需循环全部数据集,只需循环所选记录
  OldCurrent:=DBGrid1.DataSource.DataSet.GetBookmark;
  DBGrid1.DataSource.DataSet.DisableControls;
  for i:=0 to DBGrid1.SelectedRows.Count-1 do
  begin
    DBGrid1.DataSource.DataSet.Bookmark:=DBGrid1.SelectedRows[i];

    sUnid:=DBGrid1.DataSource.DataSet.fieldbyname('唯一编号').AsString;
    sCombin_Id:=DBGrid1.DataSource.DataSet.FieldByName('工作组').AsString;
    iIfCompleted:=DBGrid1.DataSource.DataSet.FieldByName('ifCompleted').AsInteger;
    sPatientname:=trim(DBGrid1.DataSource.DataSet.fieldbyname('姓名').AsString);
    sSex:=DBGrid1.DataSource.DataSet.fieldbyname('性别').AsString;
    sAge:=DBGrid1.DataSource.DataSet.fieldbyname('年龄').AsString;
    sCheck_Date:=FormatDateTime('yyyymmdd',DBGrid1.DataSource.DataSet.fieldbyname('检查日期').AsDateTime);

    //判断该就诊人员是否存在未审核结果START
    if strtoint(ScalarSQLCmd(LisConn,'select count(*) from chk_con where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+''') and isnull(report_doctor,'''')='''' '))>0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':就诊人员['+sPatientname+']存在未审核报告!');
      WriteLog(pchar('就诊人员['+sPatientname+']存在未审核报告!'));
    end;
    //================================STOP

    frxReport1.Clear;//清除报表模板
    frxDBDataSet1.UserName:='ADObasic';//加载模板文件前设置别名.因为一般设计模板文件时已经包含了别名信息
    frxDBDataSet2.UserName:='ADO_print';//加载模板文件前设置别名.因为一般设计模板文件时已经包含了别名信息

    if (sCombin_Id=WorkGroup_T1)
      and frxReport1.LoadFromFile(TempFile_T1) then//加载模板文件是不区分大小写的.空字符串将加载失败
    begin
    end else
    if (sCombin_Id=WorkGroup_T2)
      and frxReport1.LoadFromFile(TempFile_T2) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T3)
      and frxReport1.LoadFromFile(TempFile_T3) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T4)
      and frxReport1.LoadFromFile(TempFile_T4) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T5)
      and frxReport1.LoadFromFile(TempFile_T5) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T6)
      and frxReport1.LoadFromFile(TempFile_T6) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T7)
      and frxReport1.LoadFromFile(TempFile_T7) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T8)
      and frxReport1.LoadFromFile(TempFile_T8) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T9)
      and frxReport1.LoadFromFile(TempFile_T9) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T10)
      and frxReport1.LoadFromFile(TempFile_T10) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T11)
      and frxReport1.LoadFromFile(TempFile_T11) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T12)
      and frxReport1.LoadFromFile(TempFile_T12) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T13)
      and frxReport1.LoadFromFile(TempFile_T13) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T14)
      and frxReport1.LoadFromFile(TempFile_T14) then
    begin
    end else
    if (sCombin_Id=WorkGroup_T15)
      and frxReport1.LoadFromFile(TempFile_T15) then
    begin
    end else
    if not frxReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_cur.fr3') then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']加载默认通用打印模板report_cur.fr3失败，请设置:选项->打印模板');
      WriteLog(pchar('['+sPatientname+']加载默认通用打印模板report_cur.fr3失败，请设置:选项->打印模板'));
      
      continue;
    end;

    strsqlPrint:='select itemid as 项目代码,name as 名称,english_name as 英文名,'+
            ' itemvalue as 检验结果,'+
            ' min_value as 最小值,max_value as 最大值,'+
            ' dbo.uf_Reference_Value_B1(min_value,max_value) as 前段参考范围,dbo.uf_Reference_Value_B2(min_value,max_value) as 后段参考范围,'+
            ' unit as 单位,'+
            ' min(printorder) as 打印编号,'+
            ' min(pkcombin_id) as 组合项目号, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' from '+
            ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
            ' WITH(NOLOCK) where pkunid='+sUnid+
            ' and issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
            ' group by itemid,name,english_name,itemvalue,min_value,max_value,unit, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' order by 组合项目号,打印编号 ';
    ado_print.Close;
    ado_print.SQL.Clear;
    ado_print.SQL.Text:=strsqlPrint;
    ado_print.Open;
    if ADO_print.RecordCount=0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']无效结果!');
      WriteLog(pchar('['+sPatientname+']无效结果!'));
      
      continue;
    end;

    frxDBDataSet1.DataSet:=ADObasic;//关联Fastreport的组件与TDataset数据集
    frxDBDataSet2.DataSet:=ADO_print;//关联Fastreport的组件与TDataset数据集
    frxReport1.DataSets.Clear;//清除原来的数据集
    frxReport1.DataSets.Add(frxDBDataSet1);//加载关联好的TfrxDBDataSet到报表中
    frxReport1.DataSets.Add(frxDBDataSet2);//加载关联好的TfrxDBDataSet到报表中
  
    frxMasterData:=frxReport1.FindObject('MasterData1') as TfrxMasterData;
    if (frxMasterData<>nil) and (frxMasterData is TfrxMasterData) then frxMasterData.DataSet:=frxDBDataSet2;//动态配置MasterData.DataSet
      
    if RadioGroup2.ItemIndex=2 then//导出PDF
    begin
      frxReport1.PrepareReport;
      frxPDFExport1.ShowDialog:=False;
      frxPDFExport1.DefaultPath:=PDFExportPath;
      frxPDFExport1.FileName:=sPatientname+'&'+sCheck_Date+'-'+sUnid+'.pdf';
      frxReport1.Export(frxPDFExport1);
    end else
    if RadioGroup2.ItemIndex=0 then  //预览模式
      begin frxReport1.PrintOptions.ShowDialog:=ifShowPrintDialog;frxReport1.ShowReport; end
    else  //直接打印模式
    begin
      if frxReport1.PrepareReport then begin frxReport1.PrintOptions.ShowDialog:=false;frxReport1.Print;end;
    end;    
  end;
  DBGrid1.DataSource.DataSet.GotoBookmark(OldCurrent);
  DBGrid1.DataSource.DataSet.EnableControls;
  //Grid勾选记录判断方式二 end}

  Screen.Cursor := Save_Cursor;  { Always restore to normal }
  
  if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
  memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':打印操作完成！');
end;

procedure TfrmMain.SpeedButton9Click(Sender: TObject);
var
  strsqlPrint:string;

  sUnid,sCombin_Id,sReport_Doctor:string;

  i,iIfCompleted:integer;

  sPatientname,sSex,sAge,sCheck_Date:string;

  Save_Cursor:TCursor;
  OldCurrent:TBookmark;
  PDFExportPath:String;

  frxMasterData:TfrxMasterData;  
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  if DBGrid1.SelectedRows.Count<=0 then exit;

  if RadioGroup2.ItemIndex=2 then
    if not SelectDirectory('请选择PDF导出目录','',PDFExportPath) then exit;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  //Grid勾选记录判断方式二 begin
  //该方式无需循环全部数据集,只需循环所选记录
  OldCurrent:=DBGrid1.DataSource.DataSet.GetBookmark;
  DBGrid1.DataSource.DataSet.DisableControls;
  for i:=0 to DBGrid1.SelectedRows.Count-1 do
  begin
    DBGrid1.DataSource.DataSet.Bookmark:=DBGrid1.SelectedRows[i];

    sUnid:=DBGrid1.DataSource.DataSet.fieldbyname('唯一编号').AsString;
    sCombin_Id:=DBGrid1.DataSource.DataSet.FieldByName('工作组').AsString;
    sReport_Doctor:=trim(DBGrid1.DataSource.DataSet.FieldByName('审核者').AsString);
    iIfCompleted:=DBGrid1.DataSource.DataSet.FieldByName('ifCompleted').AsInteger;
    sPatientname:=trim(DBGrid1.DataSource.DataSet.fieldbyname('姓名').AsString);
    sSex:=DBGrid1.DataSource.DataSet.fieldbyname('性别').AsString;
    sAge:=DBGrid1.DataSource.DataSet.fieldbyname('年龄').AsString;
    sCheck_Date:=FormatDateTime('yyyymmdd',DBGrid1.DataSource.DataSet.fieldbyname('检查日期').AsDateTime);

    //判断该就诊人员是否存在未审核结果START
    if strtoint(ScalarSQLCmd(LisConn,'select count(*) from chk_con where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+''') and isnull(report_doctor,'''')='''' '))>0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':就诊人员['+sPatientname+']存在未审核报告!');
      WriteLog(pchar('就诊人员['+sPatientname+']存在未审核报告!'));
    end;
    //================================STOP

    frxReport1.Clear;//清除报表模板
    frxDBDataSet1.UserName:='ADObasic';//加载模板文件前设置别名.因为一般设计模板文件时已经包含了别名信息
    frxDBDataSet2.UserName:='ADO_print';//加载模板文件前设置别名.因为一般设计模板文件时已经包含了别名信息

    if (sCombin_Id=GP_WorkGroup_T1)
      and frxReport1.LoadFromFile(GP_TempFile_T1) then//加载模板文件是不区分大小写的.空字符串将加载失败
    begin
    end else
    if (sCombin_Id=GP_WorkGroup_T2)
      and frxReport1.LoadFromFile(GP_TempFile_T2) then
    begin
    end else
    if (sCombin_Id=GP_WorkGroup_T3)
      and frxReport1.LoadFromFile(GP_TempFile_T3) then
    begin
    end else
    if not frxReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_Cur_group.fr3') then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']加载默认分组打印模板report_Cur_group.frf失败，请设置:选项->打印模板');
      WriteLog(pchar('['+sPatientname+']加载默认分组打印模板report_Cur_group.fr3失败，请设置:选项->打印模板'));
      
      continue;
    end;

    strsqlPrint:='select cv.combin_name as name,cv.name as 名称,cv.english_name as 英文名,cv.itemvalue as 检验结果,'+
      'cv.unit as 单位,cv.min_value as 最小值,cv.max_value as 最大值,'+
      ' dbo.uf_Reference_Value_B1(cv.min_value,cv.max_value) as 前段参考范围,dbo.uf_Reference_Value_B2(cv.min_value,cv.max_value) as 后段参考范围,'+
      ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10, '+
      ' cv.itemid as 项目代码 '+//cci.Reserve3,
      ' from '+
      ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
      ' cv WITH(NOLOCK) '+
      ' left join clinicchkitem cci on cci.itemid=cv.itemid '+
      ' where cv.pkunid='+sUnid+
      ' and cv.issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
      ' order by cv.pkcombin_id,cv.printorder ';//组合项目号,打印编号 '
    ADO_print.Close;
    ADO_print.SQL.Clear;
    ADO_print.SQL.Text:=strsqlPrint;
    ADO_print.Open;
    if ADO_print.RecordCount=0 then
    begin
      if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
      memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':['+sPatientname+']无效结果!');
      WriteLog(pchar('['+sPatientname+']无效结果!'));
      
      continue;
    end;

    frxDBDataSet1.DataSet:=ADObasic;//关联Fastreport的组件与TDataset数据集
    frxDBDataSet2.DataSet:=ADO_print;//关联Fastreport的组件与TDataset数据集
    frxReport1.DataSets.Clear;//清除原来的数据集
    frxReport1.DataSets.Add(frxDBDataSet1);//加载关联好的TfrxDBDataSet到报表中
    frxReport1.DataSets.Add(frxDBDataSet2);//加载关联好的TfrxDBDataSet到报表中
  
    frxMasterData:=frxReport1.FindObject('MasterData1') as TfrxMasterData;
    if (frxMasterData<>nil) and (frxMasterData is TfrxMasterData) then frxMasterData.DataSet:=frxDBDataSet2;//动态配置MasterData.DataSet
      
    if RadioGroup2.ItemIndex=2 then//导出PDF
    begin
      frxReport1.PrepareReport;
      frxPDFExport1.ShowDialog:=False;
      frxPDFExport1.DefaultPath:=PDFExportPath;
      frxPDFExport1.FileName:=sPatientname+'&'+sCheck_Date+'-'+sUnid+'.pdf';
      frxReport1.Export(frxPDFExport1);
    end else
    if RadioGroup2.ItemIndex=0 then  //预览模式
      begin frxReport1.PrintOptions.ShowDialog:=ifShowPrintDialog;frxReport1.ShowReport; end
    else  //直接打印模式
    begin
      if frxReport1.PrepareReport then begin frxReport1.PrintOptions.ShowDialog:=false;frxReport1.Print;end;
    end;
  end;
  DBGrid1.DataSource.DataSet.GotoBookmark(OldCurrent);
  DBGrid1.DataSource.DataSet.EnableControls;
  //Grid勾选记录判断方式二 end}

  Screen.Cursor := Save_Cursor;  { Always restore to normal }

  if length(memo1.Lines.Text)>=60000 then memo1.Lines.Clear;//memo只能接受64K个字符
  memo1.Lines.Add(FormatDatetime('YYYY-MM-DD HH:NN:SS', Now) + ':打印操作完成！');
end;

procedure TfrmMain.frxReport1BeforePrint(Sender: TfrxReportComponent);
var
  adotemp11:tadoquery;
  unid,iIfCompleted:integer;
  
  strsqlPrint,strEnglishName,strHistogram,strXTitle:string;
  MS:tmemorystream;
  tempjpeg:TJPEGImage;
  Chart_ZFT:TChart;

  //血流变变量start
  Reserve8_1,Reserve8_2:single;//切变率
  mPa_1,mPa_2:string;//粘度
  mPa_min_1,mPa_min_2:string;//粘度
  mPa_max_1,mPa_max_2:string;//粘度
  Chart_XLB:TChart;
  //血流变变量stop

  mvPictureTitle:TfrxMemoView;
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('唯一编号').AsInteger;
  iIfCompleted:=ADObasic.FieldByName('ifCompleted').AsInteger;

  //加载血流变曲线、直方图、散点图 start
  if(Sender is TfrxPictureView)and(pos('CURVE',uppercase(Sender.Name))>0)then
  begin
    Sender.Visible:=false;
    strsqlPrint:='select Reserve8,itemValue,Min_Value,Max_Value '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       ' and Reserve8 is not null '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    adotemp11.Open;
    if adotemp11.RecordCount=2 then
    begin
      Sender.Visible:=true;

      Chart_XLB:=TChart.Create(nil);
      Chart_XLB.Visible:=false;
      
      Reserve8_1:=adotemp11.fieldbyname('Reserve8').AsFloat;//切变率
      mPa_1:=adotemp11.fieldbyname('itemValue').AsString;//粘度
      mPa_min_1:=adotemp11.fieldbyname('Min_Value').AsString;//粘度
      mPa_max_1:=adotemp11.fieldbyname('Max_Value').AsString;//粘度
      adotemp11.Next;
      Reserve8_2:=adotemp11.fieldbyname('Reserve8').AsFloat;//切变率
      mPa_2:=adotemp11.fieldbyname('itemValue').AsString;//粘度
      mPa_min_2:=adotemp11.fieldbyname('Min_Value').AsString;//粘度
      mPa_max_2:=adotemp11.fieldbyname('Max_Value').AsString;//粘度
      Draw_MVIS2035_Curve(Chart_XLB,Reserve8_1,strtofloatdef(mPa_1,-1),Reserve8_2,strtofloatdef(mPa_2,-1),
                          Reserve8_1,strtofloatdef(mPa_min_1,-1),Reserve8_2,strtofloatdef(mPa_min_2,-1),
                          Reserve8_1,strtofloatdef(mPa_max_1,-1),Reserve8_2,strtofloatdef(mPa_max_2,-1));
      TfrxPictureView(Sender).Picture.Assign(Chart_XLB.TeeCreateMetafile(False,Rect(0,0,Round(Sender.Width),Round(Sender.Height))));//指定统计图給FastReport

      Chart_XLB.Free;
    end;
    adotemp11.Free;
  end;
    
  if(Sender is TfrxPictureView)and(pos('CHART',uppercase(Sender.Name))>0)then
  begin
    Sender.Visible:=false;
    strEnglishName:=(Sender as TfrxPictureView).Name;
    strEnglishName:=stringreplace(strEnglishName,'Chart','',[rfIgnoreCase]);
    strsqlPrint:='select top 1 histogram,Dosage1 '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       ' and english_name=:english_name '+
       ' and isnull(histogram,'''')<>'''' '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    adotemp11.Parameters.ParamByName('english_name').Value:=strEnglishName;
    adotemp11.Open;
    strHistogram:=trim(adotemp11.fieldbyname('histogram').AsString);
    strXTitle:=adotemp11.fieldbyname('Dosage1').AsString;
    adotemp11.Free;
    if strHistogram<>'' then
    begin
      Sender.Visible:=true;

      Chart_ZFT:=TChart.Create(nil);
      Chart_ZFT.Visible:=false;

      updatechart(Chart_ZFT,strHistogram,strEnglishName,strXTitle);
      TfrxPictureView(Sender).Picture.Assign(Chart_ZFT.TeeCreateMetafile(False,Rect(0,0,Round(Sender.Width),Round(Sender.Height))));//指定统计图給FastReport

      Chart_ZFT.Free;
    end;
  end;

  if(Sender is TfrxPictureView)and(pos('PICTURE',uppercase(Sender.Name))>0)then
  begin
    Sender.Visible:=false;
    strEnglishName:=(Sender as TfrxPictureView).Name;
    strEnglishName:=stringreplace(strEnglishName,'Picture','',[rfIgnoreCase]);
    strsqlPrint:='select top 1 Photo,english_name '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' WITH(NOLOCK) where pkunid=:pkunid '+
       ' and itemid=:itemid '+//edit by liuying 20110414
       ' and Photo is not null '+
       ' and issure=1 ';
    adotemp11:=tadoquery.Create(nil);
    adotemp11.Connection:=DM.ADOConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:=strsqlPrint;
    adotemp11.Parameters.ParamByName('pkunid').Value:=unid;
    adotemp11.Parameters.ParamByName('itemid').Value:=strEnglishName;//edit by liuying 20110414
    adotemp11.Open;
    if not adotemp11.fieldbyname('photo').IsNull then
    begin
      Sender.Visible:=true;
      MS:=TMemoryStream.Create;
      TBlobField(adotemp11.fieldbyname('photo')).SaveToStream(MS);
      MS.Position:=0;
      tempjpeg:=TJPEGImage.Create;
      tempjpeg.LoadFromStream(MS);
      MS.Free;
      TfrxPictureView(Sender).Picture.assign(tempjpeg);
      tempjpeg.Free;
      
      //显示图片标题begin
      mvPictureTitle:=TfrxMemoView(frxReport1.FindObject('mv'+Sender.Name));
      if (mvPictureTitle<>nil) and (mvPictureTitle is TfrxMemoView) then
      begin
        mvPictureTitle.AutoWidth:=True;
        mvPictureTitle.Font.Name:='宋体';
        mvPictureTitle.SetBounds((Sender as TfrxPictureView).Left, (Sender as TfrxPictureView).Top-20, 50, 20);
        mvPictureTitle.Text:=adotemp11.fieldbyname('english_name').AsString;
        mvPictureTitle.Visible:=true;
      end;
      //显示图片标题end
    end;
    adotemp11.Free;
  end;
  //加载血流变曲线、直方图、散点图 stop
end;

procedure TfrmMain.frxReport1BeginDoc(Sender: TObject);
var
  j,k:integer;
  mvPictureTitle:TfrxMemoView;
begin
  //动态创建图片标题begin
  //待处理问题:是否需要释放mvPictureTitle?何时释放?
  for j:=0 to (Sender as TfrxReport).PagesCount-1 do
  begin
    for k:=0 to (Sender as TfrxReport).Pages[j].Objects.Count-1 do
    begin
      if TObject((Sender as TfrxReport).Pages[j].Objects.Items[k]) is TfrxPictureView then
      begin
        if uppercase(leftstr(TfrxPictureView((Sender as TfrxReport).Pages[j].Objects.Items[k]).Name,7))='PICTURE' then
        begin
          mvPictureTitle:=TfrxMemoView.Create((Sender as TfrxReport).Pages[j]);
          mvPictureTitle.Name:='mv'+TfrxPictureView((Sender as TfrxReport).Pages[j].Objects.Items[k]).Name;
          mvPictureTitle.Visible:=false;
        end;
      end;
    end;
  end;
  //动态创建图片标题end
end;

procedure TfrmMain.frxReport1GetValue(const VarName: String;
  var Value: Variant);
var
  ItemChnName:string;
  cur_value:string;
  min_value:string;
  max_value:string;
  i:integer;
  adotemp22:Tadoquery;
begin
    if VarName='SCSYDW' then Value:=SCSYDW;

    if VarName='CXZF' then
    BEGIN
      ItemChnName:=trim(ADO_print.fieldbyname('项目代码').AsString);
      cur_value:=trim(ADO_print.fieldbyname('检验结果').AsString);
      min_value:=trim(ADO_print.fieldbyname('最小值').AsString);
      max_value:=trim(ADO_print.fieldbyname('最大值').AsString);

      adotemp22:=Tadoquery.Create(nil);
      adotemp22.Connection:=dm.ADOConnection1;
      adotemp22.Close;
      adotemp22.SQL.Clear;
      adotemp22.SQL.Text:='select dbo.uf_ValueAlarm('''+ItemChnName+''','''+min_value+''','''+max_value+''','''+cur_value+''') as ifValueAlarm';
      try//uf_ValueAlarm中的convert函数可能抛出异常
        adotemp22.Open;
        i:=adotemp22.fieldbyname('ifValueAlarm').AsInteger;
      except
        i:=0;
      end;
      adotemp22.Free;
      if i=1 then
      begin
        if VarIsNull(frxReport1.Variables['SymbolLow']) then Value:='↓'//报表模板中未定义变量SymbolLow或变量未赋值
        else Value := frxReport1.Variables['SymbolLow'];
      end else if i=2 then
      begin
        if VarIsNull(frxReport1.Variables['SymbolHigh']) then Value:='↑'//报表模板中未定义变量SymbolHigh或变量未赋值
        else Value := frxReport1.Variables['SymbolHigh'];
      end else Value:='';
    END;

    if VarName='打印者' then Value:=operator_name;
    if VarName='所属公司' then Value:=trim(ADObasic.fieldbyname('所属公司').AsString);
    if VarName='姓名' then Value:=trim(ADObasic.fieldbyname('姓名').AsString);
    if VarName='性别' then Value:=trim(ADObasic.fieldbyname('性别').AsString);
    if VarName='体检日期' then Value:=ADObasic.fieldbyname('检查日期').AsDateTime;
    if VarName='年龄' then Value:=trim(ADObasic.fieldbyname('年龄').AsString);
    if VarName='婚否' then Value:=trim(ADObasic.fieldbyname('婚否').AsString);
    if VarName='工种' then Value:=trim(ADObasic.fieldbyname('工种').AsString);
    if VarName='籍贯' then Value:=trim(ADObasic.fieldbyname('籍贯').AsString);
    if VarName='住址' then Value:=trim(ADObasic.fieldbyname('住址').AsString);
    if VarName='电话' then Value:=trim(ADObasic.fieldbyname('电话').AsString);

    if VarName='检验设备' then Value:=ScalarSQLCmd(LisConn,'select dbo.uf_GetEquipFromChkUnid('+ADObasic.fieldbyname('ifCompleted').AsString+','+ADObasic.fieldbyname('唯一编号').AsString+')');
end;

procedure TfrmMain.frxReport1PrintReport(Sender: TObject);
var
  unid,printtimes,iIfCompleted:integer;
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('唯一编号').AsInteger;
  printtimes:=ADObasic.fieldbyname('打印次数').AsInteger;
  iIfCompleted:=ADObasic.FieldByName('ifCompleted').AsInteger;

  if printtimes=0 then//修改打印次数
    ExecSQLCmd(LisConn,'update '+ifThen(iIfCompleted=1,'chk_con_bak','chk_con')+' set printtimes='+inttostr(printtimes+1)+' where unid='+inttostr(unid));
  
  ExecSQLCmd(LisConn,'insert into pix_tran (pkunid,Reserve1,Reserve2,OpType) values ('+inttostr(unid)+','''+operator_name+''',''Class_Print'',''Nurse'')');
end;

end.

