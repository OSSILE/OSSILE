**FREE

///
// Convert Case of Characters
//
// This example shows how to convert the case of a string of characters 
// including any language specific characters (like German Umlaute). The
// conversion is done with the C function _QlgConvertCase_.
// 
// The resulting case (lower or upper) is controlled by a data structure
// (request control block).
// 
// The example outputs the character string before and after the conversion.
//
// \author Mihael Schmidt
// \date   2016-12-23
//
// \link http://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/apis/QLGCNVCS.htm 
//Convert Case API
///


ctl-opt main(main) dftactgrp(*no) actgrp(*caller);


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
// OS API Error Data Structure
/include QSYSINC/QRPGLESRC,QUSEC

dcl-ds requestControlBlock_t qualified template;
  type int(10) inz(1);
  ccsid int(10) inz(0);
  case int(10) inz(0);
  res1 char(10) inz(*ALLX'00');
end-ds;

//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('CONVCASE') end-pr;

dcl-pr convertCase extproc('QlgConvertCase');
  reqContBlock  likeds(requestControlBlock_t) const;
  input char(1024) const options(*varsize);
  output char(1024) options(*varsize);
  length int(10) const;
  errorcode likeds(QUSEC) options(*varsize);
end-pr;
     
//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-s street char(50) inz('Gipfelstürmer Straße 1a');
  dcl-ds errorCode likeds(QUSEC);
  dcl-ds requestControlBlock likeds(requestControlBlock_t) inz(*likeds);
  
  // output prior to case conversion
  dsply 'Street name in mixed case:';
  dsply street;
  
  // convert to upper case
  clear errorCode;
  requestControlBlock.case = 0; // 0 = to uppercase
  convertCase(requestControlBlock : street : street : %len(street) : errorCode);
  dsply 'Street name in upper case:';
  dsply street;

  // convert to lower case
  clear errorCode;
  requestControlBlock.case = 1; // 1 = to lowercase
  convertCase(requestControlBlock : street : street : %len(street) : errorCode);
  dsply 'Street name in lower case:';
  dsply street;
end-proc;
