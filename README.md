# SOAP Stuff
I've seen plenty of SOAP related questions for Delphi.
Using this repository I'm sharing some of that stuff for users to get started with more ease.

# SOAP Headers
SOAP HEeders are also inheriting from `TRemotable` but you need use `TSOAPHeader` as base class, which is locate in `Soap.InvokeRegistry`.
From there on it's no different then creating other 'remotable' classes:

```Delphi
  TMySoapHeader = class(TSOAPHeader)
  private
    FSomeData: string;
  published
    property SomeData: string read FSomeData write FSomeData;
  end;
```

## Client use
SOAP Headers are NOT automatically created by the WDSL importer of Delphi.
Therefor you need to manually create then AND then know how to attach them to your request before sending the request.

To attach a SOAP header you need to access the SOAP header interface `ISOAPHeaders` which is also locate in `Soap.InvokeRegistry`.

To add a header use the folowing code:
```Delphi
  aHeader := TMySoapHeader.Create;
  aHeader.SomeData := 'data';
  (Webservice as ISOAPHeaders).Send(aHeader);
  resp := Webservice.DoSomeRequest(...);
```

Please note, just like regulare remotable you need to manage the lieftime of the SOAP Header.
When needing to make multiple request using the same header, you can keep the header object and attach it **before sending each request**.

As an alternative to using the header only for one request, you can instrcut the serviec to 'own' the header and let it free the header once the reqquest has been made:
```Delphi
  (Webservice as ISOAPHeaders).OwnsSentHeaders := True;
```

## Server use
<todo>
