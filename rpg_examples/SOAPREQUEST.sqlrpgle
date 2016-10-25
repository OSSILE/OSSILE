**FREE

Ctl-Opt DftActGrp(*No);

Dcl-S gData    SQLTYPE(CLOB:15728640);
Dcl-S gLen     Uns(10);

Dcl-Ds Request Qualified;
  URL  Char(128);
  Head Char(1024);
  Body Char(1024);
END-DS;

Request.Body = '<?xml version="1.0" encoding="UTF-8" ?>'
     + '<soap:Envelope xmlns:soap='
     + '"http://schemas.xmlsoap.org/soap/envelope/" '
     + 'xmlns:xsi='
     + '"http://www.w3.org/2001/XMLSchema-instance" '
     + 'xmlns:xsd='
     + '"http://www.w3.org/2001/XMLSchema" '
     + 'xmlns:wiz="http://blah.ws">'

       + '<soap:Body>'
         + '<thing:addressInput>'
           + '<Locale>pl</Locale>'
           + '<ServiceAddressId>0</ServiceAddressId>'
           + '<AccountNumber>1234</AccountNumber>'
           + '<MemoOpenDate>2016-01-01</MemoOpenDate>'
         + '</thing:addressDetailInput>'
       + '</soap:Body>'
     + '</soap:Envelope>';

Request.Head = '<httpHeader>'
               + '<header name="Content-Type" '
               + 'value="text/xml;charset=UTF-8" />'

               + '<header name="Content-Length" value="'
               + %Char(%Len(%TrimR(Request.Body))) + '" />' //Length of the body

               + '<header name="Accept-Encoding" value="gzip,deflate" />'
             + '</httpHeader>';

Request.URL = 'http://yourserver:1234/SomeWS/SomeWebServices';

EXEC SQL SET :gData = SYSTOOLS.HTTPPOSTCLOB(
							 :Request.URL,
							 :Request.Head,
                    :Request.Body
						  );

gLen = gData_Len;


*InLR = *On;
Return; 
