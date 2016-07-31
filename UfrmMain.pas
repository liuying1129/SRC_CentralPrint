unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils;

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
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
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

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;
  
  UpdateStatusBar(#$2+'6:'+SCSYDW);
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

end.
