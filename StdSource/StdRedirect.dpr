program StdRedirect;

uses
  Forms,
  Main in 'Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Демо чтения / записи в StdIn/StdOut процесса';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
