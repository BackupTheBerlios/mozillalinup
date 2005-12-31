{
  Project:   DiffMozSaver
  Unit:      frmPrefEditor

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

unit frmPrefEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  mozprefparser, ComCtrls, StdCtrls, Buttons;

type

  { TPrefEditor }

  TPrefEditor = class(TForm)
   cmdOk: TButton;
   cmdAbort: TButton;
   lblInfo: TLabel;
   lsEdit: TListView;
   procedure FormDestroy(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure cmdAbortClick(Sender: TObject);
   procedure cmdOkClick(Sender: TObject);
  private
    MozPrefParser: TMozPrefParser;
    sPrefFile: String;
  public
    function Show(sFile: String): Integer;
  end; 

var
  PrefEditor: TPrefEditor;

implementation

{ TPrefEditor }

procedure TPrefEditor.FormShow(Sender: TObject);
var
 i: Integer;
 Item: TListItem;
begin
 // Parser erstellen
 MozPrefParser:=TMozPrefParser.Create(sPrefFile);
 // Laden
 for i:=0 to MozPrefParser.Count do
  begin
   Item:=lsEdit.Items.Add;
   Item.Caption:=MozPrefParser.Preferences[i].Name;
   Item.SubItems.Add(MozPrefParser.Preferences[i].Value);
  end;
end;

procedure TPrefEditor.cmdAbortClick(Sender: TObject);
begin
 // Schlieﬂen
 Close;
end;

procedure TPrefEditor.cmdOkClick(Sender: TObject);
var
 i: Integer;
 Preferences: TMozPreferences;
begin
 // ‹bernehmen
 SetLength(Preferences,lsEdit.Items.Count-1);
 for i:=0 to lsEdit.Items.Count-1 do
  begin
   Preferences[i].Name:=lsEdit.Items[i].Caption;
   Preferences[i].Value:=lsEdit.Items[i].SubItems[0];
  end;
 // Speichern
 MozPrefParser.SavePreferences(Preferences, sPrefFile);
 // Schlieﬂen
 Close;
end;

procedure TPrefEditor.FormDestroy(Sender: TObject);
begin
 // Parser freigeben
 MozPrefParser.Free;
end;

function TPrefEditor.Show(sFile: String): Integer;
begin
 PrefEditor:=TPrefEditor.Create(Application);
 PrefEditor.sPrefFile:=sFile;
 PrefEditor.ShowModal;
 PrefEditor.Free;
 Result:=0;
end;

initialization
  {$I frmprefeditor.lrs}

end.

