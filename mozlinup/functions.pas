unit functions;

// **********************************************
// UNIT : functions
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
 SysUtils, QDialogs, Classes, ZLib;

 function GetMozillaDir():String;
 function GetFirefoxDir():String;
 function GetThunderbirdDir():String;
 procedure GetProfiles(Path: String);
 Procedure FileCopy(Const FromFile, ToFile: String);
 procedure Compress(InputFileName, OutputFileName: string);
 procedure Decompress(InputFileName, OutputFileName: string);
 function ShortPath(Text: String):String;

var
 sHomeDir: String;

implementation

uses
 frmMain;
 

// Mozilla Verzeichnis ermitteln (Get Mozilla Dir)
function GetMozillaDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.mozilla')) then
  GetMozillaDir:=sHomeDir + '/.mozilla';
end;

// Mozilla Firefox Verzeichnis ermitteln (Get Mozilla Firefox Dir)
function GetFirefoxDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.phoenix')) then
  GetFirefoxDir:=sHomeDir + '/.phoenix';
end;

// Mozilla Thunderbird Verzeichnis ermitteln (Get Mozilla Thunderbird Dir)
function GetThunderbirdDir():String;
begin
 // Existiert das Verzeichnis (Exist the dir)
 if(DirectoryExists(sHomeDir + '/.thunderbird')) then
  GetThunderbirdDir:=sHomeDir + '/.thunderbird';
end;

// Vorhandene Profile ermitteln (Get Profiles)
procedure GetProfiles(Path: String);
var
 SR: TSearchRec;
begin
  with Main.fraSelect1 do begin
   lsProfiles.Items.Clear;
   if Path[Length(Path)]<>'/' then Path:=Path+'/';
    if FindFirst(Path+'*',faDirectory,SR)=0 then Begin
      repeat
        if (SR.Attr and faDirectory = faDirectory)
          and (SR.Name[1] <> '.') then Begin
            //Eintrag ist ein Verzeichnis
            if (SR.Attr and faDirectory > 0) then
             if(SR.Name<>'plugins') then lsProfiles.Items.Add(SR.name);
        end;
      until FindNext(SR)<>0;
      FindClose(SR); //Nach jedem findfirst nötig, um sr freizugeben!
    End;
  end;
end;

// Eine Datei kopieren (Copy a file)
Procedure FileCopy(Const FromFile, ToFile: String);
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
end;

// Packen
procedure Compress(InputFileName, OutputFileName: string);
var InputStream, OutputStream: TFileStream;
  CompressionStream: zlib.TCompressionStream;
begin
  InputStream:=TFileStream.Create(InputFileName, fmOpenRead);
  try
    OutputStream:=TFileStream.Create(OutputFileName, fmCreate);
    try
      CompressionStream:=zlib.TCompressionStream.Create(clMax, OutputStream);
      try
        CompressionStream.CopyFrom(InputStream, InputStream.Size);
      finally
        CompressionStream.Free;
      end;
    finally
      OutputStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

// Entpacken
procedure Decompress(InputFileName, OutputFileName: string);
var InputStream, OutputStream: TFileStream;
  DeCompressionStream: ZLib.TDeCompressionStream;
  Buf: array[0..4095] of Byte;
  Count: Integer;
begin
  InputStream:=TFileStream.Create(InputFileName, fmOpenRead);
  try
    OutputStream:=TFileStream.Create(OutputFileName, fmCreate);
    try
      DecompressionStream := TDecompressionStream.Create(InputStream);
      try
        while true do
        begin
          Count := DecompressionStream.Read(Buf[0], SizeOf(Buf));
          if Count = 0 then
            break
          else
            OutputStream.Write(Buf[0], Count);
        end;
      finally
        DecompressionStream.Free;
      end;
    finally
      OutputStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

// Verzeichnis abkürzen (Short Path)
function ShortPath(Text: String):String;
begin
if(length(Text)>=25) then
 ShortPath:='...' + Copy(Text,length(Text)-25,length(Text))
else
 ShortPath:=Text;
end;

initialization
sHomeDir:=GetEnvironmentVariable('HOME');
finalization
sHomeDir:='';

end.
