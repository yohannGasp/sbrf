program sbrf3ToBankier;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  tools in 'tools.pas',
  Unit3 in 'Unit3.pas',
  Unit4 in 'Unit4.pas' {AboutBox},
  Unit5 in 'Unit5.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'sbrf3ToBankier';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
