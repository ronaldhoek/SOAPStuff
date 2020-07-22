unit MainFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    mmResult: TMemo;
    rgTests: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses
  TestsU;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  GetTests(rgTests.Items);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  test: TTest;
begin
  if rgTests.ItemIndex = -1 then
    raise Exception.Create('No test selected');

  mmResult.Lines.Clear;

  test := TTestClass(rgTests.Items.Objects[rgTests.ItemIndex]).Create;
  try
    test.Run;
    if Assigned(test.RequestData) then
      mmResult.Lines.LoadFromStream(test.RequestData);
  finally
    test.Free;
  end;
end;

end.
