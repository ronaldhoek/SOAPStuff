program SOAPTests;

uses
  Vcl.Forms,
  MainFormU in 'MainFormU.pas' {Form1},
  TestsU in 'TestsU.pas',
  TestWSSecHeaderU in 'TestWSSecHeaderU.pas',
  WSSecurity200306 in '..\WSSecurity200306.pas',
  WSSecurity200401 in '..\WSSecurity200401.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
