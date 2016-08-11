unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils, ADOLYGetcode,ShellAPI, FR_Class,Printers,
  FR_DSet, FR_DBSet,Jpeg,Chart,FR_Chart,Series,Math;

//==Ϊ��ͨ��������Ϣ����������״̬��������==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//
  
type TArCheckBoxValue = array of array [0..1] of integer;
 
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
    ADObasic: TADOQuery;
    ADOQuery2: TADOQuery;
    Timer1: TTimer;
    Label2: TLabel;
    frReport1: TfrReport;
    ado_print: TADOQuery;
    frDBDataSet1: TfrDBDataSet;
    CheckBox1: TCheckBox;
    SpeedButton6: TSpeedButton;
    CheckBox2: TCheckBox;
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
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure frReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure frReport1BeforePrint(Memo: TStringList; View: TfrView);
    procedure frReport1PrintReport;
    procedure SpeedButton6Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    procedure WriteProfile;
    procedure ReadConfig;
    procedure ReadIni;
    //==Ϊ��ͨ��������Ϣ����������״̬��������==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS��Ϣ������}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
    //==========================================//
  public
    procedure Draw_MVIS2035_Curve(Chart_XLB:TChart;const X1,Y1,X2,Y2,X1_MIN,Y1_MIN,X2_MIN,Y2_MIN,
                                                   X1_MAX,Y1_MAX,X2_MAX,Y2_MAX:Real);
    procedure updatechart(ChartHistogram:TChart;const strHistogram:string;const strEnglishName:string;const strXTitle:string);
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM;
var
  lsGroupShow:TStrings;
  ArCheckBoxValue:TArCheckBoxValue;

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
    n9.Checked:=TRUE;   //��ӡԤ��
    n8.Checked:=false;  //ֱ�Ӵ�ӡ
  end ELSE
  begin
    n9.Checked:=false;
    n8.Checked:=TRUE;
  end;//}

  //n41.Checked:=configini.ReadBool('Interface','ifRTTransData',true);
  CheckBox1.Checked:=configini.ReadBool('Interface','ifPreview',false);{��¼�Ƿ��ӡԤ��ģʽ}
  CheckBox2.Checked:=configini.ReadBool('Interface','ifPagination',false);{��¼�Ƿ����ҳ}
  //N64.Checked:=configini.ReadBool('Interface','ifCaseNoMerger',false);{��¼�Ƿ��ձ��Ա�����ϲ���ӡ}
  //n50.Checked:=configini.ReadBool('Interface','ifShowEnglish',true);
  //n36.Checked:=configini.ReadBool('Interface','ifShowMinValue',true);{��¼�Ƿ���ʾ��Ŀ��Сֵ}
  //n47.Checked:=configini.ReadBool('Interface','ifShowMaxValue',true);{��¼�Ƿ���ʾ��Ŀ���ֵ}
  //n49.Checked:=configini.ReadBool('Interface','ifShowUnit',true);{��¼�Ƿ���ʾ��Ŀ��λ}
  DBGrid1.Width:=configini.ReadInteger('Interface','gridBaseInfoWidth',460);{��¼������Ϣ����}
  Memo1.Height:=configini.ReadInteger('Interface','memoLogHeight',150);{��¼�����Ŀѡ���߶�}

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
  //��ϵͳ����
  SCSYDW:=ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''ϵͳ����'' and ReMark=''��Ȩʹ�õ�λ'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'δ��Ȩ��λ'���ܺ���ַ���
  //======����SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  MergePrintDays:=strtointdef(ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''ϵͳ����'' and ReMark=''��ʷ����ϲ���ӡ��ƫ������'' '),0);
  MakeTjDescDays:=strtointdef(ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''ϵͳ����'' and ReMark=''���������۵�ƫ������'' '),0);
  bAppendMakeTjDesc:=ScalarSQLCmd(LisConn,'select Name from CommCode where TypeName=''ϵͳ����'' and ReMark=''����׷������������'' ');

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  SmoothNum:=configini.ReadInteger('����','ֱ��ͼ�⻬����',0);
  CXZF:=configini.ReadString('����','�����������ַ�','����');
  if trim(CXZF)='' then CXZF:='����';
  MergePrintWorkGroupRange:=trim(configini.ReadString('����','"�������Ա�����ϲ�"�Ĺ����鷶Χ',''));
  MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,'��',',',[rfReplaceAll]);
  if MergePrintWorkGroupRange<>'' then
  begin
    MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,',',''',''',[rfReplaceAll]);
    MergePrintWorkGroupRange:=''''+MergePrintWorkGroupRange+'''';
  end;
  ifEnterGetCode:=configini.ReadBool('ѡ��','��д���˻�����Ϣʱ,ֱ�ӻس�����ȡ���',false);
  deptname_match:=configini.ReadString('ѡ��','�ͼ����ȡ���ƥ�䷽ʽ','');
  check_doctor_match:=configini.ReadString('ѡ��','�ͼ�ҽ��ȡ���ƥ�䷽ʽ','');
  LoginTime:=configini.ReadInteger('ѡ��','������¼���ڵ�ʱ��',30);

  TempFile_Common:=configini.ReadString('��ӡģ��','ͨ��ģ���ļ�','');
  TempFile_Group:=configini.ReadString('��ӡģ��','����ģ���ļ�','');
  WorkGroup_T1:=configini.ReadString('��ӡģ��','����ģ��1������','');
  TempFile_T1:=configini.ReadString('��ӡģ��','����ģ��1�ļ�','');
  WorkGroup_T2:=configini.ReadString('��ӡģ��','����ģ��2������','');
  TempFile_T2:=configini.ReadString('��ӡģ��','����ģ��2�ļ�','');
  WorkGroup_T3:=configini.ReadString('��ӡģ��','����ģ��3������','');
  TempFile_T3:=configini.ReadString('��ӡģ��','����ģ��3�ļ�','');  
  WorkGroup_T4:=configini.ReadString('��ӡģ��','����ģ��4������','');
  TempFile_T4:=configini.ReadString('��ӡģ��','����ģ��4�ļ�','');
  WorkGroup_T5:=configini.ReadString('��ӡģ��','����ģ��5������','');
  TempFile_T5:=configini.ReadString('��ӡģ��','����ģ��5�ļ�','');
  WorkGroup_T6:=configini.ReadString('��ӡģ��','����ģ��6������','');
  TempFile_T6:=configini.ReadString('��ӡģ��','����ģ��6�ļ�','');
  WorkGroup_T7:=configini.ReadString('��ӡģ��','����ģ��7������','');
  TempFile_T7:=configini.ReadString('��ӡģ��','����ģ��7�ļ�','');
  WorkGroup_T8:=configini.ReadString('��ӡģ��','����ģ��8������','');
  TempFile_T8:=configini.ReadString('��ӡģ��','����ģ��8�ļ�','');
  WorkGroup_T9:=configini.ReadString('��ӡģ��','����ģ��9������','');
  TempFile_T9:=configini.ReadString('��ӡģ��','����ģ��9�ļ�','');  

  ifHeightForItemNum:=configini.ReadBool('��ӡģ��','������Ŀ������ֽ�ų���',false);
  ItemRecNum:=configini.ReadInteger('��ӡģ��','ÿҳ��Ŀ�����ֵ',0);
  PageHeigth:=configini.ReadInteger('��ӡģ��','���泤��',2794);  
      
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
  adotemp3.SQL.Text:='select name from CommCode where TypeName=''�������'' group by name';
  adotemp3.Open;
  while not adotemp3.Eof do
  begin
    sWorkGroup:=sWorkGroup+#13+trim(adotemp3.fieldbyname('name').AsString);
    adotemp3.Next;
  end;
  adotemp3.Free;
  sWorkGroup:=trim(sWorkGroup);

  ss:='ֱ��ͼ�⻬����'+#2+'Edit'+#2+#2+'0'+#2+'ע:����Խ������Խ�⻬,������ƫ��Խ��'+#2+#3+
      '�����������ַ�'+#2+'Combobox'+#2+'����'+#13+'H L'+#2+'0'+#2+'ע:��1��2λΪ�������ַ�����3��4λΪ�������ַ�'+#2+#3+
      '"�������Ա�����ϲ�"�Ĺ����鷶Χ'+#2+'Edit'+#2+#2+'0'+#2+'���ϣ���ټ�����������ϲ�,����"�ټ���,������".�ձ�ʾ������'+#2+#3+
      '��д���˻�����Ϣʱ,ֱ�ӻس�����ȡ���'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '�ͼ����ȡ���ƥ�䷽ʽ'+#2+'Combobox'+#2+'ģ��ƥ��'+#13+'��ƥ��'+#13+'��ƥ��'+#13+'ȫƥ��'+#2+'1'+#2+#2+#3+
      '�ͼ�ҽ��ȡ���ƥ�䷽ʽ'+#2+'Combobox'+#2+'ģ��ƥ��'+#13+'��ƥ��'+#13+'��ƥ��'+#13+'ȫƥ��'+#2+'1'+#2+#2+#3+
      '���˻�����Ϣ����ʽ'+#2+'Combobox'+#2+'��ˮ��'+#13+'������'+#2+'1'+#2+#2+#3+
      '������¼���ڵ�ʱ��'+#2+'Edit'+#2+#2+'1'+#2+'ע:��ʾ�೤ʱ�����޲���,���Զ�������¼����(��λ:��)'+#2+#3+
      'ͨ��ģ���ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ���ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��1������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��1�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��2������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��2�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��3������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��3�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��4������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��4�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��5������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��5�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��6������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��6�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��7������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��7�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��8������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��8�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��9������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��9�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '������Ŀ������ֽ�ų���'+#2+'CheckListBox'+#2+#2+'2'+#2+'ע:����ͨ��ӡ�������ӡ��Ч'+#2+#3+
      'ÿҳ��Ŀ�����ֵ'+#2+'Edit'+#2+#2+'2'+#2+'ע:����Ŀ�����ڸ�ֵ,��ֽ�ų���Ϊ"���泤��"��ֵ.Ĭ��ֵΪ0'+#2+#3+
      '���泤��'+#2+'Edit'+#2+#2+'2'+#2+'Ĭ��ֵΪ2794,��λ:mm'+#2+#3;
  if ShowOptionForm('ѡ��','����'+#2+'ѡ��'+#2+'��ӡģ��',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
	  ReadIni;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
  configini.WriteInteger('Interface','gridBaseInfoWidth',DBGrid1.Width);{��¼������Ϣ����}
  if Memo1.Height<60 then Memo1.Height:=60;
  configini.WriteInteger('Interface','memoLogHeight',Memo1.Height);{��¼�����߶�}
  
  configini.WriteInteger('Interface','normalTimeRadio',RadioGroup1.ItemIndex);
  configini.WriteInteger('Interface','noprintTimeRadio',RadioGroup2.ItemIndex);
  configini.WriteInteger('Interface','ifPrintRadio',RadioGroup3.ItemIndex);

  configini.WriteBool('Interface','ifPreview',CheckBox1.Checked);{��¼�Ƿ��ӡԤ��ģʽ}
  configini.WriteBool('Interface','ifPagination',CheckBox2.Checked);{��¼�Ƿ����ҳ}

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
  if deptname_match='ȫƥ��' then tmpADOLYGetcode.GetCodePos:=gcAll
    else if deptname_match='��ƥ��' then tmpADOLYGetcode.GetCodePos:=gcLeft
      else if deptname_match='��ƥ��' then tmpADOLYGetcode.GetCodePos:=gcRight
        else tmpADOLYGetcode.GetCodePos:=gcNone;
  tmpADOLYGetcode.IfNullGetCode:=ifEnterGetCode;
  tmpADOLYGetcode.OpenStr:='select name as ���� from CommCode where TypeName=''����'' ';
  tmpADOLYGetcode.InField:='id,wbm,pym';
  tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
  tmpADOLYGetcode.ShowX:=left+tLabeledEdit(SENDER).Parent.Left+tLabeledEdit(SENDER).Left;
  tmpADOLYGetcode.ShowY:=top+22{��ǰ����������߶�}+21{��ǰ����˵��߶�}+tLabeledEdit(SENDER).Parent.Top+tLabeledEdit(SENDER).Parent.Parent.Top{Panel7}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Height;

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
  if check_doctor_match='ȫƥ��' then tmpADOLYGetcode.GetCodePos:=gcAll
    else if check_doctor_match='��ƥ��' then tmpADOLYGetcode.GetCodePos:=gcLeft
      else if check_doctor_match='��ƥ��' then tmpADOLYGetcode.GetCodePos:=gcRight
        else tmpADOLYGetcode.GetCodePos:=gcNone;
  tmpADOLYGetcode.IfNullGetCode:=ifEnterGetCode;
  tmpADOLYGetcode.OpenStr:='select name as ���� from worker';
  tmpADOLYGetcode.InField:='id,wbm,pinyin';
  tmpADOLYGetcode.InValue:=tLabeledEdit(sender).Text;
  tmpADOLYGetcode.ShowX:=left+tLabeledEdit(SENDER).Parent.Left+tLabeledEdit(SENDER).Left;
  tmpADOLYGetcode.ShowY:=top+22{��ǰ����������߶�}+21{��ǰ����˵��߶�}+tLabeledEdit(SENDER).Parent.Top+tLabeledEdit(SENDER).Parent.Parent.Top{Panel7}+tLabeledEdit(SENDER).Top+tLabeledEdit(SENDER).Height;

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
    MessageDlg((Sender as TSpeedButton).Caption+'(FrfSet.exe)��ʧ��!',mtError,[mbOK],0);
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  strsql22,strsql,strsql44,STRSQL45,STRSQL46,STRSQL47,STRSQL48,STRSQL49,STRSQL50: string;
  adotemp22:tadoquery;

  i,j:integer;
begin
  strsql:='select top 1000 patientname as ����,'+
        ' sex as �Ա�,'+
        ' age as ����,0 as ѡ��,caseno as ������,bedno as ����,deptname as �ͼ����,'+
        ' check_doctor as �ͼ�ҽ��,check_date as �������,'+
        ' report_date as ��������,'+
        ' operator as ������,diagnosetype as ���ȼ���,printtimes as ��ӡ����,'+
        ' flagetype as ��������,diagnose as �ٴ����,typeflagcase as �������,'+
        ' issure as ��ע,unid as Ψһ���,combin_id as ������, '+
        ' His_Unid as HisΨһ���,His_MzOrZy as His�����סԺ, '+
        ' WorkDepartment as ��������,WorkCategory as ����,WorkID as ����,ifMarry as ���,OldAddress as ����,Address as סַ,Telephone as �绰,WorkCompany as ������˾, '+
        ' Audit_Date as ���ʱ��,ifCompleted,checkid as ������,lsh as ��ˮ��,report_doctor as ����� '+
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
  if trim(LabeledEdit2.Text)<>'' then STRSQL22:=' patientname like ''%'+trim(LabeledEdit2.Text)+'%'' and '
  else STRSQL22:='';
  if trim(LabeledEdit3.Text)<>'' then STRSQL45:=' deptname='''+trim(LabeledEdit3.Text)+''' and '
  else STRSQL45:='';
  if trim(LabeledEdit4.Text)<>'' then STRSQL50:=' check_doctor='''+trim(LabeledEdit4.Text)+''' and '
  else STRSQL50:='';
  STRSQL47:=' isnull(report_doctor,'''')<>'''' ';//PEIS�ı��治�ڴ˴���ӡ��Ӧ�ų�
  STRSQL49:=' order by patientname ';
  ADObasic.Close;
  ADObasic.SQL.Clear;
  ADObasic.SQL.Add(strsql);
  ADObasic.SQL.Add(strsql44);
  ADObasic.SQL.Add(strsql46);
  ADObasic.SQL.Add(strsql48);
  ADObasic.SQL.Add(strsql22);
  ADObasic.SQL.Add(strsql45);
  ADObasic.SQL.Add(strsql50);
  ADObasic.SQL.Add(strsql47);
  ADObasic.SQL.Add(strsql49);
  ADObasic.Open;

  adotemp22:=tadoquery.Create(nil);
  adotemp22.clone(ADObasic);
  ArCheckBoxValue:=nil;
  setlength(ArCheckBoxValue,adotemp22.RecordCount);
  i:=0;
  while not adotemp22.Eof do
  begin
    for j :=0  to 1 do
    begin
      //�ö�ά������һ��Ҫ�и��ֶα�ʶΨһ�Ե�
      if j=0 then ArCheckBoxValue[I,j]:=0//adotemp22.FieldByName('ѡ��').AsInteger
      else ArCheckBoxValue[I,j]:=adotemp22.FieldByName('Ψһ���').AsInteger;
    end;
    adotemp22.Next;
    inc(i);
  end;
  adotemp22.Free;  
end;

procedure TfrmMain.ADObasicAfterScroll(DataSet: TDataSet);
var
  strsql11:string;
begin
  if not ADObasic.Active then exit;

  strsql11:='select '+
            '(case when photo is null then null else ''ͼ'' end) as ͼ,'+
            'combin_Name as �����Ŀ,name as ����,english_name as Ӣ����,itemvalue as ������,'+
            'min_value as ��Сֵ,max_value as ���ֵ,'+
            'unit as ��λ,'+
            'pkcombin_id as �����Ŀ��,itemid as ��Ŀ���,valueid as Ψһ��� '+
            ' from '+
            ifThen(ADObasic.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 '+
            ' order by pkcombin_id,printorder ';

  ADOQuery2.Close;
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Text:=strsql11;
  ADOQuery2.Parameters.ParamByName('pkunid').Value:=ADObasic.FieldByName('Ψһ���').AsInteger;
  try
    ADOQuery2.Open;
  except
  end;
end;

procedure TfrmMain.ADObasicAfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid1.Columns[0].Width:=42;//����
  dbgrid1.Columns[1].Width:=30;//�Ա�
  dbgrid1.Columns[2].Width:=30;//����
  dbgrid1.Columns[3].Width:=30;//ѡ��
  dbgrid1.Columns[4].Width:=65;//������
  dbgrid1.Columns[5].Width:=30;//����
  dbgrid1.Columns[6].Width:=60;//�ͼ����
  dbgrid1.Columns[7].Width:=55;//�ͼ�ҽ��
  dbgrid1.Columns[8].Width:=72;//�������
  dbgrid1.Columns[9].Width:=72;//��������
  dbgrid1.Columns[10].Width:=40;//��ˮ��
  dbgrid1.Columns[11].Width:=40;//������
  dbgrid1.Columns[12].Width:=42;//�����

end;

procedure TfrmMain.ADOQuery2AfterOpen(DataSet: TDataSet);
var
  adotemp11:tadoquery;
  strsql11:string;
begin
  //�ò�ͬ����ɫ���з����ʶ(�˹��̷���Ҫ��������ݼ���AfterOpen������)
  strsql11:='select '+
            'DISTINCT pkcombin_id '+
            'from '+
            ifThen(ADObasic.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 order by pkcombin_id ';

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=dm.ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:=strsql11;
  adotemp11.Parameters.ParamByName('pkunid').Value :=ADObasic.FieldByName('Ψһ���').AsInteger;
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
  
  dbgrid2.Columns[1].Width:=80;//�����Ŀ������
  dbgrid2.Columns[2].Width:=80;//������
  dbgrid2.Columns[3].Width:=50;//Ӣ����
  dbgrid2.Columns[4].Width:=70;//������
    
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
const
  CtrlState: array[Boolean] of Integer = (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);
var
  PrintTimes:integer;
  strPrintTimes:string;

  checkBox_check:boolean;
  iUNID,i:INTEGER;
begin
   //======================��ӡ������ˮ�ű仯��ɫ======================//
    if datacol=0 then //������,��Ϊ��ˮ�����п�������
    begin
      strPrintTimes:=ADObasic.fieldbyname('��ӡ����').AsString;
      PrintTimes:=strtointdef(strPrintTimes,0);
      IF PrintTimes<>0 then
      begin
        tdbgrid(sender).Canvas.Font.Color:=clred;
        tdbgrid(sender).DefaultDrawColumnCell(rect,datacol,column,state);
      end;
    end;
   //==========================================================================//

  if Column.Field.FieldName='ѡ��' then
  begin
    (sender as TDBGrid).Canvas.FillRect(Rect);
    checkBox_check:=false;
    iUNID:=(Sender AS TDBGRID).DataSource.DataSet.FieldByName('Ψһ���').AsInteger;
    for i :=0  to (Sender AS TDBGRID).DataSource.DataSet.RecordCount-1 do
    begin
      if ArCheckBoxValue[i,1]=iUNID then
      begin
        checkBox_check:=ArCheckBoxValue[i,0]=1;
        break;
      end;
    end;//}
    DrawFrameControl((sender as TDBGrid).Canvas.Handle,Rect, DFC_BUTTON, CtrlState[checkBox_check]);
  end else (sender as TDBGrid).DefaultDrawColumnCell(Rect,DataCol,Column,State);

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
  //======================�����������ο���Χʱ�仯��ɫ======================//
  if (datacol=4) then
  begin
    ItemChnName:=trim(ADOQuery2.fieldbyname('��Ŀ���').AsString);
    cur_value:=trim(ADOQuery2.fieldbyname('������').AsString);
    min_value:=trim(ADOQuery2.fieldbyname('��Сֵ').AsString);
    max_value:=trim(ADOQuery2.fieldbyname('���ֵ').AsString);

    adotemp22:=Tadoquery.Create(nil);
    adotemp22.Connection:=dm.ADOConnection1;
    adotemp22.Close;
    adotemp22.SQL.Clear;
    adotemp22.SQL.Text:='select dbo.uf_ValueAlarm('''+ItemChnName+''','''+min_value+''','''+max_value+''','''+cur_value+''') as ifValueAlarm';
    try//uf_ValueAlarm�е�convert���������׳��쳣
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

  //�ò�ͬ����ɫ���з����ʶ
  if (datacol=1)and(lsGroupShow.Count>1) then//�����������������ɫ���б�ʶ
  begin
    sGroup:=tdbgrid(sender).DataSource.DataSet.FieldByName('�����Ŀ��').AsString;
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

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  strsql,strsql44,STRSQL47: string;
  adotemp11:TAdoquery;
begin
  strsql:='select count(*) as RecNum '+
        ' from view_Chk_Con_All where ';
  if RadioGroup2.ItemIndex=1 then
    strsql44:=' CONVERT(CHAR(10),check_date,121)=CONVERT(CHAR(10),GETDATE(),121) and '
  else if RadioGroup2.ItemIndex=2 then
    strsql44:=' check_date>GETDATE()-3 and '
  else if RadioGroup2.ItemIndex=3 then
    strsql44:=' check_date>GETDATE()-7 and '
  else if RadioGroup2.ItemIndex=4 then
    strsql44:=' check_date>GETDATE()-30 and '
  else strsql44:=' ';
  STRSQL47:=' isnull(printtimes,0)<=0 and isnull(report_doctor,'''')<>'''' ';
  adotemp11:=TAdoquery.Create(nil);
  adotemp11.Connection:=dm.ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Add(strsql);
  adotemp11.SQL.Add(strsql44);
  adotemp11.SQL.Add(strsql47);
  adotemp11.Open;
  Label2.Caption:=adotemp11.fieldbyname('RecNum').AsString;
  adotemp11.Free;
end;

procedure TfrmMain.Label2Click(Sender: TObject);
var
  strsql,strsql44,STRSQL47,STRSQL49: string;
  adotemp22:tadoquery;
  i,j:integer;
begin
  strsql:='select top 1000 patientname as ����,'+
        ' sex as �Ա�,'+
        ' age as ����,0 as ѡ��,caseno as ������,bedno as ����,deptname as �ͼ����,'+
        ' check_doctor as �ͼ�ҽ��,check_date as �������,'+
        ' report_date as ��������,'+
        ' operator as ������,diagnosetype as ���ȼ���,printtimes as ��ӡ����,'+
        ' flagetype as ��������,diagnose as �ٴ����,typeflagcase as �������,'+
        ' issure as ��ע,unid as Ψһ���,combin_id as ������, '+
        ' His_Unid as HisΨһ���,His_MzOrZy as His�����סԺ, '+
        ' WorkDepartment as ��������,WorkCategory as ����,WorkID as ����,ifMarry as ���,OldAddress as ����,Address as סַ,Telephone as �绰,WorkCompany as ������˾, '+
        ' Audit_Date as ���ʱ��,ifCompleted,checkid as ������,lsh as ��ˮ��,report_doctor as ����� '+
        ' from view_Chk_Con_All where ';
  if RadioGroup2.ItemIndex=1 then
    strsql44:=' CONVERT(CHAR(10),check_date,121)=CONVERT(CHAR(10),GETDATE(),121) and '
  else if RadioGroup2.ItemIndex=2 then
    strsql44:=' check_date>GETDATE()-3 and '
  else if RadioGroup2.ItemIndex=3 then
    strsql44:=' check_date>GETDATE()-7 and '
  else if RadioGroup2.ItemIndex=4 then
    strsql44:=' check_date>GETDATE()-30 and '
  else strsql44:=' ';
  STRSQL47:=' isnull(printtimes,0)<=0 and isnull(report_doctor,'''')<>'''' ';
  STRSQL49:=' order by patientname ';
  ADObasic.Close;
  ADObasic.SQL.Clear;
  ADObasic.SQL.Add(strsql);
  ADObasic.SQL.Add(strsql44);
  ADObasic.SQL.Add(strsql47);
  ADObasic.SQL.Add(strsql49);
  ADObasic.Open;

  adotemp22:=tadoquery.Create(nil);
  adotemp22.clone(ADObasic);
  ArCheckBoxValue:=nil;
  setlength(ArCheckBoxValue,adotemp22.RecordCount);
  i:=0;
  while not adotemp22.Eof do
  begin
    for j :=0  to 1 do
    begin
      //�ö�ά������һ��Ҫ�и��ֶα�ʶΨһ�Ե�
      if j=0 then ArCheckBoxValue[I,j]:=0//adotemp22.FieldByName('ѡ��').AsInteger
      else ArCheckBoxValue[I,j]:=adotemp22.FieldByName('Ψһ���').AsInteger;
    end;
    adotemp22.Next;
    inc(i);
  end;
  adotemp22.Free;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
var
  strsqlPrint:string;
  sUnid,sCombin_Id:string;
  iIfCompleted:integer;

  //���ձ��Ա�����ĺϲ�������ӡ��� ����
  sPatientname,sSex,sAge:string;
  //===============================

  adotemp22:tadoquery;
  ifSelect:boolean;
  i:integer;
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  adotemp22:=tadoquery.Create(nil);
  adotemp22.clone(ADObasic);
  while not adotemp22.Eof do
  begin
    ifSelect:=false;
    for i :=0  to adotemp22.RecordCount-1 do//ѭ��ArCheckBoxValue
    begin
      if (ArCheckBoxValue[i,1]=adotemp22.fieldbyname('Ψһ���').AsInteger)and(ArCheckBoxValue[i,0]=1) then
      begin
        ifSelect:=true;
        break;
      end;
    end;
    if not ifSelect then begin adotemp22.Next;continue;end;//���δѡ��������

    sUnid:=adotemp22.fieldbyname('Ψһ���').AsString;//��ֹ�����ӡ�����Ͻ�����Ƶ���һ��������Ϣ�ϡ���д����ǰ��
    sCombin_Id:=adotemp22.FieldByName('������').AsString;
    iIfCompleted:=adotemp22.FieldByName('ifCompleted').AsInteger;

    sPatientname:=trim(adotemp22.fieldbyname('����').AsString);
    sSex:=adotemp22.fieldbyname('�Ա�').AsString;
    sAge:=adotemp22.fieldbyname('����').AsString;

    if (sCombin_Id=WorkGroup_T1)
      and frReport1.LoadFromFile(TempFile_T1) then//����ģ���ļ��ǲ����ִ�Сд��.���ַ���������ʧ��
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
    if frReport1.LoadFromFile(TempFile_Common) then
    begin
    end else
    if not frReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_cur.frf') then
    begin
      showmessage('����Ĭ��ͨ�ô�ӡģ��report_cur.frfʧ�ܣ�������:ϵͳ����->ѡ��->��ӡģ��');
      //exit;
      adotemp22.Next;
      continue;
    end;

    {//if (N64.Checked)and(sPatientname<>'') then//���ձ��Ա�����ϲ���ӡ//ֻ�д�������ʱ�źϲ�
      strsqlPrint:='select cv.itemid as ��Ŀ����,cv.name as ����,cv.english_name as Ӣ����,'+
            ' cv.itemvalue as ������,'+
            ' cv.min_value as ��Сֵ,cv.max_value as ���ֵ,dbo.uf_Reference_Ranges(cv.min_value,cv.max_value) as �ο���Χ,'+
            ' cv.unit as ��λ,'+
            ' min(cv.printorder) as ��ӡ���,'+
            ' min(cv.pkcombin_id) as �����Ŀ��, '+
            ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10 '+
            ' from chk_valu cv '+
            ' inner join chk_con cc on cv.pkunid=cc.unid '+
            ' left join clinicchkitem cci on cci.itemid=cv.itemid '+
            ' where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+
            ''') and cv.issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
            ' and cci.sysname='''+SYSNAME+''' '+
            ' group by cv.itemid,cv.name,cv.english_name,cv.itemvalue,cv.min_value,cv.max_value,cv.unit, '+
            ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10 '+
            ' order by �����Ŀ��,��ӡ��� '
    else//}
      strsqlPrint:='select itemid as ��Ŀ����,name as ����,english_name as Ӣ����,'+
            ' itemvalue as ������,'+
            ' min_value as ��Сֵ,max_value as ���ֵ,dbo.uf_Reference_Ranges(min_value,max_value) as �ο���Χ,'+
            ' unit as ��λ,'+
            ' min(printorder) as ��ӡ���,'+
            ' min(pkcombin_id) as �����Ŀ��, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' from '+
            ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
            ' where pkunid='+sUnid+
            ' and issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
            ' group by itemid,name,english_name,itemvalue,min_value,max_value,unit, '+
            ' Reserve1,Reserve2,Dosage1,Dosage2,Reserve5,Reserve6,Reserve7,Reserve8,Reserve9,Reserve10 '+
            ' order by �����Ŀ��,��ӡ��� ';
    ado_print.Close;
    ado_print.SQL.Clear;
    ado_print.SQL.Text:=strsqlPrint;
    ado_print.Open;
    if ADO_print.RecordCount=0 then begin adotemp22.Next;continue;end;//exit;

    if ifHeightForItemNum and (ADO_print.RecordCount>ItemRecNum) then
      //frReport1.Pages.Pages[0].pgsize:=255;//.pgHeight:=70;
      //frReport1.Pages.Pages[0].pgHeight:=70;
      frReport1.Pages[0].ChangePaper($100,2100,PageHeigth,-1,poPortrait);  //1 inch=2.54 cm

      if CheckBox1.Checked then  //Ԥ��ģʽ
        frReport1.ShowReport
      else  //ֱ�Ӵ�ӡģʽ
      begin
        if frReport1.PrepareReport then frReport1.PrintPreparedReport('', 1, True, frAll);
      end;

    adotemp22.Next;
  end;
  adotemp22.Free;
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
      ItemChnName:=trim(ADO_print.fieldbyname('��Ŀ����').AsString);
      cur_value:=trim(ADO_print.fieldbyname('������').AsString);
      min_value:=trim(ADO_print.fieldbyname('��Сֵ').AsString);
      max_value:=trim(ADO_print.fieldbyname('���ֵ').AsString);

      adotemp22:=Tadoquery.Create(nil);
      adotemp22.Connection:=dm.ADOConnection1;
      adotemp22.Close;
      adotemp22.SQL.Clear;
      adotemp22.SQL.Text:='select dbo.uf_ValueAlarm('''+ItemChnName+''','''+min_value+''','''+max_value+''','''+cur_value+''') as ifValueAlarm';
      try//uf_ValueAlarm�е�convert���������׳��쳣
        adotemp22.Open;
        i:=adotemp22.fieldbyname('ifValueAlarm').AsInteger;
      except
        i:=0;
      end;
      adotemp22.Free;
      if i=1 then
        ParValue := TRIM(COPY(CXZF,3,2))
      else if i=2 then
        ParValue := TRIM(COPY(CXZF,1,2))
      else ParValue:='';
    END;

    if parname='��ӡ��' then ParValue:=operator_name;
    if parname='������˾' then ParValue:=trim(ADObasic.fieldbyname('������˾').AsString);
    if parname='����' then ParValue:=trim(ADObasic.fieldbyname('����').AsString);
    if parname='�Ա�' then ParValue:=trim(ADObasic.fieldbyname('�Ա�').AsString);
    if parname='�������' then ParValue:=ADObasic.fieldbyname('�������').AsDateTime;
    if parname='����' then ParValue:=trim(ADObasic.fieldbyname('����').AsString);
    if parname='���' then ParValue:=trim(ADObasic.fieldbyname('���').AsString);
    if parname='����' then ParValue:=trim(ADObasic.fieldbyname('����').AsString);
    if parname='����' then ParValue:=trim(ADObasic.fieldbyname('����').AsString);
    if parname='סַ' then ParValue:=trim(ADObasic.fieldbyname('סַ').AsString);
    if parname='�绰' then ParValue:=trim(ADObasic.fieldbyname('�绰').AsString);
end;

procedure TfrmMain.frReport1BeforePrint(Memo: TStringList; View: TfrView);
var
  adotemp11:tadoquery;
  unid,printtimes,iIfCompleted:integer;
  
  strsqlPrint,strEnglishName,strHistogram,strXTitle:string;
  MS:tmemorystream;
  tempjpeg:TJPEGImage;
  Chart_ZFT:TChart;

  //Ѫ�������start
  Reserve8_1,Reserve8_2:single;//�б���
  mPa_1,mPa_2:string;//ճ��
  mPa_min_1,mPa_min_2:string;//ճ��
  mPa_max_1,mPa_max_2:string;//ճ��
  Chart_XLB:TChart;
  //Ѫ�������stop
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('Ψһ���').AsInteger;
  printtimes:=ADObasic.fieldbyname('��ӡ����').AsInteger;
  iIfCompleted:=ADObasic.FieldByName('ifCompleted').AsInteger;

  //����Ѫ�������ߡ�ֱ��ͼ��ɢ��ͼ start
  if(View is TfrChartView)and(pos('CURVE',uppercase(View.Name))>0)then
  begin
    View.Visible:=false;
    strsqlPrint:='select Reserve8,itemValue,Min_Value,Max_Value '+
       ' from '+
       ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu') +
       ' where pkunid=:pkunid '+
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
      
      Reserve8_1:=adotemp11.fieldbyname('Reserve8').AsFloat;//�б���
      mPa_1:=adotemp11.fieldbyname('itemValue').AsString;//ճ��
      mPa_min_1:=adotemp11.fieldbyname('Min_Value').AsString;//ճ��
      mPa_max_1:=adotemp11.fieldbyname('Max_Value').AsString;//ճ��
      adotemp11.Next;
      Reserve8_2:=adotemp11.fieldbyname('Reserve8').AsFloat;//�б���
      mPa_2:=adotemp11.fieldbyname('itemValue').AsString;//ճ��
      mPa_min_2:=adotemp11.fieldbyname('Min_Value').AsString;//ճ��
      mPa_max_2:=adotemp11.fieldbyname('Max_Value').AsString;//ճ��
      Draw_MVIS2035_Curve(Chart_XLB,Reserve8_1,strtofloatdef(mPa_1,-1),Reserve8_2,strtofloatdef(mPa_2,-1),
                          Reserve8_1,strtofloatdef(mPa_min_1,-1),Reserve8_2,strtofloatdef(mPa_min_2,-1),
                          Reserve8_1,strtofloatdef(mPa_max_1,-1),Reserve8_2,strtofloatdef(mPa_max_2,-1));
      TfrChartView(View).Assignchart(Chart_XLB);//ָ��ͳ��ͼ�oFastReport

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
       ' where pkunid=:pkunid '+
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
      TfrChartView(View).Assignchart(Chart_ZFT);//ָ��ͳ��ͼ�oFastReport

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
       ' where pkunid=:pkunid '+
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
  //����Ѫ�������ߡ�ֱ��ͼ��ɢ��ͼ stop

  if printtimes>0 then exit;

  ExecSQLCmd(LisConn,'update chk_con set printtimes='+inttostr(printtimes+1)+' where unid='+inttostr(unid));

  //adobasic.Refresh;//��ӡ��Ҫ��ʾ��ɫ
end;

procedure TfrmMain.frReport1PrintReport;
var
  unid:integer;
begin
  if not ADObasic.Active then exit;
  if not ADObasic.RecordCount=0 then exit;

  unid:=ADObasic.fieldbyname('Ψһ���').AsInteger;
  
  ExecSQLCmd(LisConn,'insert into pix_tran (pkunid,Reserve1,Reserve2,OpType) values ('+inttostr(unid)+','''+operator_name+''',''Class_Print'',''Lab'')');
end;

procedure TfrmMain.Draw_MVIS2035_Curve(Chart_XLB: TChart; const X1, Y1, X2,
  Y2, X1_MIN, Y1_MIN, X2_MIN, Y2_MIN, X1_MAX, Y1_MAX, X2_MAX,
  Y2_MAX: Real);
//Ҫ����Chart����ͼƬ,�ʸú�������д��DLL��                                    
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
  Chart_XLB.BackWall.Pen.Visible:=false;//����top��right�Ŀ�
  Chart_XLB.BottomAxis.Grid.Visible:=false;//���غ����GRID��
  Chart_XLB.LeftAxis.Grid.Visible:=false;//���������GRID��
  Chart_XLB.Title.Font.Color:=clBlack;//Ĭ����clBlue
  Chart_XLB.Title.Text.Clear;
  Chart_XLB.Title.Text.Add('ѪҺճ����������');
  Chart_XLB.BottomAxis.Title.Caption:='�б���(1/s)';
  Chart_XLB.LeftAxis.Title.Caption:='ճ��(mPa.s)';
  //for k:=Chart2.SeriesCount-1 downto 0 do Chart2.Series[k].Clear;//��̬������Chart,�϶�ûSerie

  Series_Val:=TFastLineSeries.Create(Chart_XLB);
  Series_Val.ParentChart :=Chart_XLB;
  Series_Val.SeriesColor:=clBlack;//����������ɫ
  Chart_XLB.AddSeries(Series_Val);

  Series_Min:=TFastLineSeries.Create(Chart_XLB);
  Series_Min.ParentChart :=Chart_XLB;
  Series_Min.SeriesColor:=clBtnFace;//����������ɫ
  Series_Min.LinePen.Style:=psDashDotDot;
  Chart_XLB.AddSeries(Series_Min);

  Series_Max:=TFastLineSeries.Create(Chart_XLB);
  Series_Max.ParentChart :=Chart_XLB;
  Series_Max.SeriesColor:=clBtnFace;//����������ɫ
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
  Chart_XLB.LeftAxis.Maximum:=MaxInt;//����������,�¾��п��ܱ���(��Сֵ����=<���ֵ)
  Chart_XLB.LeftAxis.Minimum:=rMin-10*(rMax-rMin)/100;//������10%�Ŀ�
  Chart_XLB.LeftAxis.Maximum:=rMax-10*(rMax-rMin)/100;//�������10%,����ͼ�βŻ��Ӵ�����Ĳ��
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
    ChartHistogram.BackWall.Pen.Visible:=false;//����top��right�Ŀ�
    ChartHistogram.BottomAxis.Axis.Width:=1;
    ChartHistogram.LeftAxis.Axis.Width:=1;
    ChartHistogram.BottomAxis.Grid.Visible:=false;//���غ����GRID��
    ChartHistogram.LeftAxis.Grid.Visible:=false;//���������GRID��
    ChartHistogram.BottomAxis.Labels:=false;//����X��Ŀ̶�
    ChartHistogram.LeftAxis.Labels:=false;//����Y��Ŀ̶�
    ChartHistogram.Title.Font.Color:=clBlack;//Ĭ����clBlue
    ChartHistogram.Title.Text.Clear;
    for k:=ChartHistogram.SeriesCount-1 downto 0 do ChartHistogram.Series[k].Clear;
    sList:=TStringList.Create;
    if SmoothLine(strHistogram,SmoothNum,sList,fMin,fMax)=0 then
    begin
      ChartHistogram.AxisVisible:=false;//���ϵ�TitleҲ��֮����
      sList.Free;
      exit;
    end;

    ChartHistogram.Title.Text.Text:=strEnglishName;
    ChartHistogram.BottomAxis.Title.Caption:=strXTitle;
    ChartHistogram.LeftAxis.Automatic:=false;
    ChartHistogram.LeftAxis.Maximum:=MaxInt;//����������,�¾��п��ܱ���(��Сֵ����=<���ֵ)
    ChartHistogram.LeftAxis.Minimum:=fMin-5*(fMax-fMin)/100;//���������ֱ���5%�Ŀ�
    ChartHistogram.LeftAxis.Maximum:=fMax+5*(fMax-fMin)/100;

    Series_Val:=TFastLineSeries.Create(ChartHistogram);
    Series_Val.ParentChart :=ChartHistogram;
    Series_Val.SeriesColor:=clBlack;//����������ɫ
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
  frGH: TfrBandView;//����ͷ

  sUnid,sReport_Doctor:string;

  {//���ձ��Ա�����ĺϲ�������ӡ��� ����
  adotemp22:tadoquery;
  SelSql:string;
  unid,printtimes,iIfCompleted:integer;
  report_doctor,sql,ss,sPrinttimes,sReport_doctor2:string;
  sPatientname,sSex,sAge,sMergePrintWorkGroupRange:string;
  //===============================//}

  adotemp22:tadoquery;
  ifSelect:boolean;
  i,iIfCompleted:integer;  
begin
  if not ifhaspower(sender,powerstr_js_main) then exit;

  if not ADObasic.Active then exit;
  if ADObasic.RecordCount=0 then exit;

  adotemp22:=tadoquery.Create(nil);
  adotemp22.clone(ADObasic);
  while not adotemp22.Eof do
  begin
    ifSelect:=false;
    for i :=0  to adotemp22.RecordCount-1 do//ѭ��ArCheckBoxValue
    begin
      if (ArCheckBoxValue[i,1]=adotemp22.fieldbyname('Ψһ���').AsInteger)and(ArCheckBoxValue[i,0]=1) then
      begin
        ifSelect:=true;
        break;
      end;
    end;
    if not ifSelect then begin adotemp22.Next;continue;end;//���δѡ��������
    
    sUnid:=adotemp22.fieldbyname('Ψһ���').AsString;//��ֹ�����ӡ�����Ͻ�����Ƶ���һ��������Ϣ�ϡ���д����ǰ��
    sReport_Doctor:=trim(adotemp22.FieldByName('�����').AsString);
    iIfCompleted:=adotemp22.FieldByName('ifCompleted').AsInteger;

    //sPatientname:=trim(adotemp22.fieldbyname('����').AsString);
    //sSex:=adotemp22.fieldbyname('�Ա�').AsString;
    //sAge:=adotemp22.fieldbyname('����').AsString;

    if frReport1.LoadFromFile(TempFile_Group) then
    begin
    end else
    if not frReport1.LoadFromFile(ExtractFilePath(application.ExeName)+'report_Cur_group.frf') then
    begin
      showmessage('����Ĭ�Ϸ����ӡģ��report_Cur_group.frfʧ�ܣ�������:ϵͳ����->ѡ��->��ӡģ��');
      adotemp22.Next;
      continue;
      //exit;
    end;

    frGH := TfrBandView(frReport1.FindObject('GroupHeader1'));
    if(frGH=nil)then
    begin
      showmessage('����ģ����û�з���GroupHeader1');
      adotemp22.Next;
      continue;
      //exit;
    end;

    if CheckBox2.Checked then//�����ҳ
      frGH.Prop['formnewpage'] := True
    else
      frGH.Prop['formnewpage'] := false;

    {if MergePrintWorkGroupRange<>'' then
      sMergePrintWorkGroupRange:=' and cc.combin_id in ('+MergePrintWorkGroupRange+') ';
    if (N64.Checked)and(sPatientname<>'') then//���ձ��Ա�����ϲ���ӡ//ֻ�д�������ʱ�źϲ�
      strsqlPrint:='select cv.combin_name as name,cv.name as ����,cv.english_name as Ӣ����,cv.itemvalue as ������,'+//combinitem.name
      'cv.unit as ��λ,cv.min_value as ��Сֵ,'+
      'cv.max_value as ���ֵ,dbo.uf_Reference_Ranges(cv.min_value,cv.max_value) as �ο���Χ, '+
      ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10, '+
      ' cv.itemid as ��Ŀ���� '+//cci.Reserve3,
      ' from chk_valu cv '+//combinitem,�������Ŀ��ȡ�����Ŀ���ƣ��п��ܴ�����ˣ�ȡ����������
      ' inner join chk_con cc on cv.pkunid=cc.unid '+
      ' left join clinicchkitem cci on cci.itemid=cv.itemid '+
      ' where Patientname='''+sPatientname+''' and isnull(sex,'''')='''+sSex+''' and dbo.uf_GetAgeReal(age)=dbo.uf_GetAgeReal('''+sAge+
      ''') and cv.issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
      ' and cci.sysname='''+SYSNAME+''' '+
      sMergePrintWorkGroupRange+
      ' order by cv.pkcombin_id,cv.printorder '//�����Ŀ��,��ӡ��� '
    else//}
      strsqlPrint:='select cv.combin_name as name,cv.name as ����,cv.english_name as Ӣ����,cv.itemvalue as ������,'+
      'cv.unit as ��λ,cv.min_value as ��Сֵ,'+
      'cv.max_value as ���ֵ,dbo.uf_Reference_Ranges(cv.min_value,cv.max_value) as �ο���Χ, '+
      ' cv.Reserve1,cv.Reserve2,cv.Dosage1,cv.Dosage2,cv.Reserve5,cv.Reserve6,cv.Reserve7,cv.Reserve8,cv.Reserve9,cv.Reserve10, '+
      ' cv.itemid as ��Ŀ���� '+//cci.Reserve3,
      ' from '+
      ifThen(iIfCompleted=1,'chk_valu_bak','chk_valu')+
      ' cv '+
      ' left join clinicchkitem cci on cci.itemid=cv.itemid '+
      ' where cv.pkunid='+sUnid+
      ' and cv.issure=1 and ltrim(rtrim(isnull(itemvalue,'''')))<>'''' '+
      ' order by cv.pkcombin_id,cv.printorder ';//�����Ŀ��,��ӡ��� '
    ADO_print.Close;
    ADO_print.SQL.Clear;
    ADO_print.SQL.Text:=strsqlPrint;
    ADO_print.Open;
    //if ADO_print.RecordCount=0 then exit;
    if ADO_print.RecordCount=0 then begin adotemp22.Next;continue;end;//exit;

    {//���ձ��Ա�����ĺϲ�������ӡ���
    if (N64.Checked)and(sPatientname<>'') then
    begin
      SelSql:='select unid,printtimes,report_doctor from chk_con where Patientname='''+sPatientname+''' and sex='''+sSex+''' and age='''+sAge+''' and isnull(Patientname,'''')<>'''' and unid<>'+sUnid;
      adotemp22:=tadoquery.Create(nil);
      adotemp22.Connection:=DM.ADOConnection1;
      adotemp22.Close;
      adotemp22.SQL.Clear;
      adotemp22.SQL.Text:=SelSql;
      adotemp22.Open;
      while not adotemp22.Eof do
      begin
        unid:=adotemp22.fieldbyname('unid').AsInteger;
        printtimes:=adotemp22.fieldbyname('printtimes').AsInteger;
        report_doctor:=trim(adotemp22.fieldbyname('report_doctor').AsString);

        if printtimes=0 then sPrinttimes:=' printtimes='+inttostr(printtimes+1) else sPrinttimes:='';//�޸Ĵ�ӡ����
        if(ifAutoCheck)and(report_doctor='') then sReport_doctor2:=' report_doctor='''+operator_name+''',Audit_Date=getdate() ' else sReport_doctor2:='';//�޸������

        if(sPrinttimes='')and(sReport_doctor2='')then begin adotemp22.Next;continue; end;
        if(sPrinttimes<>'')and(sReport_doctor2<>'')then ss:=',' else ss:='';

        sql:='update chk_con set '+sPrinttimes+ss+sReport_doctor2+' where unid='+inttostr(unid);
        ExecSQLCmd(LisConn,sql);

        adotemp22.Next;
      end;
      adotemp22.Free;
    end;
    //==========================}

    if ifHeightForItemNum and (ADO_print.RecordCount>ItemRecNum) then
      //frReport1.Pages.Pages[0].pgsize:=255;//.pgHeight:=70;
      //frReport1.Pages.Pages[0].pgHeight:=70;
      frReport1.Pages[0].ChangePaper($100,2100,PageHeigth,-1,poPortrait);  //1 inch=2.54 cm

    if CheckBox1.Checked then  //Ԥ��ģʽ
      frReport1.ShowReport
    else  //ֱ�Ӵ�ӡģʽ
    begin
      if frReport1.PrepareReport then frReport1.PrintPreparedReport('', 1, True, frAll);
    end;

    adotemp22.Next;
  end;
  adotemp22.Free;
end;

procedure TfrmMain.DBGrid1CellClick(Column: TColumn);
var
  iUNID,i:INTEGER;
begin
  if Column.Field.FieldName <>'ѡ��' then exit;

  iUNID:=DBGrid1.DataSource.DataSet.FieldByName('Ψһ���').AsInteger;
  for i :=0  to DBGrid1.DataSource.DataSet.RecordCount-1 do
  begin
    if ArCheckBoxValue[i,1]=iUNID then
    begin
      ArCheckBoxValue[i,0]:=ifThen(ArCheckBoxValue[i,0]=1,0,1);
      DBGrid1.Refresh;//����DBGrid1DrawColumnCell�¼�
      break;
    end;
  end;//}
end;

end.
