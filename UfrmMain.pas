unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ToolWin, Grids, DBGrids,
  DB, ADODB,IniFiles,StrUtils;

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
    procedure FormShow(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
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

end.
