unit UDM;

interface

uses
  WINDOWS,SysUtils, Classes, DB, ADODB,INIFILES,Dialogs{ShowMessage函数},Controls,
  ComCtrls, Buttons,StdCtrls, ExtCtrls,MENUS,DBGrids,StrUtils, FR_Class,
  FR_DSet, FR_DBSet,Forms{Application变量},DBCtrls{DBEdit},Mask{TMaskEdit},Imm{ImmGetIMEFileName},
  CheckLst{TCheckListBox};

type
  PDescriptType=^TDescriptType;
  TDescriptType=record
    ID:string;//体检类型ID
    UpID:String;//上级类型ID
  end;
  
type
  TDM = class(TDataModule)
    ADOConnection1: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  SYSNAME='CentralPrint';
  sDBALIAS='ALIAS_SHHJ';
  CGYXJB='常规';//常规优先级别字符串
  CryptStr='lc';

  //0 as 选择,默认是未选择的.1--选择,非1--未选
  SHOW_CHK_CON='select top 1000 patientname as 姓名,'+
        ' sex as 性别,'+
        ' age as 年龄,printtimes as 打印次数,caseno as 病历号,bedno as 床号,deptname as 送检科室,'+
        ' check_doctor as 送检医生,check_date as 检查日期,'+
        ' report_date as 申请日期,report_doctor as 审核者,'+//dbo.uf_GetPatientCombName(ifCompleted,unid) as 组合项目,'+
        ' combin_id as 工作组,operator as 操作者,diagnosetype as 优先级别,'+
        ' flagetype as 样本类型,diagnose as 临床诊断,typeflagcase as 样本情况,'+
        ' issure as 备注,unid as 唯一编号, '+
        ' His_Unid as His唯一编号,His_MzOrZy as His门诊或住院, '+
        ' WorkCompany as 所属公司,WorkDepartment as 所属部门,WorkCategory as 工种,WorkID as 工号,ifMarry as 婚否,OldAddress as 籍贯,Address as 住址,Telephone as 电话, '+
        ' Audit_Date as 审核时间,ifCompleted,checkid as 联机号,lsh as 流水号, '+
        ' PushPress as 样本送交人,PullPress as 样本接收人,LeftEyesight as 左眼视力,RightEyesight as 右眼视力,Stature as 样本接收时间,Weight as 单据状态, '+
        ' TjJiWangShi as 既往史,TjJiaZuShi as 家族史,TjNeiKe as 内科,TjWaiKe as 外科,TjWuGuanKe as 五官科,TjFuKe as 妇科,TjLengQiangGuang as 冷强光,TjXGuang as X光,TjBChao as 危急值报告时间,TjXinDianTu as 危急值报告人,TjJianYan as 条码号,'+
        ' TjDescription as 结论,TJAdvice as 建议 '+
        ' from view_Chk_Con_All ';

var
  DM: TDM;

  powerstr_js_main:string;
  operator_name:string;
  operator_id:string;
  operator_DeptName:string;//操作员部门名称
  
  ifEnterGetCode:boolean;//记录是否 填写病人基本信息时,直接回车弹出取码框
  deptname_match:string;//记录送检科室的取码匹配方式
  check_doctor_match:string;////记录送检医生的取码匹配方式
  SCSYDW:STRING;//授权使用单位
  SmoothNum:integer;//直方图光滑次数
  LisConn:string;//Lis连接字符串,MakeDBConn过程中被赋值,然后传入QC.DLL、CalcItemPro.dll
  gServerName:string;//服务名,用于显示在状态栏
  gDbName:string;//数据库名,用于显示在状态栏
  BASE_URL:STRING;//http://211.97.0.5:8080/YkAPI/service
  ifShowPrintDialog:boolean;//打印对话框

  WorkGroup_T1:string;
  TempFile_T1:string;
  WorkGroup_T2:string;
  TempFile_T2:string;
  WorkGroup_T3:string;
  TempFile_T3:string;
  WorkGroup_T4:string;
  TempFile_T4:string;
  WorkGroup_T5:string;
  TempFile_T5:string;
  WorkGroup_T6:string;
  TempFile_T6:string;
  WorkGroup_T7:string;
  TempFile_T7:string;
  WorkGroup_T8:string;
  TempFile_T8:string;
  WorkGroup_T9:string;
  TempFile_T9:string;
  WorkGroup_T10:string;
  TempFile_T10:string;
  WorkGroup_T11:string;
  TempFile_T11:string;
  WorkGroup_T12:string;
  TempFile_T12:string;
  WorkGroup_T13:string;
  TempFile_T13:string;
  WorkGroup_T14:string;
  TempFile_T14:string;
  WorkGroup_T15:string;
  TempFile_T15:string;
  GP_WorkGroup_T1:string;//分组模板1工作组
  GP_TempFile_T1:string;//分组模板1文件
  GP_WorkGroup_T2:string;//分组模板2工作组
  GP_TempFile_T2:string;//分组模板2文件
  GP_WorkGroup_T3:string;//分组模板3工作组
  GP_TempFile_T3:string;//分组模板3文件

