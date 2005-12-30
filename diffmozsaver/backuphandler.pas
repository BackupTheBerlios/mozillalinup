{
  Project:   DiffMozSaver
  Unit:      backuphandler

  Copyright: 2005 - 2006 by Different4All GbR
  Author:    Written by Andre Hauke

  History:
}

unit backuphandler;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ComCtrls, Process, StdCtrls, Controls,
  apphandler, AbUnzper, AbArcTyp, language;

  type
   TBackupResult = record
    Result: Integer;
    Text: String;
  end;
  
  type
   TRestoreResult = record
    Result: Integer;
    Text: String;
  end;
  
  type

   { TCreateBackup }

   TCreateBackup = class(TObject)
    private
     LanguageHandling: TLanguageHandling;
     function CopyProfileFiles(ProfileDir: String; AppType: TAppType): String;
    public
     function CreateBackup(ProfileDir, sFile: String;
      AppType: TAppType; Log: TMemo; const PW: String =''): TBackupResult;
     constructor Create;
     destructor Destroy; override;
  end;
  
  type

   { TRestoreBackup }

   TRestoreBackup = class(TObject)
    private
     bDoAbort: Boolean;
     Zip: TAbUnZipper;
     LanguageHandling: TLanguageHandling;
     procedure AZipNeedPassword(Sender: TObject; var NewPassword: String);
     procedure AbZipArchiveProgress(Sender: TObject; Progress: Byte;
      var Abort: Boolean);
    public
     function RestoreBackup(RestoreDir, sFile: String;
      AppType: TAppType; Log: TMemo): TRestoreResult;
     constructor Create;
     destructor Destroy; override;
  end;

 const
  READ_BYTES = 2048;
  
  // Firefox
  FirefoxFiles: array [0..14] of String = ('bookmarks.html', 'cert8.db',
  'cookies.txt', 'downloads.rdf', 'formhistory.dat', 'history.dat',
  'hostperm.1', 'key3.db', 'localstore.rdf', 'mimeTypes.rdf', 'prefs.js',
  'search.rdf', 'secmod.db', 'signons.txt', 'user.js');
  FirefoxDirs: array [0..2] of String = ('chrome', 'extensions',
  'searchplugins');
  
  // Thunderbird
  ThunderbirdFiles: array [0..19] of String = ('abook.mab', 'abook-1.mab',
  'abook-2.mab', 'abook-3.mab', 'abook-4.mab', 'abook-5.mab', 'cert8.db',
  'cookies.txt', 'downloads.rdf', 'history.mab', 'key3.db', 'localstore.rdf',
  'mailViews.dat', 'mimeTypes.rdf', 'panacea.dat', 'persdict.dat', 'prefs.js',
  'secmod.db', 'training.dat', 'virtualFolders.dat');
  ThunderbirdDirs: array [0..3] of String = ('chrome', 'extensions',
  'Mail','News');

implementation

uses
 functions;

{ TCreateBackup }

function TCreateBackup.CopyProfileFiles(ProfileDir: String;
 AppType: TAppType): String;
var
 i: Integer;
 sTempDir: String;
begin
// Temporäres Verzeichnis
sTempDir:=IncludeTrailingPathDelimiter(GetTempDir)+'diffmozsaver';
Result:=sTempDir;
try
 // Erstellen
 CreateDir(sTempDir);
 case AppType of
  appFirefox: // Firefox
   begin
    // Kopieren
    // Dateien
    for i:=0 to high(FirefoxFiles) do
     begin // Nur kopieren falls vorhanden
      if(FileExists(IncludeTrailingPathDelimiter(ProfileDir)+FirefoxFiles[i])) then
       begin
        CopyFile(IncludeTrailingPathDelimiter(ProfileDir)+FirefoxFiles[i],
        IncludeTrailingPathDelimiter(sTempDir)+ExtractFileName(FirefoxFiles[i]));
       end;
     end;
    // Verzeichnisse
    for i:=0 to high(FirefoxDirs) do
     begin // Nur kopieren falls vorhanden
      if(DirectoryExists(IncludeTrailingPathDelimiter(ProfileDir)+
      FirefoxDirs[i])) then
       begin
        CopyDir(IncludeTrailingPathDelimiter(ProfileDir)+FirefoxDirs[i],
        IncludeTrailingPathDelimiter(sTempDir));
       end;
     end;
   end;
  appThunderbird: // Thunderbird
   begin
    // Kopieren
    // Dateien
    for i:=0 to high(ThunderbirdFiles) do
     begin // Nur kopieren falls vorhanden
      if(FileExists(IncludeTrailingPathDelimiter(ProfileDir)+ThunderbirdFiles[i])) then
       begin
        CopyFile(IncludeTrailingPathDelimiter(ProfileDir)+ThunderbirdFiles[i],
        IncludeTrailingPathDelimiter(sTempDir)+ExtractFileName(ThunderbirdFiles[i]));
       end;
     end;
    // Verzeichnisse
    for i:=0 to high(ThunderbirdDirs) do
     begin // Nur kopieren falls vorhanden
      if(DirectoryExists(IncludeTrailingPathDelimiter(ProfileDir)+
      ThunderbirdDirs[i])) then
       begin
        CopyDir(IncludeTrailingPathDelimiter(ProfileDir)+ThunderbirdDirs[i],
        IncludeTrailingPathDelimiter(sTempDir));
       end;
     end;
   end;
 end;
