program DiffMozSaver;

{$mode Delphi}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, frmMain, apphandler, backuphandler, frmPassDlg,
  language;

begin
  Application.Title:='DiffMozSaver';
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.

