unit fraSelectProfile;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, functions;

type
  TfraSelect = class(TFrame)
    lblInfo: TLabel;
    lsProfiles: TListBox;
    cmdRefresh: TButton;
    cmdNewProfile: TButton;
    lblSelect: TLabel;
    fraSelect: TGroupBox;
    lblPath: TLabel;
    cmdBrowse: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation


{$R *.xfm}

end.