//**********************Dll接口函数部分***************************************//
//该函数计算pSourStr中有多少个pSS
function ManyStr(const pSS, pSourStr: Pchar): integer;stdcall;external 'LYFunction.dll';
//范围字符串pRangeStr类似5,7-9,11 转换为('0005','0007','0008','0009','0011')
function RangeStrToSql(const pRangeStr:Pchar;const ifLPad:boolean;const LPad:Char;const sWidth:integer;var pSqlStr:Pchar):boolean;stdcall;external 'LYFunction.dll';
//加强型的Pos函数,取得psubStr在pAllstr中第Times次出现的位置
function PosExt(const psubStr,pAllstr:Pchar;const Times:Byte):integer;stdcall;external 'LYFunction.dll';
//找到表达式中小数点位数的最大值.如56.5*100+23.01的值为2
function MaxDotLen(const ACalaExp:PChar):integer;stdcall;external 'LYFunction.dll';
function GetHDSn(const RootPath:pchar):pchar;stdcall;external 'LYFunction.dll';
function GetSysCurImeName: pchar;stdcall;external 'LYFunction.dll';//取得系统当前的中文输入法名称
function GetVersionLY(const AFileName:pchar):pchar;stdcall;external 'LYFunction.dll';
function CassonEquation(const X1,Y1,X2,Y2:Real;var A,B:Real):boolean;stdcall;external 'LYFunction.dll';//卡松方程式
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//解密
function EnCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//加密
function CalParserValue(const CalExpress:Pchar;var ReturnValue:single):boolean;stdcall;external 'CalParser.dll';
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
Function IdleTrackerInit:boolean;stdcall;external 'IdleTrac.dll';//start the monitoring process
Procedure IdleTrackerTerm;stdcall;external 'IdleTrac.dll';//stop the monitoring process
Function IdleTrackerGetLastTickCount:Longint;stdcall;external 'IdleTrac.dll';//get the tick count of last user input
//将计算项目增加或编辑到检验结果表中
procedure addOrEditCalcItem(const Aadoconnstr:Pchar;const ComboItemID:Pchar;const checkunid: integer);stdcall;external 'CalcItemPro.dll';
//将计算数据增加或编辑到检验结果表中
procedure addOrEditCalcValu(const Aadoconnstr:Pchar;const checkunid: integer;const AifInterface:boolean;const ATransItemidString:pchar);stdcall;external 'CalcItemPro.dll';
function LastPos(const ASubStr,ASourStr:Pchar):integer;stdcall;external 'LYFunction.dll';
procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';
//****************************************************************************//

procedure SendKeyToControl(const VK:byte;control:Twincontrol);
function ageConvertChinese(agestr: string): string;
function GetServerDate(adoConn:TADOConnection):TDate;
procedure AddPickList(dbgrid: tdbgrid; const FieldIndex: integer;const JoinStr: string);//JoinStr是这样的样式：aa,bb,cc,dd
//控制指定列的显示与否
procedure VisibleColumn(dbgrid:tdbgrid;const DisplayName:string;const ifVisible:boolean);
function ifhaspower(sender: tobject;const powerstr_js:string): boolean;
//function GetMaxId(const combin_id:string;CurDate:tdate;Diagnosetype:string): string;//取得最大流水号,参数:组别名及日期
function HasSubInDbf(Node:TTreeNode):Boolean;
function ifRegister:boolean;
Procedure ChangeYouFormAllControlIme(YFormName:TWinControl);//需要更改输入法的窗体名称
function SmoothLine(const strHistogram:string;const SmoothNum:byte;var Strings:TStrings;var AMin:single;var AMax:single):integer;
function GetNextValue(CurValue: string): string;
function GetFirstValue(CurValue: string): string;
function MakeDBConn:boolean;
procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
procedure MakeDBGridColumnsAutoFixItsWidth(objDBGrid:TDBGrid);
function GetMaxCheckId(const ACombin_ID:string;const AServerDate:tdate):string;//获取指定工作组、日期的下一个联机号
function ExecSQLCmd(AConnectionString:string;ASQL:string):integer;
function ScalarSQLCmd(AConnectionString:string;ASQL:string):string;
procedure combinchecklistbox(CheckListBox:TCheckListBox);//将组合项目号及名称导入CheckListBox中