except
 Result:='';
end;
end;

function TCreateBackup.CreateBackup(ProfileDir, sFile: String;
 AppType: TAppType; Log: TMemo; const PW: String =''): TBackupResult;
var
 S: TStringList;
 M: TMemoryStream;
 P: TProcess;
 n: LongInt;
 BytesRead: LongInt;
 sDir: String;
begin
 // Dateien Kopieren
 Log.Lines.Add(LanguageHandling.GetStatusMSG('1'));
 Sleep(50);
 sDir:=CopyProfileFiles(ProfileDir, AppType);
 if(sDir='') then // FEHLER!!!
  begin
   Result.Result:=-1;
   Result.Text:=LanguageHandling.GetErrorMSG('1');
   exit;
  end;
 BytesRead:=0;
 M:=TMemoryStream.Create;
 P:=TProcess.Create(nil);
 S:=TStringList.Create;
 try
  P.CurrentDirectory:=sDir;
  // Passwort verwenden?
  if(PW<>'') then
   P.CommandLine:='zip -2 -R -m -P '+PW+' "'+sFile+'" "'+sDir+'" *.*'
  else
   P.CommandLine:='zip -2 -R -m "'+sFile+'" "'+sDir+'" *.*';
  P.Options:=[poUsePipes,poNoConsole];
  // Status
  Log.Lines.Add(LanguageHandling.GetStatusMSG('2'));
  // Ausführen
  P.Execute;
  while(P.Running) do
   begin
    M.SetSize(BytesRead + READ_BYTES);
    n:=P.Output.Read((M.Memory+BytesRead)^, READ_BYTES);
    if(n>0) then
     begin
      try
       Inc(BytesRead, n);
       S.Clear;
       S.LoadFromStream(M);
       Log.Lines.AddStrings(S);
       Sleep(50);
      except
      end;
     end
    else
     Sleep(100);
   end;
  Log.Lines.Add(LanguageHandling.GetStatusMSG('3'));
 finally
  S.Free;
  P.Free;
  M.Free;
 end;
end;

constructor TCreateBackup.Create;
begin
 // Language
 LanguageHandling:=TLanguageHandling.Create;
end;

destructor TCreateBackup.Destroy;
begin
 // Language
 if(Assigned(LanguageHandling)) then
  LanguageHandling.Free;
 inherited Destroy;
end;

{ TRestoreBackup }

procedure TRestoreBackup.AZipNeedPassword(Sender: TObject;
 var NewPassword: String);
begin
 // Password erforderlich
 // Nachfragen
 if(MessageDlg(LanguageHandling.GetMSG('5'), mtConfirmation, mbYesNo,
 0) = mrYes) then
  begin
   // Eingabe
   NewPassword:=PasswordBox(LanguageHandling.GetMSG('6'),
   LanguageHandling.GetMSG('7'));
  end
 else // Abbrechen
  begin
   bDoAbort:=true;
  end;
end;

procedure TRestoreBackup.AbZipArchiveProgress(Sender: TObject; Progress: Byte;
 var Abort: Boolean);
begin
 if(bDoAbort) then
  Abort:=true
 else
  Abort:=false;
end;

function TRestoreBackup.RestoreBackup(RestoreDir, sFile: String;
 AppType: TAppType; Log: TMemo): TRestoreResult;
var
 sTempFile: String;
begin
// Kopieren
Log.Lines.Add(LanguageHandling.GetStatusMSG('1'));
sTempFile:=ChangeFileExt(GetTempFileName,'.zip');
CopyFile(sFile,sTempFile);
// Entpacken
Log.Lines.Add(LanguageHandling.GetStatusMSG('4'));
Zip.BaseDirectory:=RestoreDir;
if(DirectoryExists(Zip.BaseDirectory)=false) then
 begin
  // Erzeugen
  try
   ForceDirectories(Zip.BaseDirectory);
  except
  end;
 end;
Zip.FileName:=sTempFile;
Zip.ExtractOptions:=[eoCreateDirs,eoRestorePath];
Zip.OnNeedPassword:=AZipNeedPassword;
Zip.OnArchiveProgress:=AbZipArchiveProgress;
try
 Zip.ExtractFiles('*.*');
except
 Log.Lines.Add(LanguageHandling.GetStatusMSG('5'));
 // Temp Löschen
 try
  DeleteFile(sTempFile);
 except
 end;
 exit;
end;
Zip.CloseArchive;
Log.Lines.Add(LanguageHandling.GetStatusMSG('3'));
// Temp Löschen
try
 DeleteFile(sTempFile);
except
end;
end;

constructor TRestoreBackup.Create;
begin
 // Zip
 Zip:=TAbUnZipper.Create(nil);
 bDoAbort:=false;
 // Language
 LanguageHandling:=TLanguageHandling.Create;
end;

destructor TRestoreBackup.Destroy;
begin
 // Zip
 Zip.Free;
 // Language freigeben
 if(Assigned(LanguageHandling)) then
  LanguageHandling.Free;
 inherited Destroy;
end;

end.

