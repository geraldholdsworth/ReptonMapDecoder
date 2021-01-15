unit OptionsUnit;

interface

uses
  Winapi.Windows,Winapi.Messages,System.SysUtils,System.Variants,System.Classes,
  Vcl.Controls,Vcl.Forms,Vcl.Dialogs,Vcl.ComCtrls,Vcl.StdCtrls,Vcl.ExtCtrls,
  Vcl.Graphics,RegUtils;

type
  TOptionsForm = class(TForm)
    rg_CharRef: TRadioGroup;
    rg_puzzlepiece: TRadioGroup;
    GroupBox1: TGroupBox;
    pixel_match_slider: TTrackBar;
    prob_match_slider: TTrackBar;
    Label5: TLabel;
    lb_prob_match: TLabel;
    repton_match_slider: TTrackBar;
    Label10: TLabel;
    lb_repton_match: TLabel;
    Label12: TLabel;
    lb_pixel_match: TLabel;
    procedure prob_match_sliderChange(Sender: TObject);
    procedure repton_match_sliderChange(Sender: TObject);
    procedure pixel_match_sliderChange(Sender: TObject);
    procedure rg_CharRefClick(Sender: TObject);
    procedure rg_puzzlepieceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsForm: TOptionsForm;

implementation

{$R *.dfm}

uses MainUnit;

{-------------------------------------------------------------------------------
The Character Match slider is changing
-------------------------------------------------------------------------------}
procedure TOptionsForm.prob_match_sliderChange(Sender: TObject);
begin
 MainForm.prob_match           :=prob_match_slider.Position;
 lb_prob_match.Caption:=IntToStr(MainForm.prob_match)+'%';
 SetRegValI('ProbMatch',MainForm.prob_match);
end;

{-------------------------------------------------------------------------------
The Repton Match slider is changing
-------------------------------------------------------------------------------}
procedure TOptionsForm.repton_match_sliderChange(Sender: TObject);
begin
 MainForm.repton_match           :=repton_match_slider.Position;
 lb_repton_match.Caption:=IntToStr(MainForm.repton_match)+'%';
 SetRegValI('ReptonMatch',MainForm.repton_match);
end;

{-------------------------------------------------------------------------------
The Pixel Match slider is changing
-------------------------------------------------------------------------------}
procedure TOptionsForm.pixel_match_sliderChange(Sender: TObject);
begin
 MainForm.pix_match             :=pixel_match_slider.Position;
 lb_pixel_match.Caption:=IntToStr(MainForm.pix_match)+'%';
 SetRegValI('PixelMatch',MainForm.pix_match);
end;

{-------------------------------------------------------------------------------
The CSV specifications have changed
-------------------------------------------------------------------------------}
procedure TOptionsForm.rg_CharRefClick(Sender: TObject);
begin
 SetRegValI('CharRef',rg_CharRef.ItemIndex);
end;

{-------------------------------------------------------------------------------
The unknown character specification has changed
-------------------------------------------------------------------------------}
procedure TOptionsForm.rg_puzzlepieceClick(Sender: TObject);
begin
 MainForm.puzzpiece:=rg_puzzlepiece.ItemIndex=1;
 MainForm.SetRegistry;
end;

end.