implementation

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  MakeDBConn;
end;

procedure VisibleColumn(dbgrid:tdbgrid;const DisplayName:string;const ifVisible:boolean);
var
  i:integer;
begin
  if not dbgrid.DataSource.DataSet.Active then exit;
  for i :=0  to dbgrid.Columns.Count-1 do
    if uppercase(dbgrid.Fields[i].DisplayName)=uppercase(DisplayName) then
      dbgrid.Columns[i].Visible:=ifVisible;
end;

procedure AddPickList(dbgrid: tdbgrid; const FieldIndex: integer;
  const JoinStr: string);//JoinStr是这样的样式：aa,bb,cc,dd 注：用英文或中文状态的逗号分隔均可
var
  CommaPos:integer;
  s1,s2:string;
begin
  s1:=JoinStr;
  if not dbgrid.DataSource.DataSet.Active then exit;
  if dbgrid.DataSource.DataSet.RecordCount=0 then exit;
  dbgrid.Columns[FieldIndex].PickList.Clear;
  if trim(JoinStr)='' then exit;
  CommaPos:=pos(',',s1);
  while CommaPos<>0 do
  begin
    s2:=trim(copy(s1,1,CommaPos-1));
    if trim(s2)<>'' then dbgrid.Columns[FieldIndex].PickList.add(s2);
    delete(s1,1,CommaPos);
    CommaPos:=pos(',',s1);
  end;
  if trim(s1)<>'' then dbgrid.Columns[FieldIndex].PickList.add(s1);
end;

function GetServerDate(adoConn:TADOConnection):TDate;
//返回值中包括了日期部分及时间部分
//datetimetostr(返回值)-->2005-8-28 10:05:36
//datetostr(返回值)-->2005-8-28
//timetostr(返回值)-->10:05:36
var
  adotempDate:tadoquery;
begin
  adotempDate:=tadoquery.Create(NIL);
  ADOTEMPDATE.Connection:=adoConn;
  ADOTEMPDATE.Close;
  ADOTEMPDATE.SQL.Clear;
  ADOTEMPDATE.SQL.Text:='SELECT GETDATE() as ServerDate ';
  ADOTEMPDATE.Open;
  result:=ADOTEMPDATE.fieldbyname('ServerDate').AsDateTime;
  ADOTEMPDATE.Free;  //}
end;

procedure SendKeyToControl(const VK:byte;control:Twincontrol);
BEGIN
  control.SetFocus;
  keybd_event(VK,MapVirtualKey(VK,0),0,0); //指定键被按下
END;

function ageConvertChinese(agestr: string): string;
var
  fagestr:single;
begin
    agestr:=uppercase(agestr);
    result:='';
    if (agestr='') then begin result:=''; exit;end;
    if UpperCase(agestr)='C' then begin result:='成'; exit;end;
    if trystrtofloat(agestr,fagestr) then begin result:=agestr+'岁';exit;end;
    result:=StringReplace(agestr,'N','分钟',[rfReplaceAll,rfIgnoreCase]);
    result:=StringReplace(result,'Y','岁',[rfReplaceAll,rfIgnoreCase]);
    result:=StringReplace(result,'M','月',[rfReplaceAll,rfIgnoreCase]);
    result:=StringReplace(result,'D','天',[rfReplaceAll,rfIgnoreCase]);
    result:=StringReplace(result,'H','小时',[rfReplaceAll,rfIgnoreCase]);
end;

function haspower(powerstr_cur, menuname,sDatabaseName: string): boolean;
var
  jsmc:string;
  plusPos:integer;
  aa,bb:string;
  menuname_js:string;
  ADOquery_ryjs,ADOquery_menuitem:tADOquery;
  user_powerstr:string;
  ado_super:tadoquery;
