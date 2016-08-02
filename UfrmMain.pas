unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils, ADOLYGetcode,ShellAPI;

//==Ϊ��ͨ��������Ϣ����������״̬��������==//
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
    //==Ϊ��ͨ��������Ϣ����������״̬��������==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS��Ϣ������}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
    n9.Checked:=TRUE;   //��ӡԤ��
    n8.Checked:=false;  //ֱ�Ӵ�ӡ
  end ELSE
  begin
    n9.Checked:=false;
    n8.Checked:=TRUE;
  end;//}

  //n41.Checked:=configini.ReadBool('Interface','ifRTTransData',true);
  //N25.Checked:=configini.ReadBool('Interface','ifPagination',false);{��¼�Ƿ����ҳ}
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
  ifNoResultPrint:=configini.ReadBool('����','�����޼�������ӡ',false);
  MergePrintWorkGroupRange:=trim(configini.ReadString('����','"�������Ա�����ϲ�"�Ĺ����鷶Χ',''));
  MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,'��',',',[rfReplaceAll]);
  if MergePrintWorkGroupRange<>'' then
  begin
    MergePrintWorkGroupRange:=StringReplace(MergePrintWorkGroupRange,',',''',''',[rfReplaceAll]);
    MergePrintWorkGroupRange:=''''+MergePrintWorkGroupRange+'''';
  end;
  ifAutoCheck:=configini.ReadBool('ѡ��','��ӡʱ�Զ���˼��鵥',false);
  ifEnterGetCode:=configini.ReadBool('ѡ��','��д���˻�����Ϣʱ,ֱ�ӻس�����ȡ���',false);
  deptname_match:=configini.ReadString('ѡ��','�ͼ����ȡ���ƥ�䷽ʽ','');
  check_doctor_match:=configini.ReadString('ѡ��','�ͼ�ҽ��ȡ���ƥ�䷽ʽ','');
  ifDoctorStation:=configini.ReadBool('ѡ��','����ʾ����˵ļ��鵥',false);
  ShowSelfDJ:=configini.ReadBool('ѡ��','����ʾ��¼���������鵥',false);
  ifGetInfoFromHis:=configini.ReadBool('ѡ��','��ȡHIS�еĲ��˻�����Ϣ��������Ŀ',false);
  ifGetMemoFromCaseNo:=configini.ReadBool('ѡ��','����"����/סԺ��"��ȡ��ע',false);
  ifAutoCompletionJob:=configini.ReadBool('ѡ��','�Ƿ�رճ���ʱ�Զ��������鹤��',false);
  LoginTime:=configini.ReadInteger('ѡ��','������¼���ڵ�ʱ��',30);
  ifSearchHistValue:=configini.ReadBool('ѡ��','������ʷ���',false);

  TempFile_Common:=configini.ReadString('��ӡģ��','ͨ��ģ���ļ�','');
  TempFile_Group:=configini.ReadString('��ӡģ��','����ģ���ļ�','');
  WorkGroup_T1:=configini.ReadString('��ӡģ��','����ģ��1������','');
  TempFile_T1:=configini.ReadString('��ӡģ��','����ģ��1�ļ�','');
  WorkGroup_T2:=configini.ReadString('��ӡģ��','����ģ��2������','');
  TempFile_T2:=configini.ReadString('��ӡģ��','����ģ��2�ļ�','');
  WorkGroup_T3:=configini.ReadString('��ӡģ��','����ģ��3������','');
  TempFile_T3:=configini.ReadString('��ӡģ��','����ģ��3�ļ�','');  

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
      '�����޼�������ӡ'+#2+'CheckListBox'+#2+#2+'0'+#2+#2+#3+
      '"�������Ա�����ϲ�"�Ĺ����鷶Χ'+#2+'Edit'+#2+#2+'0'+#2+'���ϣ���ټ�����������ϲ�,����"�ټ���,������".�ձ�ʾ������'+#2+#3+
      '��ӡʱ�Զ���˼��鵥'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '����"����/סԺ��"��ȡ��ע'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '��ȡHIS�еĲ��˻�����Ϣ��������Ŀ'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '��д���˻�����Ϣʱ,ֱ�ӻس�����ȡ���'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '�ͼ����ȡ���ƥ�䷽ʽ'+#2+'Combobox'+#2+'ģ��ƥ��'+#13+'��ƥ��'+#13+'��ƥ��'+#13+'ȫƥ��'+#2+'1'+#2+#2+#3+
      '�ͼ�ҽ��ȡ���ƥ�䷽ʽ'+#2+'Combobox'+#2+'ģ��ƥ��'+#13+'��ƥ��'+#13+'��ƥ��'+#13+'ȫƥ��'+#2+'1'+#2+#2+#3+
      '����ʾ����˵ļ��鵥'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '����ʾ��¼���������鵥'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '�Ƿ�رճ���ʱ�Զ��������鹤��'+#2+'CheckListBox'+#2+#2+'1'+#2+#2+#3+
      '���˻�����Ϣ����ʽ'+#2+'Combobox'+#2+'��ˮ��'+#13+'������'+#2+'1'+#2+#2+#3+
      '������¼���ڵ�ʱ��'+#2+'Edit'+#2+#2+'1'+#2+'ע:��ʾ�೤ʱ�����޲���,���Զ�������¼����(��λ:��)'+#2+#3+
      '������ʷ���'+#2+'CheckListBox'+#2+#2+'1'+#2+'ע:���ø�ѡ�����ϵͳ����,����!'+#2+#3+
      'ͨ��ģ���ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ���ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��1������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��1�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��2������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��2�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
      '����ģ��3������'+#2+'Combobox'+#2+sWorkGroup+#2+'2'+#2+#2+#3+
      '����ģ��3�ļ�'+#2+'File'+#2+#2+'2'+#2+#2+#3+
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
begin
  strsql:='select patientname as ����,'+
        ' sex as �Ա�,'+
        ' age as ����,caseno as ������,bedno as ����,deptname as �ͼ����,'+
        ' check_doctor as �ͼ�ҽ��,check_date as �������,'+
        ' report_date as ��������,'+
        ' operator as ������,printtimes as ��ӡ����,diagnosetype as ���ȼ���,'+
        ' flagetype as ��������,diagnose as �ٴ����,typeflagcase as �������,'+
        ' issure as ��ע,unid as Ψһ���,combin_id as ������, '+
        ' His_Unid as HisΨһ���,His_MzOrZy as His�����סԺ, '+
        ' WorkDepartment as ��������,WorkCategory as ����,WorkID as ����,ifMarry as ���,OldAddress as ����,Address as סַ,Telephone as �绰,WorkCompany as ������˾, '+
        ' PushPress as ����ѹ,PullPress as ����ѹ,LeftEyesight as ��������,RightEyesight as ��������,Stature as ���,Weight as ����, '+
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
            '(case when photo is null then null else ''ͼ'' end) as ͼ,'+
            'combin_Name as �����Ŀ,name as ����,english_name as Ӣ����,itemvalue as ������,'+
            'min_value as ��Сֵ,max_value as ���ֵ,'+
            'unit as ��λ,'+
            'pkcombin_id as �����Ŀ��,itemid as ��Ŀ���,valueid as Ψһ��� '+
            ' from '+
            ifThen(ADOQuery1.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 '+
            ' order by pkcombin_id,printorder ';

  ADOQuery2.Close;
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Text:=strsql11;
  ADOQuery2.Parameters.ParamByName('pkunid').Value:=ADOQuery1.FieldByName('Ψһ���').AsInteger;
  try
    ADOQuery2.Open;
  except
  end;
end;

procedure TfrmMain.ADOQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  dbgrid1.Columns[0].Width:=42;//����
  dbgrid1.Columns[1].Width:=30;//�Ա�
  dbgrid1.Columns[2].Width:=30;//����
  dbgrid1.Columns[3].Width:=65;//������
  dbgrid1.Columns[4].Width:=30;//����
  dbgrid1.Columns[5].Width:=60;//�ͼ����
  dbgrid1.Columns[6].Width:=55;//�ͼ�ҽ��
  dbgrid1.Columns[7].Width:=72;//�������
  dbgrid1.Columns[8].Width:=72;//��������
  dbgrid1.Columns[9].Width:=40;//��ˮ��
  dbgrid1.Columns[10].Width:=40;//������
  dbgrid1.Columns[11].Width:=42;//�����

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
            ifThen(ADOQuery1.FieldByName('ifCompleted').AsInteger=1,'chk_valu_bak','chk_valu')+
            ' where pkunid=:pkunid and issure=1 order by pkcombin_id ';

  adotemp11:=tadoquery.Create(nil);
  adotemp11.Connection:=dm.ADOConnection1;
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Text:=strsql11;
  adotemp11.Parameters.ParamByName('pkunid').Value :=ADOQuery1.FieldByName('Ψһ���').AsInteger;
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
var
  PrintTimes:integer;
  strPrintTimes,Diagnosetype:string;
begin
   //======================��ӡ������ˮ�ű仯��ɫ======================//
    if datacol=0 then //������,��Ϊ��ˮ�����п�������
    begin
      strPrintTimes:=ADOQuery1.fieldbyname('��ӡ����').AsString;
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

end.
