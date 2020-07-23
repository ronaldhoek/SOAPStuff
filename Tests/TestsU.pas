unit TestsU;

interface

uses
  System.Classes,
  Soap.SOAPHTTPClient;

type
  ITestService = interface(IInvokable)
    ['{8924BB9B-E71D-4EAD-BD1A-15EE11A21DBF}']
    function TestRequest: string; stdcall;
  end;

  TTest = class abstract
  private
    FRio: IInterface;
    FRequestData: TStream;
    procedure RioBeforeExecute(const MethodName: string; SOAPRequest: TStream);
  protected
    procedure DoRun; virtual; abstract;
    class procedure Register;
    class procedure Unregister;
    class function TestName: string; virtual;
    property Rio: IInterface read FRio;
  public
    procedure Run;
    destructor Destroy; override;
    property RequestData: TStream read FRequestData;
  end;

  TTestClass = class of TTest;

  procedure GetTests(aList: TStrings);

implementation

uses
  System.SysUtils, Soap.InvokeRegistry;

var
  _ClassList: TList;

procedure GetTests(aList: TStrings);
var
  I: Integer;
begin
  aList.BeginUpdate;
  try
    for I := 0 to _ClassList.Count - 1 do
      aList.AddObject(TTestClass(_ClassList[I]).TestName, _ClassList[I]);
  finally
    aList.EndUpdate;
  end;
end;

destructor TTest.Destroy;
begin
  FreeAndNil(FRequestData);
  inherited;
end;

procedure TTest.RioBeforeExecute(const MethodName: string; SOAPRequest:
    TStream);
begin
  if FRequestData = nil then
    FRequestData := TMemoryStream.Create
  else
    FRequestData.Size := 0;

  // Get request data
  TMemoryStream(FRequestData).LoadFromStream(SOAPRequest);
  Abort; // Wo don't want to actually send the request, just get the data
end;

{ TTest }

class procedure TTest.Register;
begin
  _ClassList.Add(Self)
end;

procedure TTest.Run;
var
  _rio: THTTPRIO;
begin
  _rio := THTTPRIO.Create(nil);
  FRio := _rio;
  _rio.URL := 'http://localhost';
  _rio.OnBeforeExecute := Self.RioBeforeExecute;
  try
    DoRun;
  except
    on EAbort do; // Continueau
    else raise;
  end;
end;

class function TTest.TestName: string;
begin
  Result := Self.ClassName;
  Delete(Result, 1, 1); // Remove 'T'
end;

class procedure TTest.Unregister;
begin
  if _ClassList <> nil then
    _ClassList.Remove(Self);
end;

initialization

  _ClassList := TList.Create;

  // Register test service
  InvRegistry.RegisterInterface(TypeInfo(ITestService), 'http://localhost/testservice', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ITestService), 'TestRequest');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ITestService), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(ITestService), ioLiteral);


finalization

  FreeAndNil(_ClassList);

end.
