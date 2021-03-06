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
  // ************************************************************************ //
  // XML       : AttributedString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  AttributedString = class(TRemotable)
  private
    FText: WideString;
    FId: WideString;
    FId_Specified: boolean;
    procedure SetId(Index: Integer; const AId: WideString);
    function Id_Specified(Index: Integer): boolean;
  published
    property Text: WideString Index(IS_TEXT) read FText write FText;
    property Id: WideString Index(IS_ATTR or IS_OPTN) read FId write SetId
      stored Id_Specified;
  end;

  // ************************************************************************ //
  // XML       : EncodedString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  EncodedString = class(AttributedString)
  private
    FEncodingType: WideString;
    FEncodingType_Specified: boolean;
    function EncodingType_Specified(Index: Integer): boolean;
  private
    procedure SetEncodingType(Index: Integer; const AWideString: WideString);
  published
    property EncodingType: WideString Index(IS_ATTR or IS_OPTN) read FEncodingType
      write SetEncodingType stored EncodingType_Specified;
  end;

  // ************************************************************************ //
  // XML       : UsernameString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  UsernameString = class(AttributedString)
  private
    FType_: WideString;
    FType__Specified: boolean;
    procedure SetType_(Index: Integer; const AWideString: WideString);
    function Type__Specified(Index: Integer): boolean;
  published
    property Type_: WideString Index(IS_ATTR or IS_OPTN) read FType_
      write SetType_ stored Type__Specified;
  end;

  // ************************************************************************ //
  // XML       : PasswordString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  PasswordString = class(AttributedString)
  private
    FType_: WideString;
    FType__Specified: boolean;
    procedure SetType_(Index: Integer; const AWideString: WideString);
    function Type__Specified(Index: Integer): boolean;
  published
    property Type_: WideString Index(IS_ATTR or IS_OPTN) read FType_
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


  // ************************************************************************ //
  // XML       : BinarySecurityTokenType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  BinarySecurityTokenType = class(EncodedString)
  private
    FValueType: WideString;
    FValueType_Specified: boolean;
    procedure SetValueType_(Index: Integer; const AWideString: WideString);
    function ValueType_Specified(Index: Integer): boolean;
  published
    property ValueType_: WideString index (IS_ATTR or IS_OPTN) read FValueType
      write SetValueType_ stored ValueType_Specified;
  end;


  // ************************************************************************ //
  // XML       : BinarySecurityToken, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  BinarySecurityToken = class(BinarySecurityTokenType)
  private
  published
  end;


  Security = class(TSOAPHeader)
  private
    FBinarySecurityToken: BinarySecurityToken;
    FUserNameToken: UsernameToken;
    function BinarySecurityToken_Specified(Index: Integer): Boolean;
    function UsernameToken_Specified(Index: Integer): Boolean;
  public
    destructor Destroy; override;
  published
    property BinarySecurityToken: BinarySecurityToken index(IS_REF or IS_OPTN)
      read FBinarySecurityToken write FBinarySecurityToken stored BinarySecurityToken_Specified;
    property UsernameToken: UsernameToken index(IS_REF or IS_OPTN)
      read FUserNameToken write FUserNameToken stored UsernameToken_Specified;
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

{ EncodedString }

procedure EncodedString.SetEncodingType(Index: Integer; const AWideString:
    WideString);
begin
  FEncodingType := AWideString;
  FEncodingType_Specified := True;
end;

function EncodedString.EncodingType_Specified(Index: Integer): boolean;
begin
  Result := FEncodingType_Specified;
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

{ BinarySecurityTokenType }

procedure BinarySecurityTokenType.SetValueType_(Index: Integer; const
    AWideString: WideString);
begin
  FValueType := AWideString;
  FValueType_Specified := True;
end;

function BinarySecurityTokenType.ValueType_Specified(Index: Integer): boolean;
begin
  Result := FValueType_Specified;
end;

{ Security }

destructor Security.Destroy;
begin
  FreeAndNil(FBinarySecurityToken);
  FreeAndNil(FUserNameToken);
  inherited Destroy;
end;

function Security.BinarySecurityToken_Specified(Index: Integer): Boolean;
begin
  Result := FBinarySecurityToken <> nil;
end;

function Security.UsernameToken_Specified(Index: Integer): Boolean;
begin
  Result := FUserNameToken <> nil;
end;

initialization

RemClassRegistry.RegisterXSClass(Security, NS_SECEXT, 'Security');

RemClassRegistry.RegisterXSClass(BinarySecurityToken, NS_SECEXT, 'BinarySecurityToken');
RemClassRegistry.RegisterXSClass(BinarySecurityTokenType, NS_SECEXT, 'BinarySecurityTokenType');

RemClassRegistry.RegisterXSClass(UsernameToken, NS_SECEXT, 'UsernameToken');
RemClassRegistry.RegisterXSClass(UsernameTokenType, NS_SECEXT, 'UsernameTokenType');
RemClassRegistry.RegisterExternalPropName(TypeInfo(UsernameTokenType), 'Id', '[Namespace="' + NS_UTILITY + '"]');

RemClassRegistry.RegisterXSClass(UsernameString, NS_SECEXT, 'Username');
RemClassRegistry.RegisterExternalPropName(TypeInfo(UsernameString), 'Type_', 'Type');

RemClassRegistry.RegisterXSClass(PasswordString, NS_SECEXT, 'Password');
RemClassRegistry.RegisterExternalPropName(TypeInfo(PasswordString), 'Type_', 'Type');

RemClassRegistry.RegisterXSClass(EncodedString, NS_SECEXT, 'EncodedString');
RemClassRegistry.RegisterXSClass(EncodedString, NS_SECEXT, 'Nonce');

RemClassRegistry.RegisterXSClass(AttributedString, NS_SECEXT, 'AttributedString');
RemClassRegistry.RegisterExternalPropName(TypeInfo(AttributedString), 'Id', '[Namespace="' + NS_UTILITY + '"]');

end.
