unit language;

// **********************************************
// K L A S S E : language
// ----------------------------------------------
// Version  : 0.1
// Autor    : Andre Hauke
//
// Aufgabe  : Multilanguage Funktionen
// Compiler : KYLIX 3.0
// Aenderung:
// **********************************************

interface

uses
 SysUtils, InIFiles, frmMain;

type
  Tlanguage = class(TObject)
  private
   function GetLocalLanguage(): String;
   function Convert(Text: String):String;
  public
   procedure LoadLanguage(sFile: String);
   constructor create;
end;

var
 sHomeDir: String;
 sLanguage: String;

implementation

// Home Verzeichnis ermitteln (Get Home Dir)
constructor Tlanguage.create;
begin
sHomeDir:=GetEnvironmentVariable('HOME');
end;

// Aktuelle Systemsprache ermitteln (Get current lang)
function Tlanguage.GetLocalLanguage():String;
begin
sLanguage:=GetEnvironmentVariable('LANG');
end;

// Sprache Laden (Load language)
procedure Tlanguage.LoadLanguage(sFile: String);
var
 ini: TIniFile;
begin
 ini:=Tinifile.Create(sFile);
 // Daten Auslesen (Read data)
 try
  // Frame Willkommen (Frame Welcome)
  Main.fraWelcome.lblWelcome.Caption:=Convert(ini.ReadString('TForm1','LANG_APLIKACE_WELCOME','Welcome to MozBackUp'));
  Main.fraWelcome.lblIntro.Caption:=Convert(ini.ReadString('TForm1','LANG_MEMO1','This wizard will help you to backup or restore your Mozilla user profile.'));
  Main.fraWelcome.Label1.Caption:=Convert(ini.ReadString('TForm1','LANG_MEMO11','It is strongly recomended that you exist all programs that can be mainipulated with your Mozilla user profile.'));
  Main.fraWelcome.Label2.Caption:=Convert(ini.ReadString('TForm1','LANG_MEMO12','Click Cancel to quit the program. Click next to continue.'));
  // Frame Operationen (Frame Operations)
  Main.fraOperation.lblChoose.Caption:=Convert(ini.ReadString('TForm1','LANG_CO_PROVEST','Choose the operation you want to perform.'));
  Main.fraOperation.fraOperation.Caption:=Convert(ini.ReadString('TForm1','LANG_VOLBA','Operation'));
  Main.fraOperation.fraOperation.Items.Strings[0]:=Convert(ini.ReadString('TForm1','LANG_ZALOHA','Backup a profile'));
  Main.fraOperation.fraOperation.Items.Strings[1]:=Convert(ini.ReadString('TForm1','LANG_OBNOVA','Restore a profile'));
  Main.fraOperation.lblInfo.Caption:=Convert(ini.ReadString('TForm1','LANG_MEMO2','It is possible to backup or restore Mozilla user profile(s) of the following application(s).'));
  // Frame Profil Auswählen (Frame SelectProfile)
  Main.fraSelect1.lblInfo.Caption:=Convert(ini.ReadString('TForm1','LANG_TEXT2_1','Select the profile you want to backup:'));
  Main.fraSelect1.cmdRefresh.Caption:=Convert(ini.ReadString('TForm1','LANG_RELOAD','Refresh'));
  Main.fraSelect1.cmdNewProfile.Caption:=Convert(ini.ReadString('TForm1','LANG_NEW_PROFIL','New profile'));
  Main.fraSelect1.lblSelect.Caption:=Convert(ini.ReadString('TForm1','LANG_TEXT4_1','Then select the location of the backup file:'));
  Main.fraSelect1.fraSelect.Caption:=Convert(ini.ReadString('TForm1','LANG_CHOOSE_FILE','Select file'));
  Main.fraSelect1.cmdBrowse.Caption:=Convert(ini.ReadString('TForm1','LANG_CHOOSE','Browse...'));
 finally
  ini.free; // Freigeben (Set free)
 end;
end;

// '' Entfernen (Delete '')
function Tlanguage.Convert(Text: String):String;
begin
 // Name Konvertieren (Convert Name)
 if(pos('Mozilla Backup',Text)<>0) then
  Text:=StringReplace(Text,'Mozilla Backup','MozLinUp',[rfReplaceAll]);

 Convert:=Copy(Text,2,length(text)-2);
end;

end.
