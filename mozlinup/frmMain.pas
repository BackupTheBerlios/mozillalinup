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
    Save: TSaveDialog;
    procedure cmdTwoClick(Sender: TObject);
    procedure cmdOneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fraSelect1cmdRefreshClick(Sender: TObject);
    procedure fraSelect1cmdBrowseClick(Sender: TObject);
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
  ProfilePath: String;

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
  SavePath:=GetEnvironmentVariable('HOME') + '/' + ProgSelect + '.pcv';
  fraSelect1.lblPath.Caption:=functions.shortpath(SavePath);

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla') then
   begin
    functions.GetProfiles(Dirs.MozillaDir);
    ProfilePath:=Dirs.MozillaDir;
   end;

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Firefox') then
   begin
    functions.GetProfiles(Dirs.FirefoxDir);
    ProfilePath:=Dirs.FirefoxDir;
   end;

  // Mozilla
  if(fraOperation.fraPrograms.Items.Strings[fraOperation.fraPrograms.itemindex]='Mozilla Thunderbird') then
   begin
    functions.GetProfiles(Dirs.ThunderbirdDir);
    ProfilePath:=Dirs.ThunderbirdDir;
   end;
 end;
end;

procedure TMain.FormCreate(Sender: TObject);
var
 LoadLang: Tlanguage;
begin
// Sprache Laden
LoadLang:=Tlanguage.create;
LoadLang.LoadLanguage(ExtractFilePath(Application.ExeName)+'/lang/Default.lng');

// Verzeichnisse ermitteln
Dirs.MozillaDir:=functions.GetMozillaDir;
Dirs.FirefoxDir:=functions.GetFirefoxDir;
Dirs.ThunderbirdDir:=functions.GetThunderbirdDir;

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

// Profile aktualisieren
procedure TMain.fraSelect1cmdRefreshClick(Sender: TObject);
begin
functions.GetProfiles(ProfilePath+'/');
end;

procedure TMain.fraSelect1cmdBrowseClick(Sender: TObject);
begin
// Datei Speichern unter (Save file as)
if(Save.Execute) then
 begin
  SavePath:=Save.Filename;
  fraSelect1.lblPath.Caption:=functions.shortpath(SavePath);
 end;
end;

end.
