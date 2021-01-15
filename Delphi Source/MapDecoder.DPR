program MapDecoder;



{$R *.dres}

uses
  Forms,
  MainUnit in 'MainUnit.PAS' {MainForm},
  RegUtils in 'RegUtils.pas',
  BulkConvUnit in 'BulkConvUnit.pas' {BulkConvForm},
  Vcl.Themes,
  Vcl.Styles,
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  OptionsUnit in 'OptionsUnit.pas' {OptionsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Repton Map Decoder';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TBulkConvForm, BulkConvForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.Run;
end.
 
