**FREE

///
// Compile Time Array Example
//
// Example for showing how to initialize an array at compile time by using the
// CTDATA keyword on array declaration. Integer and character arrays are used
// in this example.
//
// For a detailed description on how to declare and fill a compile time array
// see the ILE RPG Language Reference (Definitions -> Using Arrays and Tables
// -> Arrays -> Coding a Compile-Time Array).
//
// Note: Numeric values (like integers) must be coded right aligned with enough
//       spaces to fill up the entire size. F. e. data for an array of int(10)
//       must use 10 digits/spaces, like _______123.
//
// \author Mihael Schmidt
// \date 2016-12-13
///


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main end-pr;


//-------------------------------------------------------------------------------------------------
// Global Variables
//-------------------------------------------------------------------------------------------------
//
// Note: compile-time arrays must be globally declared
//
dcl-s httpCodes uns(10) dim(58) ctdata;
dcl-s httpMessages char(50) dim(58) ctdata;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
main();
*inlr = *on;
return;


//-------------------------------------------------------------------------------------------------
// Procedures
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-s message char(50);
  
  message = 'HTTP code at index 4: ' + %char(httpCodes(4));
  dsply message;
  
  message = 'Index for HTTP Code 200: ' + %char(%lookup(200 : httpCodes));
  dsply message;
  
  message = 'HTTP code at index 57: ' + %char(httpCodes(57));
  dsply message;
  
  message = 'HTTP code at index 58: ' + %char(httpCodes(58));
  dsply message;
  
  message = 'HTTP message at index 7: ' + httpMessages(7);
  dsply message;
end-proc;

**CTDATA httpCodes
       200
       201
       202
       203
       204
       205
       206
       207
       208
       226
       300
       301
       302
       303
       304
       305
       306
       307
       308
       400
       401
       402
       403
       404
       405
       406
       407
       408
       409
       410
       411
       412
       413
       414
       415
       416
       417
       418
       421
       422
       423
       424
       426
       428
       429
       431
       451
       500
       501
       502
       503
       504
       505
       506
       507
       508
       510
       511
**CTDATA httpMessages
OK
Created
Accepted
Non-Authoritative Information
No content
Reset content
Partial content
Multi status
Already reported
IM used
Multiple choices
Moved permanently
Found
See other
Not modified
Use proxy
Switch proxy
Temporary redirect
Permanent redirect
Bad request
Unauthorized
Payment required
Forbidden
Not found
Method not allowed
Not acceptable
Proxy authentication required
Request timeout
Conflict
Gone
Length required
Precondition failed
Payload too large
URI too long
Unsupported media type
Range not satisfiable
Expectation failed
I am a teapot
Misdirected request
Unprocessable Entity
Locked
Failed dependency
Upgrade required
Precondition required
Too many requests
Request header fields too large
Unavailable for legal reasons
Internal server error
Not implemented
Bad Gateway
Service unavailable
Gateway timeout
HTTP version not supported
Variant also negotiates
Insufficient storage
Loop detected
Not extended
Network authentication required
