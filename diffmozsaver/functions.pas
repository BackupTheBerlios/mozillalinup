{
  Project:   DiffMozSaver
  Unit:      functions

  Copyright: 2005 - 2006 by Different4All GbR
  Author:    Written by Andre Hauke

  History:
}

unit functions;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

 procedure GetDirs(const Directory: string; var Files: TStringList;
  const FileMask: string = '*.*'; const SubFolders: Boolean = False);
 procedure GetDirsEx(const Directory: string; var Files: TStrings;
  const FileMask: string = '*.*'; const SubFolders: Boolean = False);
 procedure GetFiles(const Directory: string; var Files: TStringList;
  const FileMask: string = '*.*';  const SubFolders: Boolean = False);
 procedure CopyFile(filename, newfilename: String);
 procedure CopyDir(OldDir, NewDir: String);
 
implementation

// Alle Verzeichnisse aus einem Verzeichnis auslesen
procedure GetDirs(const Directory: string; var Files: TStringList;
 const FileMask: string = '*.*'; const SubFolders: Boolean = False);
var
 SearchRec: TSearchRec;
begin
  // Zuerst alle Verzeichnisse im aktuelle Verzeichnis finden
  if FindFirst(IncludeTrailingPathDelimiter(Directory)+FileMask,
  faDirectory, SearchRec) = 0 then
   begin
    try
     repeat
      if(SearchRec.Attr and faDirectory = faDirectory) and
      (SearchRec.Name[1] <> '.') then
       begin
        if((SearchRec.Name<>'.') and (SearchRec.Name<>'..')) then
         Files.Add(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name);
       end;
     until FindNext(SearchRec)<>0;
    finally
     SysUtils.FindClose(SearchRec);
    end;
   end;

  // Als nächstes nach Unterverzeichnissen suchen und, wenn benötigt, durchsuchen
  if SubFolders then
  begin
    if FindFirst(IncludeTrailingPathDelimiter(Directory)+'*.*',
    faDirectory, SearchRec) = 0 then
    begin
      try
       repeat
        // Wenn es ein Verzeichnis ist, Rekursion verwenden
        if(SearchRec.Attr and faDirectory = faDirectory) then
         begin
          if((SearchRec.Name<>'.') and (SearchRec.Name<>'..')) then
           GetDirs(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name,
           Files, FileMask, SubFolders);
         end;
        until FindNext(SearchRec)<>0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
    end;
  end;
end;

// Alle Verzeichnisse aus einem Verzeichnis auslesen
procedure GetDirsEx(const Directory: string; var Files: TStrings;
 const FileMask: string = '*.*'; const SubFolders: Boolean = False);
var
 SearchRec: TSearchRec;
begin
  // Zuerst alle Verzeichnisse im aktuelle Verzeichnis finden
  if FindFirst(IncludeTrailingPathDelimiter(Directory)+FileMask,
  faAnyFile, SearchRec) = 0 then
   begin
    try
     repeat
      if(SearchRec.Attr and faDirectory = faDirectory) and
      (SearchRec.Name[1] <> '.') then
       begin
        if((SearchRec.Name<>'.') and (SearchRec.Name<>'..')) then
         Files.Add(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name);
       end;
     until FindNext(SearchRec)<>0;
    finally
     SysUtils.FindClose(SearchRec);
    end;
   end;

  // Als nächstes nach Unterverzeichnissen suchen und, wenn benötigt, durchsuchen
  if SubFolders then
  begin
    if FindFirst(IncludeTrailingPathDelimiter(Directory)+'*.*',
    faDirectory, SearchRec) = 0 then
    begin
      try
       repeat
        // Wenn es ein Verzeichnis ist, Rekursion verwenden
        if(SearchRec.Attr and faDirectory = faDirectory) then
         begin
          if((SearchRec.Name<>'.') and (SearchRec.Name<>'..')) then
           GetDirsEx(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name,
           Files, FileMask, SubFolders);
         end;
        until FindNext(SearchRec)<>0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
    end;
  end;
end;

// Alle Dateien aus einem Verzeichnis auslesen
procedure GetFiles(const Directory: string; var Files: TStringList;
  const FileMask: string = '*.*';  const SubFolders: Boolean = False);
var
 SearchRec: TSearchRec;
begin
  if(FindFirst(IncludeTrailingPathDelimiter(Directory)+FileMask, faAnyFile and
  not faDirectory and not faVolumeID, SearchRec) = 0) then
  begin
   try
    repeat
     Files.Add(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name);
    until (FindNext(SearchRec)<>0);
   finally
    SysUtils.FindClose(SearchRec);
   end;
  end;
 // Unterverzeichnisse
 if(SubFolders) then
  begin
   if(FindFirst(IncludeTrailingPathDelimiter(Directory)+'*.*', faAnyFile,
   SearchRec) = 0) then
    begin
     try
      repeat
       if((SearchRec.Attr and faDirectory) <> 0) then
        begin
         if((SearchRec.Name <> '.') and (SearchRec.Name <> '..')) then
          GetFiles(IncludeTrailingPathDelimiter(Directory)+SearchRec.Name,
          Files, FileMask, SubFolders);
        end;
      until FindNext(SearchRec) <> 0;
     finally
      SysUtils.FindClose(SearchRec);
     end;
  end;
 end;
end;

// Datei Kopieren
procedure CopyFile(filename, newfilename: String);
var
 oldfile, newfile: TFilestream;
begin
 oldfile:=TFileStream.Create(filename, fmOpenRead);
 try
  oldfile.Position:=0;
  newfile:=TFileStream.Create(newfilename, fmCreate);
  try
   newfile.CopyFrom(oldfile,oldfile.size);
  finally
   newfile.free;
  end;
 finally
  oldfile.free;
 end;
end;

// Verzeichnis kopieren
procedure CopyDir(OldDir, NewDir: String);
var
 i: Integer;
 sTempFiles: TStringList;
 sNewName, sNewFile: String;
begin
sTempFiles:=TStringList.Create;
try
 // Verzeichnisname
 sNewName:=ExtractFileName(OldDir);
 // Auslesen
 GetFiles(OldDir,sTempFiles,'*.*',true);
 // Kopieren
 for i:=0 to sTempFiles.Count-1 do
  begin
   // Neue Datei
   sNewFile:=IncludeTrailingPathDelimiter(NewDir)+sNewName+
   StringReplace(sTempFiles[i],OldDir,'',[]);
   // Verzeichnisse erstellen
   try
    ForceDirectories(ExtractFilePath(sNewFile));
   except
   end;
   // Kopieren
   CopyFile(sTempFiles[i],sNewFile);
  end;
finally
 sTempFiles.Free;
end;
end;

end.

