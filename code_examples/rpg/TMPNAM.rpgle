**FREE

///
// Generate Temporary File Names
//
// The C function _tmpnam()_ generates a filename for the QSYS.LIB filesystem.
// The function returns a pointer to a name or _*NULL_ if no name could be 
// generated.
//
//
// File names for the QSYS.LIB file system
//
// The file name is always 16 characters and starts with _QTEMP_. The syntax for
// the name is: QTEMP/QACXxxxxxx .
//
//
// File names for the IFS file system
//
// The file name itself is 10 characters and has the same naming scheme as for
// the QSYS.LIB file system (QACXxxxxxx). The directory for the file is _/tmp_.
// Example: /tmp/QACXDQKCXT
//
//
// Get the file name
// 
// As _tmpnam()_ returns a pointer to the file name it is easy to get the value
// by using the _%str_ built-in function like
//
//     filename = %str(tmpnamIfs(*omit));
//
//
// Note: The C functions tmpnam() and _C_IFS_tmpnam only generates a temporary 
//       file name for a file in the corresponding file system. The file will 
//       __not__ be created by this function.
//
//
// \author Mihael Schmidt
// \date   2016-12-23
//
// \link http://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/rtref/tmpnam9.htm Produce Temporary File Name
///


ctl-opt main(main) dftactgrp(*no) actgrp(*caller);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('TMPNAM') end-pr;

dcl-pr tmpnam pointer extproc('tmpnam');
  buffer char(39) options(*omit);
end-pr;
      
dcl-pr tmpnamIfs pointer extproc('_C_IFS_tmpnam');
  buffer char(39) options(*omit);
end-pr;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-s message char(50);

  dsply 'Temporary file name for QSYS.LIB:';
  message = %str(tmpnam(*omit));
  dsply message;

  dsply 'Temporary file name for IFS:';
  message = %str(tmpnamIFS(*omit));
  dsply message;
end-proc;