begin
  result:=false;
  //===============超级用户例外=================//
  ado_super:=tadoquery.Create(nil);
  ado_super.Connection:=DM.ADOConnection1;
  ado_super.SQL.Clear;
  ado_super.SQL.Text:='select * from worker where ifSuperUser=''1'' ';
  ado_super.Open;
  ado_super.First;
  if ado_super.Locate('id',operator_id,[loCaseInsensitive]) then
  begin
    result:=true;
    ado_super.Free;
    exit;
  end;
  //=======================================================//
  aa:='';bb:='';
  user_powerstr:=powerstr_cur;

  ADOquery_ryjs:=tADOquery.Create(nil);
  ADOquery_ryjs.Connection:=DM.ADOConnection1;
  ADOquery_ryjs.SQL.Clear;
  ADOquery_ryjs.SQL.Text:='select * from ryjs';
  ADOquery_ryjs.Open;

  ADOquery_menuitem:=tADOquery.Create(nil);
  ADOquery_menuitem.Connection:=DM.ADOConnection1;
  ADOquery_menuitem.SQL.Clear;
  ADOquery_menuitem.SQL.Text:='select * from menuitem WHERE SYSNAME='''+SYSNAME+''' ';
  ADOquery_menuitem.Open;

  while length(user_powerstr)>=3 do
  begin
    plusPos:=posExt('+',Pchar(user_powerstr),2);
    jsmc:=copy(user_powerstr,2,pluspos-2);
    try
      aa:=aa+ADOquery_ryjs.Lookup('jsmc',jsmc,'jsqx');
    except
      aa:=aa+'';
    end;
    delete(user_powerstr,1,pluspos);
  end;

  while length(aa)>=3 do
  begin
    bb:=copy(aa,1,3);
    if ADOquery_menuitem.Locate('bm',bb,[loCaseInsensitive]) then
        menuname_js:=trim(ADOquery_menuitem.fieldbyname('menuname').AsString)
    else  menuname_js:='';

    if  UpperCase(menuname_js)= UpperCase(Trim(menuname)) then
    begin
      result:=true;
      ADOquery_ryjs.Free;
      ADOquery_menuitem.Free;
      exit;
    end;
    delete(aa,1,3);
  end;

  if ADOquery_ryjs<>nil then ADOquery_ryjs.Free;
  if ADOquery_menuitem<>nil then ADOquery_menuitem.Free;
  if ado_super<>nil then ado_super.Free;
end;

function ifhaspower(sender: tobject;const powerstr_js:string): boolean;
begin
  result:=true;

  if sender is tmenuitem then
  begin
    if not haspower(powerstr_js,tmenuitem(sender).Caption,sDBALIAS) then result:=false;
  end;

  if sender is ttoolbutton then
  begin
    if not haspower(powerstr_js,ttoolbutton(sender).Caption,sDBALIAS) then result:=false;
  end;

  if sender is tbutton then
  begin
    if not haspower(powerstr_js,tbutton(sender).Caption,sDBALIAS) then result:=false;
  end;

  if sender is tpanel then
  begin
    if not haspower(powerstr_js,tpanel(sender).Caption,sDBALIAS) then result:=false;
  end;

  if sender is tspeedbutton then
  begin
    if not haspower(powerstr_js,tspeedbutton(sender).Caption,sDBALIAS) then result:=false;
  end;//}

  if sender is tcombobox then  
  begin
    if not haspower(powerstr_js,inttostr(tcombobox(sender).tag),sDBALIAS) then result:=false;
  end;

  if sender is tedit then
  begin
    if not haspower(powerstr_js,inttostr(tedit(sender).tag),sDBALIAS) then result:=false;
  end;

  if sender is tLabeledEdit then
  begin
    if not haspower(powerstr_js,tLabeledEdit(sender).EditLabel.Caption,sDBALIAS) then result:=false;
  end;

  if not result then
      messagedlg('对不起，您没有该权限！',mtinformation,[mbok],0);
end;

{function GetMaxId(const combin_id:string;CurDate:tdate;Diagnosetype:string): string;  //取得最大流水号
var
  maxid: string;
  adotemp11:tadoquery;
  iMaxId:integer;
begin
  if(Diagnosetype<>CGYXJB)and(Diagnosetype<>'急诊')and(Diagnosetype<>'加急')then Diagnosetype:=CGYXJB;

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=DM.ADOConnection1;
          ADOtemp11.Close;
          ADOtemp11.SQL.Clear;
          //ADOtemp11.SQL.Text:='select max(LSH)+1 as maxid from chk_con '+
          //                  ' WHERE (CONVERT(CHAR(10),check_date,121)=:p_CHECK_DATE1 ) '+
          //                  ' and (chk_con.LSH like ''[0-9][0-9][0-9][0-9]'') '+
          //                  ' AND (chk_con.combin_id='''+combin_id+''')'+
          //                  ' and (chk_con.Diagnosetype='''+Diagnosetype+''')'+
          //                  ' order by maxid desc';     //按降序排序
          ADOtemp11.SQL.Text:='select LSH from chk_con '+
                            ' WHERE (CONVERT(CHAR(10),check_date,121)=:p_CHECK_DATE1 ) '+
                            ' AND (chk_con.combin_id='''+combin_id+''')'+
                            ' and (chk_con.Diagnosetype='''+Diagnosetype+''')'+
                            ' order by right(''0000''+lsh,4) desc';     //按降序排序

          ADOtemp11.Parameters.ParamByName('p_CHECK_DATE1').Value:=FormatDateTime('YYYY-MM-DD',CurDate);
          ADOtemp11.open;
          //ADOtemp11.First;
      maxid := trim(ADOtemp11.FieldByName('LSH').AsString);
      ADOtemp11.Free;
      
       if not trystrtoint(maxid,iMaxId) then begin result:='0001';exit;end;

      //if Length(maxid) = 0 then
      //  maxid := '0001';
      //if Length(maxid) = 1 then
      //  maxid := '000' + maxid;
      //if Length(maxid) = 2 then
      //  maxid := '00' + maxid;
      //if Length(maxid) = 3 then
      //  maxid := '0' + maxid; 
      result := rightstr('0000'+inttostr(iMaxId+1),4);
end;//}

function HasSubInDbf(Node:TTreeNode):Boolean;
//检查节点Node有无子节点,有则返回True,反之返回False
var
  adotemp22:tadoquery;
begin
  result:=false;
  adotemp22:=tadoquery.Create(nil);
  adotemp22.Connection:=dm.ADOConnection1;
  adotemp22.Close;
  adotemp22.SQL.Clear;
  adotemp22.SQL.Text:='select * from RisDescriptType where UpID='''+PDescriptType(Node.Data)^.ID+'''';
  adotemp22.Open;
  if adotemp22.RecordCount<>0 then result:= True;
  adotemp22.Free;
end;

function ifRegister:boolean;
var
  HDSn,RegisterNum,EnHDSn:string;
  configini:tinifile;
  pEnHDSn:Pchar;
begin
  result:=false;
  
  HDSn:=GetHDSn('C:\')+'-'+GetHDSn('D:\');//函数返回的Pchar类型还真能直接赋值给string!!!

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));
  RegisterNum:=CONFIGINI.ReadString('Register','RegisterNum','');
  CONFIGINI.Free;
  pEnHDSn:=EnCryptStr(Pchar(HDSn),Pchar(CryptStr));
  EnHDSn:=StrPas(pEnHDSn);

  if Uppercase(EnHDSn)=Uppercase(RegisterNum) then result:=true;

  if not result then messagedlg('对不起,您没有注册或注册码错误,请注册!',mtinformation,[mbok],0);
end;

Procedure ChangeYouFormAllControlIme(YFormName:TWinControl);//需要更改输入法的窗体名称
//输入法自动切换过程
//20051104 by 刘鹰
//解决思路:
//程序员只需要将窗体中该输入中文的控件的imemode=imOpen,然后在每个窗体里
//create(或active)事件里调用本人编写的方法ChangeYouFormAllControlIme(Self)即可.
//在程序中提供一个用户输入法选项供用户选择自己喜欢的输入法,
//调用显示FrmImeNameList窗体即可!
//注意：在"选择输入法后"要再次调用ChangeYouFormAllControlIme(Self)方法哦:)
var
  StrImeName:string;
  procedure JugeClassType(PClass:Tcontrol);
  //虽然麻烦,但必须具体判断,下面将 dephi可更改的控件几乎都包含了,没有包含的是使用价值不大.
  begin
    if pclass is TEdit then//更改Tedit类控件,以下同理
    begin
      if TEdit(pclass).ImeMode=imOpen then
        TEdit(pclass).ImeName:=StrImeName
      else
        TEdit(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TLabeledEdit then
    begin
      if TLabeledEdit(pclass).ImeMode=imOpen then
        TLabeledEdit(pclass).ImeName:=StrImeName
      else
        TLabeledEdit(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TMemo then
    begin
      if TMemo(pclass).ImeMode=imOpen then
       TMemo(pclass).ImeName:=StrImeName
      else
       TMemo(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TComboBox then
    begin
      if TComboBox(pclass).ImeMode=imOpen then
       TComboBox(pclass).ImeName:=StrImeName
      else
       TComboBox(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TRichEdit then
    begin
      if TRichEdit(pclass).ImeMode=imOpen then
       TRichEdit(pclass).ImeName:=StrImeName
      else
       TRichEdit(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TDBGrid then
    begin
      if TDBGrid(pclass).ImeMode=imOpen then
       TDBGrid(pclass).ImeName:=StrImeName
      else
       TDBGrid(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TDBEdit then
    begin
      if TDBEdit(pclass).ImeMode=imOpen then
       TDBEdit(pclass).ImeName:=StrImeName
      else
       TDBEdit(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TDbMemo then
    begin
      if TDbMemo(pclass).ImeMode=imOpen then
       TDbMemo(pclass).ImeName:=StrImeName
      else
       TDbMemo(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TDbcombobox then
    begin
      if TDbcombobox(pclass).ImeMode=imOpen then
       TDbcombobox(pclass).ImeName:=StrImeName
      else
       TDbcombobox(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is Tdblookupcombobox then
    begin
      if Tdblookupcombobox(pclass).ImeMode=imOpen then
       Tdblookupcombobox(pclass).ImeName:=StrImeName
      else
       Tdblookupcombobox(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is Tdbrichedit then
    begin
      if Tdbrichedit(pclass).ImeMode=imOpen then
       Tdbrichedit(pclass).ImeName:=StrImeName
      else
       Tdbrichedit(pclass).ImeMode:=imClose;
      exit;
    end;

    if pclass is TMaskEdit then
    begin
      if TMaskEdit(pclass).ImeMode=imOpen then
        TMaskEdit(pclass).ImeName:=StrImeName
      else
        TMaskEdit(pclass).ImeMode:=imClose;
      exit;
    end;
  end;
const
  DefaultImeName='中文 (简体) - 智能 ABC';
var
  i:integer;
  ChildControl:TControl;
  ConfigIni:tinifile;
  YouFormOrOTher:Twincontrol;
begin
  YouFormOrOTher:=YFormName;

  //读取保存的用户选择的输入法,用单元全局变量 StrImeName 保存
  //主窗体Create时调用该过程,此时UDM没被创建,故用"ExtractFilePath(application.ExeName)"代替AppPath变量
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    StrImeName:=ConfigIni.ReadString('输入法选择','默认中文输入法',DefaultImeName);
  finally
    ConfigIni.Free;
  end;

  //调用方法 JugeClassType(ChildControl) 更改窗体中控件的 ImeMode
  for i:=0 to YouFormOrOTher.ControlCount-1 do
  begin
   ChildControl:=YouFormOrOTher.Controls[i];
   JugeClassType(ChildControl);

   //如果控件包含控件,更改被包含的控件
   if ChildControl is TWinControl then ChangeYouFormAllControlIme(ChildControl as TWinControl);
  end;
end;

function SmoothLine(const strHistogram:string;const SmoothNum:byte;var Strings:TStrings;var AMin:single;var AMax:single):integer;
//strHistogram格式:'2 3 5.5 2.3'
//返回值:Strings的元素个数.调用时先判断返回值,大于零才有效
//SmoothNum:平滑处理的次数.次数越多曲线越光滑,但曲线偏离越多
//Strings:返回的点
var
  ls:TStrings;
  t,i,j:integer;
  cc:array of single;
  fdotData:single;
begin
  result:=0;
  AMin:=0;AMax:=0;

  if Strings = nil then Exit;
  ls:=TStringList.Create;
  t:=ExtractStrings([' '],[],Pchar(trim(strHistogram)),ls);
  if t=0 then begin ls.Free;exit;end;

  for i :=0  to t-1 do//如有无效点，则返回false
    if not trystrtofloat(ls[i],fdotData) then begin ls.Free;exit;end;

  setlength(cc,t);

  for i :=1  to SmoothNum do//平滑处理的次数
  begin
    for j:=2 to t-1 do
    begin
      cc[j-1]:=(strtofloat(ls[j-2])+strtofloat(ls[j-1])+strtofloat(ls[j]))/3;
    end;
    cc[0]:=strtofloat(ls[0]);
    cc[t-1]:=strtofloat(ls[t-1]);
    
    for j:=0 to t-1 do ls[j]:=floattostr(cc[j]);
  end;

  for j:=0 to t-1 do
  begin
    Strings.Add(ls[j]);
    if j=0 then begin AMin:=strtofloat(ls[j]);AMax:=strtofloat(ls[j]);end;
    if strtofloat(ls[j])<AMin then AMin:=strtofloat(ls[j]);
    if strtofloat(ls[j])>AMax then AMax:=strtofloat(ls[j]);
  end;
  ls.Free;

  result:=t;
end;

function GetNextValue(CurValue: string): string;
VAR
  iCurValue,i:INTEGER;
  rCurValue,sCurValue:STRING;
begin
    RESULT:='';
    for i :=length(CurValue) downto 1 do
    begin
      if not(CurValue[i] in ['0'..'9']) then
      begin
        if i=length(CurValue) then //最后一个字符为非数字
        begin
          exit;
        end;
        iCurValue:=strtoint(copy(CurValue,i+1,length(CurValue)-i));
        inc(iCurValue);
        rCurValue:=Format('%.'+inttostr(length(CurValue)-i)+'d', [iCurValue]);//iMaxFieldValue
        sCurValue:=copy(CurValue,1,i);
        result:=sCurValue + rCurValue;
        exit;
      end else
      begin
        if i=1 then //全部为数字的情况
        begin
          iCurValue:=strtoint(CurValue);
          inc(iCurValue);
          rCurValue:=Format('%.'+inttostr(length(CurValue))+'d', [iCurValue]);//iMaxFieldValue
          result:= rCurValue;
          exit;
        end;
      end;
    end;
end;

function GetFirstValue(CurValue: string): string;
VAR
  rCurValue,sCurValue:STRING;
  i:integer;
begin
    RESULT:='';
    for i :=length(CurValue) downto 1 do
    begin
      if not(CurValue[i] in ['0'..'9']) then
      begin
        if i=length(CurValue) then //最后一个字符为非数字
        begin
          exit;
        end;
        rCurValue:=Format('%.'+inttostr(length(CurValue)-i)+'d', [1]);//iMaxFieldValue
        sCurValue:=copy(CurValue,1,i);
        result:=sCurValue + rCurValue;
        exit;
      end else
      begin
        if i=1 then //全部为数字的情况
        begin
          rCurValue:=Format('%.'+inttostr(length(CurValue))+'d', [1]);//iMaxFieldValue
          result:= rCurValue;
          exit;
        end;
      end;
    end;
end;

function MakeDBConn:boolean;
var
  newconnstr,ss: string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;{, provider}
  ifIntegrated:boolean;//是否集成登录模式

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('连接数据库', '服务器', '');
  initialcatalog := Ini.ReadString('连接数据库', '数据库', '');
  ifIntegrated:=ini.ReadBool('连接数据库','集成登录模式',false);
  userid := Ini.ReadString('连接数据库', '用户', '');
  password := Ini.ReadString('连接数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  newconnstr :='';
  newconnstr := newconnstr + 'user id=' + UserID + ';';
  newconnstr := newconnstr + 'password=' + Password + ';';
  newconnstr := newconnstr + 'data source=' + datasource + ';';
  newconnstr := newconnstr + 'Initial Catalog=' + initialcatalog + ';';
  newconnstr := newconnstr + 'provider=' + 'SQLOLEDB.1' + ';';
  //Persist Security Info,表示ADO在数据库连接成功后是否保存密码信息
  //ADO缺省为True,ADO.net缺省为False
  //程序中会传ADOConnection信息给TADOLYQuery,故设置为True
  newconnstr := newconnstr + 'Persist Security Info=True;';
  if ifIntegrated then
    newconnstr := newconnstr + 'Integrated Security=SSPI;';
  try
    dm.ADOConnection1.Connected := false;
    dm.ADOConnection1.ConnectionString := newconnstr;
    dm.ADOConnection1.Connected := true;
    result:=true;
    LisConn:=newconnstr;
    gServerName:=datasource;
    gDbName:=initialcatalog;
  except
  end;
  if not result then
  begin
    ss:='服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '集成登录模式'+#2+'CheckListBox'+#2+#2+'0'+#2+'启用该模式,则用户及口令无需填写'+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接数据库','连接数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure LoadGroupName(const comboBox:TcomboBox;const ASel:string);
var
  adotemp3:tadoquery;
  tempstr:string;
begin
     adotemp3:=tadoquery.Create(nil);
     adotemp3.Connection:=DM.ADOConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:=ASel;
     adotemp3.Open;
     
     comboBox.Items.Clear;//加载前先清除comboBox项

     while not adotemp3.Eof do
     begin
      tempstr:=trim(adotemp3.Fields[0].AsString);

      comboBox.Items.Add(tempstr); //加载到comboBox

      adotemp3.Next;
     end;
     adotemp3.Free;
end;

procedure MakeDBGridColumnsAutoFixItsWidth(objDBGrid:TDBGrid);
//使dbGrid的内容自动适应他的宽度{如为DBGridEh则将改为：(objDBGrid:TDBGridEh);}
var
  cc:integer;
  i,tmpLength:integer;
  objDataSet:TAdoquery;
  aDgCLength:array of integer;
begin
  cc:=objDbGrid.Columns.Count-1;

  objDataSet:=TAdoquery.Create(nil);
  //objDataSet.Clone(objDBGrid.DataSource.DataSet);

  setlength(aDgCLength,cc+1);
  //取标题字段的长度
  for i:=0 to  cc do
  begin
    aDgCLength[i]:= length(objDbGrid.Columns[i].Title.Caption);
  end; 

  objDataSet.First;
  while not objDataSet.Eof do
  begin
    //取列中每个字段的长度
    for i:=0 to  cc do
    begin
      tmpLength:=length(objDataSet.Fields.Fields[i].AsString);
      if tmpLength>aDgCLength[i] then aDgCLength[i]:=tmpLength;
    end;
    objDataSet.Next;
  end; 

  for i:=0 to  cc do
  begin
    objDbGrid.Columns[i].Width:=aDgCLength[i]*8;
  end;
end;

function GetMaxCheckId(const ACombin_ID:string;const AServerDate:tdate):string;
var
  ini:tinifile;
  CheckDate,CheckId:string;
  sList:TStrings;
  i:integer;
begin
  result:='';
  
  if trim(ACombin_ID)='' then exit;

  ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  CheckDate:=ini.ReadString(ACombin_ID,'检查日期','');
  CheckId:=ini.ReadString(ACombin_ID,'联机号','');
  ini.Free;
  CheckId:=StringReplace(CheckId,'，',',',[rfReplaceAll,rfIgnoreCase]);
  sList:=TStringList.Create;
  ExtractStrings([','],[],PChar(CheckId),sList);
  CheckId:='';
  if datetostr(AServerDate)=CheckDate then
  begin
    for i :=0  to sList.Count-1 do
    begin
      CheckId:=CheckId+GetNextValue(sList[i])+',';
    end;
  end
  else begin
    for i :=0  to sList.Count-1 do
    begin
      CheckId:=CheckId+GetFirstValue(sList[i])+',';
    end;
  end;
  sList.Free;
  if(CheckId<>'')and(CheckId[length(CheckId)]=',')then CheckId:=copy(CheckId,1,length(CheckId)-1);
    
  result:=CheckId;
end;

function ExecSQLCmd(AConnectionString:string;ASQL:string):integer;
var
  Conn:TADOConnection;
  Qry:TAdoQuery;
begin
  Conn:=TADOConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.ConnectionString:=AConnectionString;
  Qry:=TAdoQuery.Create(nil);
  Qry.Connection:=Conn;
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Text:=ASQL;
  Try
    Result:=Qry.ExecSQL;
  except
    on E:Exception do
    begin
      MESSAGEDLG('函数ExecSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL,mtError,[mbOK],0);
      Result:=-1;
    end;
  end;
  Qry.Free;
  Conn.Free;
end;

function ScalarSQLCmd(AConnectionString:string;ASQL:string):string;
var
  Conn:TADOConnection;
  Qry:TAdoQuery;
begin
  Result:='';
  Conn:=TADOConnection.Create(nil);
  Conn.LoginPrompt:=false;
  Conn.ConnectionString:=AConnectionString;
  Qry:=TAdoQuery.Create(nil);
  Qry.Connection:=Conn;
  Qry.Close;
  Qry.SQL.Clear;
  Qry.SQL.Text:=ASQL;
  Try
    Qry.Open;
  except
    on E:Exception do
    begin
      MESSAGEDLG('函数ScalarSQLCmd失败:'+E.Message+'。错误的SQL:'+ASQL,mtError,[mbOK],0);
      Qry.Free;
      Conn.Free;
      exit;
    end;
  end;
  Result:=Qry.Fields[0].AsString;
  Qry.Free;
  Conn.Free;
end;

procedure combinchecklistbox(CheckListBox:TCheckListBox);//将组合项目号及名称导入CheckListBox中
const
  sqll='select id,name from combinitem where sysname='''+SYSNAME+''' order by id';
var
  adotemp3:tadoquery;
begin
     CheckListBox.Items.Clear;

     adotemp3:=tadoquery.Create(nil);
     adotemp3.Connection:=DM.ADOConnection1;
     adotemp3.Close;
     adotemp3.SQL.Clear;
     adotemp3.SQL.Text:=sqll;
     adotemp3.Open;
     while not adotemp3.Eof do
     begin
      CheckListBox.Items.Add(trim(adotemp3.fieldbyname('id').AsString)+'   '+adotemp3.fieldbyname('name').AsString);
      adotemp3.Next;
     end;
     adotemp3.Free;
end;

end.
