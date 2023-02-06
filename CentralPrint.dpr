program CentralPrint;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain},
  UDM in 'UDM.pas' {DM: TDataModule},
  UfrmLogin in 'UfrmLogin.pas' {frmLogin},
  UfrmModifyPwd in 'UfrmModifyPwd.pas' {frmModifyPwd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
