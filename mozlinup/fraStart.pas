unit fraStart;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  TFrame1 = class(TFrame)
    lblWelcome: TLabel;
    lblIntro: TLabel;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.xfm}

end.
