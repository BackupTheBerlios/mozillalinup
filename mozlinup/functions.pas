unit functions;

// **********************************************
// K L A S S E : functions
// ----------------------------------------------
// Version  : 0.1
// Autor    : Andre Hauke
//
// Aufgabe  : Verschiedene Funktionen
// Compiler : KYLIX 3.0
// Aenderung:
// **********************************************

interface

uses
 SysUtils, QDialogs, Classes;

type
  Tfunctions = class(TObject)
  private
  public
   function GetMozillaDir():String;
   function GetFirefoxDir():String;
   function GetThunderbirdDir():String;
   procedure GetProfiles(Path: String);
   Procedure FileCopy(Const FromFile, ToFile: String);
   constructor create;
end;

var
 sHomeDir: String;

implementation

uses
 frmMain;

// Home Verzeichnis ermitteln (Get Home Dir)
constructor Tfunctions.create;
begin
sHomeDir:=GetEnvironmentVariable('HOME');
end;

// Mozilla Verzeichnis ermitteln (Get Mozilla Dir)
function Tfunctions.GetMozillaDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.mozilla')) then
  GetMozillaDir:=sHomeDir + '/.mozilla';
end;

// Mozilla Firefox Verzeichnis ermitteln (Get Mozilla Firefox Dir)
function Tfunctions.GetFirefoxDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.phoenix')) then
  GetFirefoxDir:=sHomeDir + '/.phoenix';
end;

// Mozilla Thunderbird Verzeichnis ermitteln (Get Mozilla Thunderbird Dir)
function Tfunctions.GetThunderbirdDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.thunderbird')) then
  GetThunderbirdDir:=sHomeDir + '/.thunderbird';
end;

// Vorhandene Profile ermitteln (Get Profiles)
procedure Tfunctions.GetProfiles(Path: String);
var
 SR: TSearchRec;
 sPTemp: String;
begin
  with Main.fraSelect1 do begin
   if Path[Length(Path)]<>'/' then Path:=Path+'/';
    if FindFirst(Path+'*',faDirectory,SR)=0 then Begin
      repeat
        if (SR.Attr and faDirectory = faDirectory)
          and (SR.Name[1] <> '.') then Begin
            //Eintrag ist ein Verzeichnis
            if (SR.Attr and faDirectory > 0) then
             if(SR.Name<>'plugins') then lsProfiles.Items.Add(SR.name);
        End;
      until FindNext(SR)<>0;
      FindClose(SR); //Nach jedem findfirst nötig, um sr freizugeben!
    End;
  end;
end;

// Eine Datei kopieren (Copy a file)
Procedure Tfunctions.FileCopy(Const FromFile, ToFile: String);
Var
  S, T: TFileStream;
Begin
  S := TFileStream.Create(FromFile, fmOpenRead);
  try T := TFileStream.Create(ToFile, fmOpenWrite or fmCreate);
    try T.CopyFrom(S, S.Size);
    finally T.Free;
    end;
  finally S.Free;
  end;
End;

end.
