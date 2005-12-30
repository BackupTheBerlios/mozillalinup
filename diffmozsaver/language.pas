{
  Project:   DiffMozSaver
  Unit:      language

  Author:    Andre Hauke

  This file is part of DiffMozSaver.
  Copyright (c) 2004-2006 by Different4All GbR.

  See the file COPYING.GPL, included in this distribution,
  for details about the copyright.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


  History:
}

unit language;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, Forms;

  type

   { TLanguageHandling }

   TLanguageHandling = class(TObject)
    private
     ini: TIniFile;
    public
     procedure GetLanguage(Form: TForm);
     function GetMSG(ID: String): String;
     function GetErrorMSG(ID: String): String;
     function GetStatusMSG(ID: String): String;
     constructor Create;
     destructor Destroy; override;
  end;

implementation

uses
 frmMain, frmPassDlg;

{ TLanguageHandling }

procedure TLanguageHandling.GetLanguage(Form: TForm);
begin
 // frmMain
 if(Form=Main) then
  begin
   with(Form as TMain) do
    begin
     s1:=ini.ReadString('Main','19','Abbrechen');
     s2:=ini.ReadString('Main','10','Bitte wählen Sie das zu sichernde Profil:');
     s3:=ini.ReadString('Main','13','Bitte wählen Sie die Backup-Ausgabedatei:');
     s4:=ini.ReadString('Main','15','Ausgabedatei');
     s5:=ini.ReadString('Main','11','Bitte wählen Sie das widerherzustellende Profil:');
     s6:=ini.ReadString('Main','14','Bitte wählen Sie die Wiederherstellungsdatei:');
     s7:=ini.ReadString('Main','16','Wiederherstellungsdatei');
     s8:=ini.ReadString('Main','20','Beenden');
     lblWelcome.Caption:=ini.ReadString('Main','1','Willkommen bei DiffMozSaver!');
     lblInfo.Caption:=ini.ReadString('Main','2','Dieses Programm erlaubt Ihnen, die Anwenderprofile von Mozilla-Anwendungen (Mozilla, Firefox, Thunderbird) inklusive aller Einstellungen zu sichern oder wiederherzustellen');
     lblInfo2.Caption:=ini.ReadString('Main','3','Bitte beenden Sie alle Programme, die eine Datensicherung der Mozilla-Profile beeinflussen könnten.');
     lblNextActionInfo.Caption:=ini.ReadString('Main','4','Klicken Sie auf ''Abbrechen'' zum Beenden des Programms oder auf ''Weiter'' um fortzufahren.');
     lblAktion.Caption:=ini.ReadString('Main','5','Bitte wählen Sie die durchzuführende Aktion:');
     fraAction.Caption:=ini.ReadString('Main','6','Aktion');
     fraAction.Items[0]:=ini.ReadString('Main','7','Profil Sichern');
     fraAction.Items[1]:=ini.ReadString('Main','8','Profil wiederherstellen');
     lblSupportedApps.Caption:=ini.ReadString('Main','9','Sie können Profile der folgenden Anwendungen sichern bzw. wiederherstellen:');
     lblSelProfile.Caption:=ini.ReadString('Main','10','Bitte wählen Sie das zu sichernde Profil:');
     cmdRefresh.Caption:=ini.ReadString('Main','12','Aktualisieren');
     lblBackupPath.Caption:=ini.ReadString('Main','13','Bitte wählen Sie die Backup-Ausgabedatei:');
     fraBackupfile.Caption:=ini.ReadString('Main','15','Ausgabedatei');
     cmdBack.Caption:=ini.ReadString('Main','17','Zurück');
     cmdNext.Caption:=ini.ReadString('Main','18','Weiter');
     cmdAbort.Caption:=ini.ReadString('Main','19','Abbrechen');
    end;
  end
 // frmPassDlg
 else if(Form=PassDlg) then
  begin
   with(Form as TPassDlg) do
    begin
     Caption:=ini.ReadString('PassDlg','1','Passwort festlegen');
     fraPassword.Caption:=ini.ReadString('PassDlg','1','Passwort festlegen');
     lblPass1.Caption:=ini.ReadString('PassDlg','2','Passwort:');
     lblPass2.Caption:=ini.ReadString('PassDlg','3','Passwort widerholung:');
     cmdOk.Caption:=ini.ReadString('PassDlg','4','Ok');
     cmdAbort.Caption:=ini.ReadString('PassDlg','5','Abbrechen');
    end;
  end;
end;

function TLanguageHandling.GetMSG(ID: String): String;
begin
 // Meldung auslesen
 Result:=ini.ReadString('MSG',ID,'');
end;

function TLanguageHandling.GetErrorMSG(ID: String): String;
begin
 // Fehlermeldung auslesen
 Result:=ini.ReadString('Error',ID,'');
end;

function TLanguageHandling.GetStatusMSG(ID: String): String;
begin
 // Stautsmeldung auslesen
 Result:=ini.ReadString('Status',ID,'');
end;

constructor TLanguageHandling.Create;
begin
 ini:=TIniFile.Create('default.lng');
end;

destructor TLanguageHandling.Destroy;
begin
 ini.Free;
 inherited Destroy;
end;

end.

