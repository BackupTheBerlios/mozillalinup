{
  Project:   DiffMozSaver
  Unit:      frmMain

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

unit frmMain;

{$mode Delphi}{$H+}

interface

{$IfDef Win32}
 {$R windows.res}
{$EndIf}

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, apphandler, backuphandler, ComCtrls, frmPassDlg, language,
  frmPrefEditor;

type

  { TMain }

  TMain = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    cmdAbort: TButton;
    cmdRefresh: TButton;
    cmdNext: TButton;
    cmdBack: TButton;
    fraBackupfile: TGroupBox;
    imgLeft2: TImage;
    imgLeft3: TImage;
    lblInfo2: TLabel;
    lblNextActionInfo: TLabel;
    lblInfo: TLabel;
    lblBackupFile: TLabel;
    lblBackupPath: TLabel;
    lblSelProfile: TLabel;
    lsProfiles: TListBox;
    mLog: TMemo;
    OpenDialog: TOpenDialog;
    panLeft3: TPanel;
    tAction: TPage;
    panLeft2: TPanel;
    SaveDialog: TSaveDialog;
    cmdSelBackupFile: TSpeedButton;
    tSelProfile: TPage;
    imgLeft: TImage;
    imgLeft1: TImage;
    lblAktion: TLabel;
    lblSupportedApps: TLabel;
    lblWelcome: TLabel;
    lsSupportedApps: TListBox;
    panLeft1: TPanel;
    pMain: TNotebook;
    panAction: TPanel;
    panLeft: TPanel;
    fraAction: TRadioGroup;
    tWelcome: TPage;
    tOperationType: TPage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
    procedure cmdBackClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure cmdRefreshClick(Sender: TObject);
    procedure cmdSelBackupFileClick(Sender: TObject);
    procedure lsProfilesClick(Sender: TObject);
    procedure lsSupportedAppsClick(Sender: TObject);
  private
    bDoClose: Boolean;
    AppHandling: TAppHandling;
    CreateBackup: TCreateBackup;
    RestoreBackup: TRestoreBackup;
    AppDataInfo: TAppDataInfo;
    LanguageHandling: TLanguageHandling;
    procedure DoAction(const Password: String = '');
  public
    s1, s2, s3, s4, s5, s6, s7, s8: String;
  end; 

var
  Main: TMain;

implementation

{ TMain }

procedure TMain.cmdAbortClick(Sender: TObject);
begin
 if(cmdAbort.Caption=s1) then
  Close // Schließen
 else
  begin
   bDoClose:=true;
   Close;
  end;
end;

procedure TMain.cmdBackClick(Sender: TObject);
var
 i: Integer;
begin
 // Auswerten und Anzeigen
 case pMain.PageIndex of
  1: // Willkommensseite anzeigen
   begin
    pMain.PageIndex:=0;
    cmdBack.Visible:=false; // Zurück deaktivieren
   end;
  2: // Operationsseite anzeigen
   begin
    pMain.PageIndex:=1;
    cmdBack.Visible:=true; // Zurück aktivieren
    // Verfügbare Anwendungen auslesen und anzeigen
    lsSupportedApps.Clear;
    AppDataInfo:=AppHandling.GetAvailibleApps;
    for i:=0 to high(AppDataInfo) do
     lsSupportedApps.Items.Add(AppDataInfo[i].Name);
   end;
 end;
end;

procedure TMain.cmdNextClick(Sender: TObject);
var
 i: Integer;
 AppDataInfo: TAppDataInfo;
 sTemp: TStringList;
 sTempPW, sTempString: String;
begin
 // Auswerten und Anzeigen
 case pMain.PageIndex of
  0: // Operationsseite anzeigen
   begin
    pMain.PageIndex:=1;
    cmdBack.Visible:=true; // Zurück aktivieren
    cmdNext.Enabled:=false;
    // Verfügbare Anwendungen auslesen und anzeigen
    lsSupportedApps.Clear;
    AppDataInfo:=AppHandling.GetAvailibleApps;
    for i:=0 to high(AppDataInfo) do
     lsSupportedApps.Items.Add(AppDataInfo[i].Name);
   end;
  1: // Profilwahl Seite anzeigen
   begin
    pMain.PageIndex:=2;
    cmdBack.Visible:=true; // Zurück aktivieren
    cmdNext.Enabled:=false;
    // Profile Auslesen
    lsProfiles.Clear;
    sTemp:=TStringList.Create;
    try
     AppHandling.GetProfiles(AppHandling.AppNameToPath(
     lsSupportedApps.Items[lsSupportedApps.ItemIndex]),sTemp);
     for i:=0 to sTemp.Count-1 do
      begin
       {$IfDef Win32}
        lsProfiles.Items.Add(copy(sTemp[i],pos('.',sTemp[i])+1,
        length(sTemp[i])-pos('.',sTemp[i])+1));
       {$Else}
        // Pfad abschneiden
        sTempString:=copy(sTemp[i],length(AppHandling.AppNameToPath(
        lsSupportedApps.Items[lsSupportedApps.ItemIndex])),length(sTemp[i])-
        length(AppHandling.AppNameToPath(
        lsSupportedApps.Items[lsSupportedApps.ItemIndex]))+1);
        // HinzufÃ¼gen
        lsProfiles.Items.Add(copy(sTempString,pos('.',sTempString)+1,
        length(sTempString)-pos('.',sTempString)+1))
       {$EndIf}
      end;
    finally
     sTemp.Free;
    end;
    // Aktion
    case fraAction.ItemIndex of
     0: // Sichern
      begin
       lblSelProfile.Caption:=s2;
       lblBackupPath.Caption:=s3;
       fraBackupfile.Caption:=s4;
      end;
     1: // Widerherstellen
      begin
       lblSelProfile.Caption:=s5;
       lblBackupPath.Caption:=s6;
       fraBackupfile.Caption:=s7;
      end;
    end;
   end;
  2: // Durchführen
   begin
    // Läuft die Anwendung?
    case AppHandling.AppNameToAppType(lsSupportedApps.
    Items[lsSupportedApps.ItemIndex]) of
     appFirefox: // Firefox
      begin
       while(AppHandling.IsFirefoxRunning) do
        begin
         if(MessageDlg(LanguageHandling.GetMSG('1'), mtWarning,
         [mbOK, mbCancel], 0) = mrCancel) then
          begin
           exit;
          end;
        end;
      end;
     appThunderbird: // Thunderbird
      begin
       while(AppHandling.IsThunderbirdRunning) do
        begin
         if(MessageDlg(LanguageHandling.GetMSG('2'), mtWarning,
         [mbOK, mbCancel], 0) = mrCancel) then
          begin
           exit;
          end;
        end;
      end;
    end;
    // Passwort Verschlüsselung?
    if(fraAction.ItemIndex=0) then
     begin
      if(MessageDlg(LanguageHandling.GetMSG('3'),
      mtConfirmation, mbYesNo, 0) = mrYes) then
       begin
        sTempPW:=PassDlg.Show;
       end;
     end
    else
     sTempPW:='';
    pMain.PageIndex:=3;
    cmdBack.Visible:=false;
    cmdNext.Visible:=false;
    Application.ProcessMessages;
    if(sTempPW<>'') then
     DoAction(sTempPW)
    else
     DoAction;
   end;
 end;
end;

procedure TMain.cmdRefreshClick(Sender: TObject);
var
 sTempString: String;
 sTemp: TStringList;
 i: Integer;
begin
// Profile Aktualisieren
lsProfiles.Clear;
sTemp:=TStringList.Create;
try
 AppHandling.GetProfiles(AppHandling.AppNameToPath(
 lsSupportedApps.Items[lsSupportedApps.ItemIndex]),sTemp);
 for i:=0 to sTemp.Count-1 do
  begin
   {$IfDef Win32}
    lsProfiles.Items.Add(copy(sTemp[i],pos('.',sTemp[i])+1,
    length(sTemp[i])-pos('.',sTemp[i])+1));
   {$Else}
    // Pfad abschneiden
    sTempString:=copy(sTemp[i],length(AppHandling.AppNameToPath(
    lsSupportedApps.Items[lsSupportedApps.ItemIndex])),length(sTemp[i])-
    length(AppHandling.AppNameToPath(
    lsSupportedApps.Items[lsSupportedApps.ItemIndex]))+1);
    // HinzufÃ¼gen
    lsProfiles.Items.Add(copy(sTempString,pos('.',sTempString)+1,
    length(sTempString)-pos('.',sTempString)+1))
   {$EndIf}
  end;
finally
 sTemp.Free;
end;
end;

procedure TMain.cmdSelBackupFileClick(Sender: TObject);
begin
 // Backup Datei wählen
 case fraAction.ItemIndex of
  0: // Sichern
   begin
    if(SaveDialog.Execute) then
     lblBackupFile.Caption:=SaveDialog.FileName;
   end;
  1: // Wiederherstellen
   begin
    if(OpenDialog.Execute) then
     lblBackupFile.Caption:=OpenDialog.FileName;
   end;
 end;
 // Profil gewählt?
 if((lsProfiles.ItemIndex<>-1) and (lblBackupFile.Caption<>'') and
 (lblBackupFile.Caption<>'...')) then
  cmdNext.Enabled:=true
 else
  cmdNext.Enabled:=false;
end;

procedure TMain.lsProfilesClick(Sender: TObject);
begin
 // Profil gewählt?
 if((lsProfiles.ItemIndex<>-1) and (lblBackupFile.Caption<>'') and
 (lblBackupFile.Caption<>'...')) then
  cmdNext.Enabled:=true
 else
  cmdNext.Enabled:=false;
end;

procedure TMain.lsSupportedAppsClick(Sender: TObject);
begin
 // Anwendung gewählt?
 if(lsSupportedApps.ItemIndex=-1) then
  cmdNext.Enabled:=false
 else
  cmdNext.Enabled:=true;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
 if(bDoClose) then
  CanClose:=true
 else
  begin
   // Nachfragen
   if(MessageDlg(LanguageHandling.GetMSG('4'), mtConfirmation,
   [mbYes, mbNo], 0) = mrYes) then
    CanClose:=true // Beenden
   else // Nicht Beenden
    CanClose:=false;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
 // AppHandling
 AppHandling:=TAppHandling.Create;
 // Create Backup
 CreateBackup:=TCreateBackup.Create;
 // Restore Backup
 RestoreBackup:=TRestoreBackup.Create;
 // Language
 LanguageHandling:=TLanguageHandling.Create;
 // Standard Tab
 pMain.PageIndex:=0;
 // Schließen (Nachfragen)
 bDoClose:=false;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
 // AppHandling freigeben
 if(Assigned(AppHandling)) then
  AppHandling.Free;
 // Create Backup freigeben
 if(Assigned(CreateBackup)) then
  CreateBackup.Free;
 // Restore Backup freigeben
 if(Assigned(RestoreBackup)) then
  RestoreBackup.Free;
 // Language freigeben
 if(Assigned(LanguageHandling)) then
  LanguageHandling.Free;
end;

procedure TMain.FormKeyPress(Sender: TObject; var Key: char);
begin
 // ESC?
 if(Key=Chr(27)) then Close;
end;

procedure TMain.FormShow(Sender: TObject);
begin
 // Sprache Laden
 LanguageHandling.GetLanguage(Self);
end;

procedure TMain.DoAction(const Password: String = '');
var
 i: Integer;
 sTemp: TStringList;
begin
// Sichern oder wiederherstellen
case fraAction.ItemIndex of
 0: // Sichern
  begin
   sTemp:=TStringList.Create;
   try
    AppHandling.GetProfiles(AppHandling.AppNameToPath(
    lsSupportedApps.Items[lsSupportedApps.ItemIndex]),sTemp);
    // Profil Suchen
    for i:=0 to sTemp.Count-1 do
     begin
      if(pos(lsProfiles.Items[lsProfiles.ItemIndex],sTemp[i])<>0) then
       begin
        CreateBackup.CreateBackup(sTemp[0],lblBackupfile.Caption,
        AppHandling.AppNameToAppType(lsSupportedApps.
        Items[lsSupportedApps.ItemIndex]),mLog,Password);
        break;
       end;
     end;
   finally
    sTemp.Free;
   end;
  end;
 1: // Widerherstellen
  begin
   sTemp:=TStringList.Create;
   try
    AppHandling.GetProfiles(AppHandling.AppNameToPath(
    lsSupportedApps.Items[lsSupportedApps.ItemIndex]),sTemp);
    // Profil Suchen
    for i:=0 to sTemp.Count-1 do
     begin
      if(pos(lsProfiles.Items[lsProfiles.ItemIndex],sTemp[i])<>0) then
       begin
        RestoreBackup.RestoreBackup(sTemp[0],lblBackupfile.Caption,
        AppHandling.AppNameToAppType(lsSupportedApps.
        Items[lsSupportedApps.ItemIndex]),mLog);
        // Preferenzen editieren
        PrefEditor.Show(IncludeTrailingPathDelimiter(sTemp[0])+'prefs.js');
        break;
       end;
     end;
   finally
    sTemp.Free;
   end;
  end;
end;
// Fertig
cmdAbort.Caption:=s8;
end;

initialization
  {$I frmmain.lrs}

end.

