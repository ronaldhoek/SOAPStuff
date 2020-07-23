unit TestWSSecHeaderU;

interface

uses
  TestsU;

type
  TTestWSSec200401_UsernameToken = class(TTest)
  protected
    procedure DoRun; override;
  end;

  TTestWSSec200401_BinarySecurityToken = class(TTest)
  protected
    procedure DoRun; override;
  end;

implementation

uses
  WSSecurity200401, Soap.InvokeRegistry;

{ TTestWSSec200401_UsernameToken }

procedure TTestWSSec200401_UsernameToken.DoRun;
var
  _Svc: ITestService;
  hdr: Security;
begin
  _Svc := Rio as ITestService;
  hdr := Security.Create;
  try
    hdr.UsernameToken := UsernameToken.Create;
    hdr.UsernameToken.Username := UsernameString.Create;
    hdr.UsernameToken.Username.Id := 'UsernameID';
    hdr.UsernameToken.Username.Type_ := 'UsernameType';
    hdr.UsernameToken.Username.Text := 'MyUsername';
    hdr.UsernameToken.Password := PasswordString.Create;
    hdr.UsernameToken.Password.Id := 'PasswordID';
    hdr.UsernameToken.Password.Type_ := 'PasswordType';
    hdr.UsernameToken.Password.Text := 'MyPassword';

    (_Svc as ISOAPHeaders).Send(hdr);

    _Svc.TestRequest;
  finally
    hdr.Free;
  end;
end;

{ TTestWSSec200401_BinarySecurityToken }

procedure TTestWSSec200401_BinarySecurityToken.DoRun;
var
  _Svc: ITestService;
  hdr: Security;
begin
  _Svc := Rio as ITestService;
  hdr := Security.Create;
  try
    hdr.BinarySecurityToken := BinarySecurityToken.Create;
    hdr.BinarySecurityToken.EncodingType := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
    hdr.BinarySecurityToken.ValueType_ := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509';
    hdr.BinarySecurityToken.Id := 'x509cert00';
    hdr.BinarySecurityToken.Text :=
      'CjxhdXRoPgoJPGlkIHVuaXF1ZV9pZD0iMTYwMTE4MTMwIiBzcmM9IkM9UFksIE89ZG5hLCBP' +
      'VT1zb2ZpYSwgQ049d3NhYXRlc3QiIGdlbl90aW1lPSIyMDIwLTA3LTIwVDE1OjUzOjMyLjAx' +
      'MC0wNDowMCIgZXhwX3RpbWU9IjIwMjAtMDctMjFUMTU6NTM6MzIuMDEwLTA0OjAwIi8+Cgk8' +
      'b3BlcmF0aW9uIHZhbHVlPSJncmFudGVkIiB0eXBlPSJsb2dpbiI+CgkJPGxvZ2luIHVpZD0i' +
      'Qz1QWSwgTz1ETlJBLCBPVT1USSwgQ049ZG5yYSIgc2VydmljZT0ic2VydmljaW9jZXJuYWMi' +
      'IGF1dGhtZXRob2Q9ImNtcyI+CgkJPC9sb2dpbj4KCTwvb3BlcmF0aW9uPgo8L2F1dGg+Cg==';

    (_Svc as ISOAPHeaders).Send(hdr);

    _Svc.TestRequest;
  finally
    hdr.Free;
  end;
end;

initialization

  TTestWSSec200401_UsernameToken.Register;
  TTestWSSec200401_BinarySecurityToken.Register;

finalization

  TTestWSSec200401_UsernameToken.Unregister;
  TTestWSSec200401_BinarySecurityToken.Unregister;

end.
