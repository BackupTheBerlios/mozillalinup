unit frmMain;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, fraStart, fraOperation, functions,
  fraSelectProfile;

type
  TMain = class(TForm)
    imgLeft: TImage;
    fraImage: TBevel;
    fraLine: TBevel;
    cmdOne: TButton;
    cmdTwo: TButton;
    fraWelcome: TFrame1;
    fraOperation: TOperation;
    cmdThree: TButton;
    fraSelect1: TfraSelect;
    procedure cmdTwoClick(Sender: TObject);
    procedure cmdOneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fraSelect1cmdRefreshClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type
 ProgramDirs = record
  MozillaDir: String;
  FirefoxDir: String;
  ThunderbirdDir: String;
end;

var
  Main: TMain;
  Dirs: ProgramDirs;
  ProgSelect: String;
  SavePath: String;

implementation

uses language;

{$R *.xfm}

procedure TMain.cmdTwoClick(Sender: TObject);
begin
 // Cancel
 if(MessageDlg('The operation is not finished. Do you really want to exit the program?',mtConfirmation,
    [mbYes,mbNo],0)=mrYes) then
    Close;
end;

procedure TMain.cmdOneClick(Sender: TObject);
var
 Funktionen: Tfunctions;
begin
if(fraWelcome.Visible) then
 begin
  fraWelcome.Visible:=false;
  fraOperation.Visible:=true;
  // Show Back Button
  cmdThree.Visible:=true;
  exit;
 end;

if(fraOperation.Visible) then
 begin
  fraOperation.Visible:=false;
  fraSelect1.Visible:=true;

  ProgSelect:=fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex];
  if(length(GetEnvironmentVariable('HOME') + '/' + ProgSelect + '.pcv')>=25) then
   begin
    SavePath:=GetEnvironmentVariable('HOME') + '/' + ProgSelect + '.pcv';
    fraSelect1.lblPath.Caption:='...' + Copy(SavePath,length(SavePath)-25,length(SavePath));
   end;

  // Profile ermitteln
  Funktionen:=tfunctions.create;

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla') then
   begin
    Funktionen.GetProfiles(Dirs.MozillaDir);
   end;

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Firefox') then
   begin
    Funktionen.GetProfiles(Dirs.FirefoxDir);
   end;

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Thunderbird') then
   begin
    Funktionen.GetProfiles(Dirs.ThunderbirdDir);
   end;

  Funktionen.Free;
  exit;
 end;
end;

procedure TMain.FormCreate(Sender: TObject);
var
 Funktionen: Tfunctions;
 LoadLang: Tlanguage;
begin
// Sprache Laden
LoadLang:=Tlanguage.create;
LoadLang.LoadLanguage(ExtractFilePath(Application.ExeName)+'/lang/Default.lng');

Funktionen:=Tfunctions.Create;
// Verzeichnisse ermitteln
Dirs.MozillaDir:=Funktionen.GetMozillaDir;
Dirs.FirefoxDir:=Funktionen.GetFirefoxDir;
Dirs.ThunderbirdDir:=Funktionen.GetThunderbirdDir;

// In Liste Einfügen
if(Dirs.MozillaDir<>'') then
  fraOperation.fraPrograms.Items.Add('Mozilla');
if(Dirs.FirefoxDir<>'') then
  fraOperation.fraPrograms.Items.Add('Mozilla Firefox');
if(Dirs.ThunderbirdDir<>'') then
  fraOperation.fraPrograms.Items.Add('Mozilla Thunderbird');

// Falls nichts gefunden wurde
if(fraOperation.fraPrograms.Items.Count=-1) then
 fraOperation.fraPrograms.Items.Add('No program was found');
end;

procedure TMain.fraSelect1cmdRefreshClick(Sender: TObject);
var
 Funktionen: Tfunctions;
begin
// Profile Aktualisieren (Refresh Profiles)
// Alte Einträge Löschen
fraOperation.fraPrograms.Items.Clear;

// Profile ermitteln
Funktionen:=tfunctions.create;

// Mozilla
if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla') then
 begin
  Funktionen.GetProfiles(Dirs.MozillaDir);
  exit;
 end;

// Mozilla
if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Firefox') then
 begin
  Funktionen.GetProfiles(Dirs.FirefoxDir);
  exit;
 end;

// Mozilla
if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Thunderbird') then
 begin
  Funktionen.GetProfiles(Dirs.ThunderbirdDir);
  exit;
 end;
end;

end.
