{
  Project:   DiffMozSaver
  Unit:      frmPassDlg

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

unit frmPassDlg;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, language;

type

  { TPassDlg }

  TPassDlg = class(TForm)
   cmdOk: TButton;
   cmdAbort: TButton;
   lblPass2: TLabel;
   Pass1: TEdit;
   fraPassword: TGroupBox;
   lblPass1: TLabel;
   Pass2: TEdit;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure cmdAbortClick(Sender: TObject);
   procedure cmdOkClick(Sender: TObject);
  private
    LanguageHandling: TLanguageHandling;
  public
    function Show: String;
  end; 

var
  PassDlg: TPassDlg;

implementation

{ TPassDlg }

procedure TPassDlg.cmdAbortClick(Sender: TObject);
begin
 // Schließen
 Pass1.Text:='';
 Pass2.Text:='';
 Close;
end;

procedure TPassDlg.FormCreate(Sender: TObject);
begin
 // Language
 LanguageHandling:=TLanguageHandling.Create;
end;

procedure TPassDlg.FormDestroy(Sender: TObject);
begin
 // Language freigeben
 if(Assigned(LanguageHandling)) then
  LanguageHandling.Free;
end;

procedure TPassDlg.FormShow(Sender: TObject);
begin
 // Sprache Laden
 LanguageHandling.GetLanguage(Self);
end;

procedure TPassDlg.cmdOkClick(Sender: TObject);
begin
 // Überprüfen
 if(Pass1.Text<>Pass2.Text) then
  begin
   MessageDlg(LanguageHandling.GetStatusMSG('8'),
   mtWarning, [mbOK], 0);
  end
 else
  Close;
end;

function TPassDlg.Show: String;
begin
 PassDlg:=TPassDlg.Create(Application);
 PassDlg.ShowModal;
 Result:=PassDlg.Pass1.Text;
 PassDlg.Free;
end;

initialization
  {$I frmpassdlg.lrs}

end.

