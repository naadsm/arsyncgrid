program SyncGridDemo;

uses
  Forms,
  DebugWindow,
  Unit1 in 'Unit1.pas' {Form1}
;

{$R *.res}

begin
  setDEBUGGING( true );

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
