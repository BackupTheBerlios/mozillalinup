unit LinuxFormManager;

interface

implementation

{$IFDEF LINUX}
uses
  QGraphics, QForms, QControls;

type
  TmuLinuxFormManager = class(TObject)
    AdjustedFontSize: boolean;
    procedure ActiveFormChange(Sender: TObject);
    procedure AdjustFontSize;
    constructor Create;
  end;

var
  muLinuxFormManager: TmuLinuxFormManager;

{TmuLinuxFormManager}
constructor TmuLinuxFormManager.Create;
begin
  AdjustedFontSize := false;
end;

procedure TmuLinuxFormManager.AdjustFontSize;
var
  ActiveForm: TForm;
begin
  ActiveForm := Screen.ActiveForm;

  // fix the font size so that everything looks 'normal'
  Application.Font.Name := 'adobe-helvetica';
  ActiveForm.Font.Name  := 'adobe-helvetica';
  ActiveForm.Font.Size  := 12;

  try
    while Screen.ActiveForm.Canvas.TextWidth('OOOOOOOOOO') > 100 do begin
      Screen.ActiveForm.Font.Size := Screen.ActiveForm.Font.Size - 1;
    end;
  finally
    Application.Font.Size := ActiveForm.Font.Size;
    AdjustedFontSize      := true;
    ActiveForm.ParentFont := true;
  end;
end;

procedure TmuLinuxFormManager.ActiveFormChange(Sender: TObject);
var
  ActiveForm: TForm;
begin
  if assigned(Screen.ActiveForm) then begin
    ActiveForm := Screen.ActiveForm;

    if not AdjustedFontSize then begin
      AdjustFontSize;
    end;

    // We've adjusted the global font (Application object) so now make sure
    // that every form inherits its font from the Applcation Font object

    // Pretend we're changing the font name. This causes the ParentFont
    // property to briefly change to False ...
    ActiveForm.Font.Name := 'helvetica';
    // ...then set the ParentFont to true and the form adopts the correct values.
    ActiveForm.ParentFont := true;
    // We needed to do it this way because behind the scenes Delphi/Kylix will only
    // refresh the display if thinks the font actually changed

    // make sure that forms that shouldn't be resized CAN'T be resized
    if (ActiveForm.BorderStyle in [fbsDialog, fbsSingle]) then begin
      ActiveForm.Constraints.MinHeight  := ActiveForm.Height;
      ActiveForm.Constraints.MaxHeight  := ActiveForm.Height;
      ActiveForm.Constraints.MinWidth   := ActiveForm.Width;
      ActiveForm.Constraints.MaxWidth   := ActiveForm.Width;
    end;
  end;
end;

{$ENDIF}

initialization
{$IFDEF LINUX}
  muLinuxFormManager := TmuLinuxFormManager.Create;
  Screen.OnActiveFormChange := muLinuxFormManager.ActiveFormChange;
{$ENDIF}

finalization
{$IFDEF LINUX}
  muLinuxFormManager.Free;
{$ENDIF}

end.
