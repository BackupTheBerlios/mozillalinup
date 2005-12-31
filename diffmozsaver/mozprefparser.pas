{
  Project:   DiffMozSaver
  Unit:      mozprefparser

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

unit mozprefparser;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, StrUtils;

  type
   TMozPref = record
    Name: String;
    Value: String;
  end;
  
  type
   TMozPreferences = array of TMozPref;

  type

   { TMozPrefParser }

   TMozPrefParser = class(TObject)
    private
     sPrefFile: String;
     procedure LoadPreferences;
    public
     Count: Integer;
     Preferences: TMozPreferences;
     procedure SavePreferences(Preferences: TMozPreferences; sFile: String);
     constructor Create(sFile: String);
  end;

implementation

{ TMozPrefParser }

procedure TMozPrefParser.LoadPreferences;
var
 i: Integer;
 sTemp: TStringList;
begin
sTemp:=TStringList.Create;
try
 sTemp.LoadFromFile(sPrefFile);
 // Ungültige Zeilen Entfernen
 for i:=sTemp.Count-1 downto 0 do
  begin
   if(LeftStr(sTemp[i],9)<>'user_pref') then
    sTemp.Delete(i);
  end;
 // Laden
 SetLength(Preferences,sTemp.Count);
 Count:=high(Preferences);
 for i:=0 to sTemp.Count-1 do
  begin
   // Name
   Preferences[i].Name:=copy(sTemp[i],pos('"',sTemp[i])+1,
   posex('"',sTemp[i],pos('"',sTemp[i])+1)-pos('"',sTemp[i])-1);
   // Wert
   Preferences[i].Value:=copy(sTemp[i],pos(', ',sTemp[i])+2,
   posex(');',sTemp[i],pos(', ',sTemp[i])+2)-pos(', ',sTemp[i])-2);
  end;
finally
 sTemp.Free;
end;
end;

procedure TMozPrefParser.SavePreferences(Preferences: TMozPreferences;
 sFile: String);
var
 i: Integer;
 sTemp: TStringList;
begin
if(high(Preferences)=-1) then exit;
sTemp:=TStringList.Create;
try
 // Formatieren
 sTemp.Add('# Mozilla User Preferences');
 for i:=0 to high(Preferences) do
  begin
   sTemp.Add('user_pref("'+Preferences[i].Name+'", "'+
   Preferences[i].Value+'");');
  end;
 // Speichern
 try
  sTemp.SaveToFile(sFile);
 except
  raise Exception.CreateFmt('Datei konnte nicht gespeichert werden: ''%s''',
  [sFile]);
 end;
finally
 sTemp.Free;
end;
end;

constructor TMozPrefParser.Create(sFile: String);
begin
 if(FileExists(sFile)=false) then
  begin
   // Datei nicht gefunden
   raise Exception.CreateFmt('Datei nicht gefunden: ''%s''', [sFile]);
  end
 else
  begin
   // Einstellungsdatei
   sPrefFile:=sFile;
   // Einstellungen Laden
   LoadPreferences;
  end;
end;

end.

