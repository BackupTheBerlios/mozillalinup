program DiffMozSaver;

{$mode Delphi}{$H+}

uses
 Interfaces, Forms, frmMain, apphandler,
 backuphandler, frmPassDlg,  language, frmPrefEditor;

begin
 Application.Title:='DiffMozSaver';
 Application.Initialize;
 Application.CreateForm(TMain, Main);
 Application.Run;
end.
