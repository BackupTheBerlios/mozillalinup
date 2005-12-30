{
  Project:   DiffMozSaver
  Unit:      apphandler

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

unit apphandler;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Process;

  type
   TAppType = (appFirefox, appThunderbird);

  type
   TAppData = record
    Name: String;
    Path: String;
    AppType: TAppType;
  end;
  
  type
   TAppDataInfo = array of TAppData;

  type

   { TAppHandling }

   TAppHandling = class(TObject)
    private
     AppDataInfo: TAppDataInfo;
     function GetHomePath: String;
    public
     function GetAvailibleApps: TAppDataInfo;
     function AppNameToPath(Name: String): String;
     function AppNameToAppType(Name: String): TAppType;
     function IsFirefoxRunning: Boolean;
     function IsThunderbirdRunning: Boolean;
     procedure GetProfiles(Path: String; s: TStrings);
  end;

implementation

uses
 functions;

{ TAppHandling }

function TAppHandling.GetHomePath: String;
begin
{$IfDef Win32}
Result:=IncludeTrailingPathDelimiter(GetEnvironmentVariable('APPDATA'));
{$ELSE}
Result:=GetEnvironmentVariable('HOME');
{$EndIf}
end;

function TAppHandling.GetAvailibleApps: TAppDataInfo;
var
 i: Integer;
 sPath: String;
 sSubFolders: TStringList;
begin
// Anwendungsverzeichnis
sPath:=GetHomePath;
{$IfDef Win32}
 // Unterverzeichnisse
 sSubFolders:=TStringList.Create;
 try
  GetDirs(sPath,sSubFolders,'*.*',true);
  // Firefox
  for i:=0 to sSubFolders.Count-1 do
   begin
    if(pos('firefox',lowercase(sSubFolders[i]))<>0) then
     begin
      if(high(Result)=-1) then
       SetLength(Result,1)
      else
       SetLength(Result,high(Result)+2);
      Result[high(Result)].Name:='Mozilla Firefox';
      Result[high(Result)].Path:=IncludeTrailingPathDelimiter(sSubFolders[i])+
      'Profiles';
      Result[high(Result)].AppType:=appFirefox;
      break;
     end;
   end;
  // Thunderbird
  for i:=0 to sSubFolders.Count-1 do
   begin
    if(pos('thunderbird',lowercase(sSubFolders[i]))<>0) then
     begin
      if(high(Result)=-1) then
       SetLength(Result,1)
      else
       SetLength(Result,high(Result)+2);
      Result[high(Result)].Name:='Mozilla Thunderbird';
      Result[high(Result)].Path:=IncludeTrailingPathDelimiter(sSubFolders[i])+
      'Profiles';
      Result[high(Result)].AppType:=appThunderbird;
      break;
     end;
   end;
 finally
  sSubFolders.Free;
 end;
{$Else}
 // Firefox
 if(DirectoryExists(IncludeTrailingPathDelimiter(sPath)+
 '.mozilla/firefox')) then
  begin
   if(high(Result)=-1) then
    SetLength(Result,1)
   else
    SetLength(Result,high(Result)+2);
   Result[high(Result)].Name:='Mozilla Firefox';
   Result[high(Result)].Path:=IncludeTrailingPathDelimiter(sPath)+
   '.mozilla/firefox';
   Result[high(Result)].AppType:=appFirefox;
  end;
 // Thunderbird
 if(DirectoryExists(IncludeTrailingPathDelimiter(sPath)+
 '.mozilla-thunderbird')) then
  begin
   if(high(Result)=-1) then
    SetLength(Result,1)
   else
    SetLength(Result,high(Result)+2);
   Result[high(Result)].Name:='Mozilla Thunderbird';
   Result[high(Result)].Path:=IncludeTrailingPathDelimiter(sPath)+
   '.mozilla-thunderbird';
   Result[high(Result)].AppType:=appThunderbird;
  end;
{$EndIF}
end;

function TAppHandling.AppNameToPath(Name: String): String;
var
 i: Integer;
 AppDataInfo: TAppDataInfo;
begin
Result:='';
AppDataInfo:=GetAvailibleApps;
for i:=0 to high(AppDataInfo) do
 begin
  if(AppDataInfo[i].Name=Name) then
   begin
    Result:=AppDataInfo[i].Path;
    break;
   end;
 end;
end;

function TAppHandling.AppNameToAppType(Name: String): TAppType;
var
 i: Integer;
 AppDataInfo: TAppDataInfo;
begin
AppDataInfo:=GetAvailibleApps;
for i:=0 to high(AppDataInfo) do
 begin
  if(AppDataInfo[i].Name=Name) then
   begin
    Result:=AppDataInfo[i].AppType;
    break;
   end;
 end;
end;

function TAppHandling.IsFirefoxRunning: Boolean;
var
 i: Integer;
 AppDataInfo: TAppDataInfo;
 sTemp: TStringList;
 AProcess: TProcess;
begin
AppDataInfo:=GetAvailibleApps;
for i:=0 to high(AppDataInfo) do
 begin
  //break;
  if(AppDataInfo[i].Name='Mozilla Firefox') then
   begin
    // Pr¸fen
    {$IfDef Win32}
     sTemp:=TStringList.Create;
     try
      GetFiles(AppDataInfo[i].Path,sTemp,'*.lock',false);
      if(sTemp.Count>0) then
       Result:=true
      else
       Result:=false;
     finally
      sTemp.Free;
     end;
    {$Else}
     AProcess:=TProcess.Create(nil);
     try
      sTemp:=TStringList.Create;
      try
       AProcess.CommandLine:='ps ux';
       AProcess.Options:=AProcess.Options+[poWaitOnExit, poUsePipes];
       AProcess.Execute;
       // Warten bis fertig
       sTemp.LoadFromStream(AProcess.Output);
       // Pr√ºfen
       if(pos('mozilla-firefox',sTemp.Text)<>0) then
        Result:=true
       else
        Result:=false;
      finally
       sTemp.Free;
      end;
     finally
      AProcess.Free;
     end;
    {$EndIf}
    break;
   end;
 end;
end;

function TAppHandling.IsThunderbirdRunning: Boolean;
var
 i: Integer;
 AppDataInfo: TAppDataInfo;
 sTemp: TStringList;
 AProcess: TProcess;
begin
Result:=true;
AppDataInfo:=GetAvailibleApps;
for i:=0 to high(AppDataInfo) do
 begin
  if(AppDataInfo[i].Name='Mozilla Thunderbird') then
   begin
    // Pr¸fen
    {$IfDef Win32}
     sTemp:=TStringList.Create;
     try
      GetFiles(AppDataInfo[i].Path,sTemp,'*.lock',true);
      if(sTemp.Count>0) then
       Result:=true
      else
       Result:=false;
     finally
      sTemp.Free;
     end;
    {$Else}
     AProcess:=TProcess.Create(nil);
     try
      sTemp:=TStringList.Create;
      try
       AProcess.CommandLine:='ps ux';
       AProcess.Options:=AProcess.Options+[poWaitOnExit, poUsePipes];
       AProcess.Execute;
       // Warten bis fertig
       sTemp.LoadFromStream(AProcess.Output);
       // Pr√ºfen
       if(pos('mozilla-thunderbird',sTemp.Text)<>0) then
        Result:=true
       else
        Result:=false;
      finally
       sTemp.Free;
      end;
     finally
      AProcess.Free;
     end;
    {$EndIf}
    break;
   end;
 end;
end;

procedure TAppHandling.GetProfiles(Path: String; s: TStrings);
begin
GetDirsEx(Path,s,'*.*',false);
end;

end.

