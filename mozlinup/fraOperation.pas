unit fraOperation;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TOperation = class(TFrame)
    lblChoose: TLabel;
    fraOperation: TRadioGroup;
    lblInfo: TLabel;
    fraPrograms: TListBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.xfm}

end.
