program ecmd;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FMain},
  UChildProc in 'UChildProc.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
