unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils, ADOLYGetcode,ShellAPI;

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
    Label1: TLabel;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    ToolButton1: TToolButton;
    SpeedButton4: TSpeedButton;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    Panel3: TPanel;
    DBGrid2: TDBGrid;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Splitter2: TSplitter;
    SpeedButton5: TSpeedButton;
    ToolButton2: TToolButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LabeledEdit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ADOQuery1AfterScroll(DataSet: TDataSet);
    procedure ADOQuery1AfterOpen(DataSet: TDataSet);
    procedure ADOQuery2AfterOpen(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
  private
    procedure WriteProfile;
    procedure ReadConfig;
    procedure ReadIni;
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM;
var
  lsGroupShow:TStrings;

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;

  ReadConfig;
  UpdateStatusBar(#$2+'6:'+SCSYDW);
end;

procedure TfrmMain.ReadConfig;
var
  configini:tinifile;
begin
  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  {IF CONFIGINI.ReadBool('Interface','ifPreview',TRUE) THEN
  begin
    n9.Checked:=TRUE;   //打印预览
    n8.Checked:=false;  //直接打印
  end ELSE
  begin
    n9.Checked:=false;
    n8.Checked:=TRUE;
  end;//}

  //n41.Checked:=configini.ReadBool('Interface','ifRTTransData',true);
  //N25.Checked:=configini.ReadBool('Interface','ifPagination',false);{记录是否按组分页}
  //N64.Checked:=configini.ReadBool('Interface','ifCaseNoMerger',false);{记录是否按姓别性别年龄合并打印}
  //n50.Checked:=configini.ReadBool('Interface','ifShowEnglish',true);
  //n36.Checked:=configini.ReadBool('Interface','ifShowMinValue',true);{记录是否显示项目最小值}
  //n47.Checked:=configini.ReadBool('Interface','ifShowMaxValue',true);{记录是否显示项目最大值}
  //n49.Checked:=configini.ReadBool('Interface','ifShowUnit',true);{记录是否显示项目单位}
  DBGrid1.Width:=configini.ReadInteger('Interface','gridBaseInfoWidth',460);{记录基本信息框宽度}
  Memo1.Height:=configini.ReadInteger('Interface','memoLogHeight',150);{记录组合项目选择框高度}

  RadioGroup1.ItemIndex:=configini.ReadInteger('Interface','normalTimeRadio',0);
  RadioGroup2.ItemIndex:=configini.ReadInteger('Interface','noprintTimeRadio',0);
  RadioGroup3.ItemIndex:=configini.ReadInteger('Interface','ifPrintRadio',0);

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

  MergePrintDays:=strtointdef(ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''系统代码'' and ReMark=''历史结果合并打印的偏差天数'' '),0);
  MakeTjDescDays:=strtointdef(ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''系统代码'' and ReMark=''生成体检结论的偏差天数'' '),0);
  bAppendMakeTjDesc:=ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''系统代码'' and ReMark=''允许追加生成体检结论'' ');

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  SmoothNum:=configini.ReadInteger('报表','直方图光滑次数',0);
  CXZF:=configini.ReadString('报表','检验结果超限字符','↑↓');
  if trim(CXZF)='' then CXZF:='↑↓';
  ifNoResultPrint:=configini.ReadBool('报表','允许无检验结果打印',false);
  MergePrintWorkGroupRange:=trim(configini.ReadString('报表','"按姓名性别年龄合并"的工作组范围',''));
  MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,'，',',',[rfReplaceAll]);
  if MergePrintWorkGroupRange<>'' then
  begin
    MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,',',''',''',[rfReplaceAll]);
    MergePrintWorkGroupRange:=''''+MergePrintWorkGroupRange+'''';
  end;
  ifAutoCheck:=configini.ReadBool('选项','打印时自动审核检验单',false);
  ifEnterGetCode:=configini.ReadBool('选项','填写病人基本信息时,直接回车弹出取码框',false);
  deptname_match:=configini.ReadString('选项','送检科室取码的匹配方式','');
  check_doctor_match:=configini.ReadString('选项','送检医生取码的匹配方式','');
  ifDoctorStation:=configini.ReadBool('选项','仅显示已审核的检验单',false);
  ShowSelfDJ:=configini.ReadBool('选项','仅显示登录者所开检验单',false);
  ifGetInfoFromHis:=configini.ReadBool('选项','提取HIS中的病人基本信息及检验项目',false);
  ifGetMemoFromCaseNo:=configini.ReadBool('选项','根据"门诊/住院号"提取备注',false);
  ifAutoCompletionJob:=configini.ReadBool('选项','是否关闭程序时自动结束检验工作',false);
  LoginTime:=configini.ReadInteger('选项','弹出登录窗口的时间',30);
  ifSearchHistValue:=configini.ReadBool('选项','查找历史结果',false);

  TempFile_Common:=configini.ReadString('打印模板','通用模板文件','');
  TempFile_Group:=configini.ReadString('打印模板','分组模板文件','');
  WorkGroup_T1:=configini.ReadString('打印模板','特殊模板1工作组','');
  TempFile_T1:=configini.ReadString('打印模板','特殊模板1文件','');
  WorkGroup_T2:=configini.ReadString('打印模板','特殊模板2工作组','');
  TempFile_T2:=configini.ReadString('打印模板','特殊模板2文件','');
  WorkGroup_T3:=configini.ReadString('打印模板','特殊模板3工作组','');
  TempFile_T3:=configini.ReadString('打印模板','特殊模板3文件','');  

  ifHeightForItemNum:=configini.ReadBool('打印模板','启用项目数控制纸张长度',false);
  ItemRecNum:=configini.ReadInteger('打印模板','每页项目数最大值',0);
  PageHeigth:=configini.ReadInteger('打印模板','报告长度',2794);  
      
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
      '检验结果超限字符'+#2+'Combobox'+#2+'↑↓'+#13+'H L'+#2+'0'+#2+'注:第1、2位为超上限字符，第3、4位为超下限字符'+#2+#3+
      '允许无检验结果打印'+#2+'CheckListBox'+#2+#2+'0'+#2+#2+#3+
      '"按姓名性别年龄合并"的工作组范围'+#2+'Edit'+#2+#2+'0'+#2+'如仅希望临检组与生化组合并,则填"临检组,生化组".空表示无限制'+#2+#3+
      '打印时自动审核检验单'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '根据"门诊/住院号"提取备注'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '提取HIS中的病人基本信息及检验项目'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '填写病人基本信息时,直接回车弹出取码框'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '送检科室取码的匹配方式'+#2+'Combobox'+#2+'模糊匹配'+#13+'左匹配'+#13+'右匹配'+#13+'全匹配'+#2+'1'+#2+#2+#3+
      '送检医生取码的匹配方式'+#2+'Combobox'+#2+'模糊匹配'+#13+'左匹配'+#13+'右匹配'+#13+'全匹配'+#2+'1'+#2+#2+#3+
      '仅显示已审核的检验单'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '仅显示登录者所开检验单'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '是否关闭程序时自动结束检验工作'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '病人基本信息排序方式'+#2+'Combobox'+#2+'流水号'+#13+'联机号'+#2+'1'+#2+#2+#3+
      '弹出登录窗口的时间'+#2+'Edit'+#2+#2+'1'+#2+'注:表示多长时间内无操作,则自动弹出登录窗口(单位:秒)'+#2+#3+
      '查找历史结果'+#2+'CheckListBox'+#2+#2+'1'+#2+'注:启用该选项将降低系统性能,慎用!'+#2+#3+
      '通用模板文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '分组模板文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板1工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板1文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板2工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板2文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '特殊模板3工作组'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '特殊模板3文件'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '启用项目数控制纸张长度'+#2+'CheckListBox'+#2+#2+'2'+#2+'注:对普通打印、分组打印生效'+#2+#3+
      '每页项目数最大值'+#2+'Edit'+#2+#2+'2'+#2+'注:如项目数大于该值,则纸张长度为"报告长度"的值.默认值为0'+#2+#3+
      '报告长度'+#2+'Edit'+#2+#2+'2'+#2+'默认值为2794,单位:mm'+#2+#3;
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
  
  configini.WriteInteger('Interface','normalTimeRadio',RadioGroup1.ItemIndex);
  configini.WriteInteger('Interface','noprintTimeRadio',RadioGroup2.ItemIndex);
  configini.WriteInteger('Interface','ifPrintRadio',RadioGroup3.ItemIndex);

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
  strsql22,strsql,strsql44,STRSQL45,STRSQL46,STRSQL47,STRSQL48,STRSQL49,STRSQL50: string;
begin
  strsql:='select patientname as 姓名,'+
        ' sex as 性别,'+
        ' age as 年龄,caseno as 病历号,bedno as 床号,deptname as 送检科室,'+
        ' check_doctor as 送检医生,check_date as 检查日期,'+
        ' report_date as 申请日期,'+
        ' operator as 操作者,printtimes as 打印次数,diagnosetype as 优先级别,'+
        ' flagetype as 样本类型,diagnose as 临床诊断,typeflagcase as 样本情况,'+
        ' issure as 备注,unid as 唯一编号,combin_id as 工作组, '+
        ' His_Unid as His唯一编号,His_MzOrZy as His门诊或住院, '+
        ' WorkDepartment as 所属部门,WorkCategory as 工种,WorkID as 工号,ifMarry as 婚否,OldAddress as 籍贯,Address as 住址,Telephone as 电话,WorkCompany as 所属公司, '+
        ' PushPress as 舒张压,PullPress as 收缩压,LeftEyesight as 左眼视力,RightEyesight as 右眼视力,Stature as 身高,Weight as 体重, '+
        ' Audit_Date as 审核时间,ifCompleted,checkid as 联机号,lsh as 流水号,report_doctor as 审核者 '+
        ' from view_Chk_Con_All where ';
  if RadioGroup1.ItemIndex=1 then
    strsql44:=' CONVERT(CHAR(10),check_date,121)=CONVERT(CHAR(10),GETDATE(),121) and '
  else if RadioGroup1.ItemIndex=2 then
    strsql44:=' check_date>GETDATE()-3 and '
  else if RadioGroup1.ItemIndex=3 then
    strsql44:=' check_date>GETDATE()-7 and '
  else if RadioGroup1.ItemIndex=4 then
    strsql44:=' check_date>GETDATE()-30 and '
  else strsql44:=' ';
  if RadioGroup3.ItemIndex=1 then
    STRSQL46:=' isnull(printtimes,0)<=0 and '
  else STRSQL46:='';
  if trim(LabeledEdit1.Text)<>'' then STRSQL48:=' Caseno='''+trim(LabeledEdit1.Text)+''' and '
  else STRSQL48:='';
  if trim(LabeledEdit2.Text)<>'' then STRSQL22:=' patientname='''+trim(LabeledEdit2.Text)+''' and '
  else STRSQL22:='';
  if trim(LabeledEdit3.Text)<>'' then STRSQL45:=' deptname='''+trim(LabeledEdit3.Text)+''' and '
  else STRSQL45:='';
  if trim(LabeledEdit4.Text)<>'' then STRSQL50:=' check_doctor='''+trim(LabeledEdit4.Text)+''' and '
  else STRSQL50:='';
  STRSQL47:=' isnull(report_doctor,'''')<>'''' ';
  STRSQL49:=' order by patientname ';
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add(strsql);
  ADOQuery1.SQL.Add(strsql44);
  ADOQuery1.SQL.Add(strsql46);
  ADOQuery1.SQL.Add(strsql48);
  ADOQuery1.SQL.Add(strsql22);
  ADOQuery1.SQL.Add(strsql45);
  ADOQuery1.SQL.Add(strsql50);
  ADOQuery1.SQL.Add(strsql47);
  ADOQuery1.SQL.Add(strsql49);
  ADOQuery1.Open;
end;

procedure TfrmMain.ADOQuery1AfterScroll(DataSet: TDataSet);
var
  strsql11:string;
begin
  if not ADOQuery1.Active then exit;

  strsql11:='select '+
            '(case when photo is null then null else ''图'' end) as 图,'+
            'combin_Name as 组合项目,name as 名称,english_name as 英文名,itemvalue as 检验结果,'+
            'min_value as 最小值,max_value as 最大值,'+
            'unit as 单位,'+
            'pkcombin_id as 组合项目号,itemid as 项目编号,valueid as 唯一编号 '+
            ' from '+
            ifThen(ADOQuery1.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 '+
            ' order by pkcombin_id,printorder ';

  ADOQuery2.Close;
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Text:=strsql11;
  ADOQuery2.Parameters.ParamByName('pkunid').Value:=ADOQuery1.FieldByName('唯一编号').AsInteger;
  try
    ADOQuery2.Open;
  except
  end;
end;

procedure TfrmMain.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid1.Columns[0].Width:=42;//姓名
  dbgrid1.Columns[1].Width:=30;//性别
  dbgrid1.Columns[2].Width:=30;//年龄
  dbgrid1.Columns[3].Width:=65;//病历号
  dbgrid1.Columns[4].Width:=30;//床号
  dbgrid1.Columns[5].Width:=60;//送检科室
  dbgrid1.Columns[6].Width:=55;//送检医生
  dbgrid1.Columns[7].Width:=72;//检查日期
  dbgrid1.Columns[8].Width:=72;//申请日期
  dbgrid1.Columns[9].Width:=40;//流水号
  dbgrid1.Columns[10].Width:=40;//联机号
  dbgrid1.Columns[11].Width:=42;//审核者

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
            ifThen(ADOQuery1.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 order by pkcombin_id ';

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=dm.ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:=strsql11;
  adotemp11.Parameters.ParamByName('pkunid').Value :=ADOQuery1.FieldByName('唯一编号').AsInteger;
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
  dbgrid2.Columns[8].Width:=50;
  dbgrid2.Columns[9].Width:=50;
  dbgrid2.Columns[10].Width:=50;

end;

procedure TfrmMain.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  PrintTimes:integer;
  strPrintTimes,Diagnosetype:string;
begin
   //======================打印过的流水号变化颜色======================//
    if datacol=0 then //姓名列,因为流水号列有可能隐藏
    begin
      strPrintTimes:=ADOQuery1.fieldbyname('打印次数').AsString;
      PrintTimes:=strtointdef(strPrintTimes,0);
      IF PrintTimes<>0 then
      begin
        tdbgrid(sender).Canvas.Font.Color:=clred;
        tdbgrid(sender).DefaultDrawColumnCell(rect,datacol,column,state);
      end;
    end;
   //==========================================================================//
end;

procedure TfrmMain.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  i:integer;
  ItemChnName,cur_value,min_value,max_value:string;//,nst_value
  sGroup,IsEdited:string;
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
    tdbgrid(sender).DefaultDrawColumnCell(rect,datacol,column,state);
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
        tdbgrid(sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
        break;
      end;
    end;
  end;
  //========================//}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  lsGroupShow:=tstringlist.Create;
end;

end.
