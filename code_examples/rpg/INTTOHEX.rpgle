**FREE

///
// Integer to Hex String Representation
//
// Example for converting an integer value to its hex representation by using
// the C function _itoa (Convert Integer to String).
//
// Note: The _itoa function is exported as __itoa (double leading underscore)
//       and needs to be stated as such on the EXTPROC keyword. This can be
//       checked by executing DSPSRVPGM QC2UTIL2 and looking and the procedure
//       exports.
//
// \author Mihael Schmidt
// \date 2016-12-13
///


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main end-pr;
dcl-pr itoa pointer extproc('__itoa');
   value int(10) value;
   string pointer value;
   radix int(10) value;
end-pr;


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
  dcl-s x int(10);
  dcl-s string char(34);

  //
  // From the redbook "ILE C and C++ Runtime Library Functions" :
  //
  // char * _itoa(int value, char *string, int radix);
  //

  itoa(9 : %addr(string) : 16);
  dsply string;
  
  itoa(11 : %addr(string) : 16);
  dsply string;
  
  itoa(17 : %addr(string) : 16);
  dsply string;
  
  itoa(34 : %addr(string) : 16);
  dsply string;
  
  itoa(123434 : %addr(string) : 16);
  dsply string;
  
end-proc;
