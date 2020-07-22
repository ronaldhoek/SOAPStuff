unit WSSecurity200401;

interface

uses
  System.SysUtils, System.Types,
  Soap.InvokeRegistry, Soap.SOAPHTTPClient, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_ATTR = $0010;
  IS_TEXT = $0020;
  IS_REF = $0080;
  IS_QUAL = $0100;

type
  AttributedString = class(TRemotable)
  private
    FText: WideString;
    FId: WideString;
    FId_Specified: boolean;
    procedure SetId(Index: Integer; const AId: WideString);
    function Id_Specified(Index: Integer): boolean;
  published
    property Text: WideString Index(IS_TEXT)read FText write FText;
    property Id: WideString Index(IS_ATTR or IS_OPTN)read FId write SetId
      stored Id_Specified;
  end;

  UsernameString = class(AttributedString)
  private
    FType_: WideString;
    FType__Specified: boolean;
    procedure SetType_(Index: Integer; const AWideString: WideString);
    function Type__Specified(Index: Integer): boolean;
  published
    property Type_: WideString Index(IS_ATTR or IS_OPTN)read FType_
      write SetType_ stored Type__Specified;
  end;

  PasswordString = class(AttributedString)
  private
    FType_: WideString;
    FType__Specified: boolean;
    procedure SetType_(Index: Integer; const AWideString: WideString);
    function Type__Specified(Index: Integer): boolean;
  published
    property Type_: WideString Index(IS_ATTR or IS_OPTN)read FType_
      write SetType_ stored Type__Specified;
  end;

  // ************************************************************************ //
  // XML       : UsernameTokenType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  UsernameTokenType = class(TRemotable)
  private
    FId: WideString;
    FId_Specified: boolean;
    FUsername: UsernameString;
    FPassword: PasswordString;
    procedure SetId(Index: Integer; const AId: WideString);
    function Id_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Id: WideString Index(IS_ATTR or IS_OPTN)read FId write SetId
      stored Id_Specified;
    property Username: UsernameString read FUsername write FUsername;
    property Password: PasswordString read FPassword write FPassword;
  end;

  // ************************************************************************ //
  // XML       : UsernameToken, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  UsernameToken = class(UsernameTokenType)
  private
  published
  end;

  Security = class(TSOAPHeader)
  private
    FUserNameToken: UsernameToken;
  public
    destructor Destroy; override;
  published
    property UsernameToken: UsernameToken index(IS_REF)read FUserNameToken
      write FUserNameToken;
  end;

const
  NS_SECEXT =
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
  NS_UTILITY =
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';

implementation

{ AttributedString }

procedure AttributedString.SetId(Index: Integer; const AId: WideString);
begin
  FId := AId;
  FId_Specified := True;
end;

function AttributedString.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

{ UsernameString }

procedure UsernameString.SetType_(Index: Integer;
  const AWideString: WideString);
begin
  FType_ := AWideString;
  FType__Specified := True;
end;

function UsernameString.Type__Specified(Index: Integer): boolean;
begin
  Result := FType__Specified;
end;

{ PasswordString }

procedure PasswordString.SetType_(Index: Integer;
  const AWideString: WideString);
begin
  FType_ := AWideString;
  FType__Specified := True;
end;

function PasswordString.Type__Specified(Index: Integer): boolean;
begin
  Result := FType__Specified;
end;

{ UsernameTokenType }

destructor UsernameTokenType.Destroy;
begin
  FreeAndNIL(FUsername);
  FreeAndNIL(FPassword);
  inherited Destroy;
end;

procedure UsernameTokenType.SetId(Index: Integer; const AId: WideString);
begin
  FId := AId;
  FId_Specified := True;
end;

function UsernameTokenType.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

{ Security }

destructor Security.Destroy;
begin
  FreeAndNil(FUserNameToken);
  inherited Destroy;
end;

initialization

RemClassRegistry.RegisterXSClass(Security, NS_SECEXT, 'Security');
RemClassRegistry.RegisterXSClass(UsernameToken, NS_SECEXT, 'UsernameToken');

RemClassRegistry.RegisterXSClass(UsernameTokenType, NS_SECEXT, 'UsernameTokenType');
RemClassRegistry.RegisterExternalPropName(TypeInfo(UsernameTokenType), 'Id', '[Namespace="' + NS_UTILITY + '"]');

RemClassRegistry.RegisterXSClass(UsernameString, NS_SECEXT, 'Username');
RemClassRegistry.RegisterExternalPropName(TypeInfo(UsernameString), 'Type_', 'Type');

RemClassRegistry.RegisterXSClass(PasswordString, NS_SECEXT, 'Password');
RemClassRegistry.RegisterExternalPropName(TypeInfo(PasswordString), 'Type_', 'Type');

RemClassRegistry.RegisterXSClass(AttributedString, NS_SECEXT, 'AttributedString');
RemClassRegistry.RegisterExternalPropName(TypeInfo(AttributedString), 'Id', '[Namespace="' + NS_UTILITY + '"]');

end.
