program ClanadDemo;

uses
  Forms,
  DMod in 'DMod.pas' {DM: TDM},
  MainForm in 'MainForm.pas' {FrmMain: TFrmMain};

{ *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
