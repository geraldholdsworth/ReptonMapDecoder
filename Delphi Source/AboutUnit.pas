unit AboutUnit;

interface

uses
  Winapi.Windows,Winapi.Messages,System.SysUtils,System.Variants,System.Classes,
  Vcl.Graphics,Vcl.Controls,Vcl.Forms,Vcl.Dialogs,Vcl.ExtCtrls,Vcl.StdCtrls;

type
  TAboutForm = class(TForm)
    about_panel: TPanel;
    lb_title: TLabel;
    Label3: TLabel;
    lb_version: TLabel;
    Label2: TLabel;
    Image3: TImage;
    Image4: TImage;
    Label9: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

end.
