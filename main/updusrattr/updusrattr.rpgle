**FREE

///
// Update User-Defined Attribute
//
// Tags the specified object with the passed value. The tag will be
// placed in the user defined attribute of the object. The user
// defined attribute only allows 10 characters to be stored.
//
// \author Mihael Schmidt
// \date 16.03.2017
///


ctl-opt dftactgrp(*no) actgrp(*caller) main(main);


//------------------------------------------------------------------------------
// Templates
//------------------------------------------------------------------------------
dcl-ds qusec qualified template;
  bytesProvided int(10);
  bytesAvailable int(10);
  exceptionId char(7);
  reserved char(1);
end-ds;


//------------------------------------------------------------------------------
// Prototypes
//------------------------------------------------------------------------------
dcl-pr main extpgm('UPDUSRATTR');
  library char(10) const;
  object char(10) const;
  type char(10) const;
  tag char(10) const;
end-pr;

dcl-pr changeObjectDesc extpgm('QLICOBJD');
  returnedLibraryName char(10);
  qualObjectName char(20) const;
  objectType char(10) const;
  changeObjectInfo char(32767) options(*varsize);
  error likeds(QUSEC);
end-pr;


//------------------------------------------------------------------------------
// PEP
//------------------------------------------------------------------------------
dcl-proc main;
  dcl-pi *N;
    library char(10) const;
    object char(10) const;
    type char(10) const;
    tag char(10) const;
  end-pi;

  dcl-s lib char(10);
  dcl-ds errorCode likeds(qusec);
  dcl-ds objectInfo qualified;
    keys int(10);
    type1 int(10);
    length1 int(10);
    attribute char(10);
  end-ds;
  
  objectInfo.keys = 1;
  objectInfo.type1 = 9;
  objectInfo.length1 = 10;
  objectInfo.attribute = tag;

  clear errorCode;
  errorCode.bytesProvided = 0;

  changeObjectDesc(lib : object + library : type : objectInfo : errorCode);
end-proc;
