program MozBackUp;

uses
  QForms,
  frmMain in 'frmMain.pas' {Main},
  fraStart in 'fraStart.pas' {Frame1: TFrame},
  fraOperation in 'fraOperation.pas' {Operation: TFrame},
  functions in 'functions.pas',
  fraSelectProfile in 'fraSelectProfile.pas' {fraSelect: TFrame},
  language in 'language.pas';



begin
  Application.Initialize;
  Application.Title := 'MozLinUp';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
