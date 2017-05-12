**FREE

///
// Assert Module
//
//
// \author Mihael Schmidt (contributor)
//
// \info The original source is maintained in the RPGUnit project.
///


ctl-opt nomain;


//
//   Prototypes
//
/include 'assert_h.rpgle'
/include 'system_h.rpgle'
/include 'message/message_h.rpgle'

dcl-pr getCallStack likeds(assert_callStackEntry_t) dim(ASSERT_MAX_CALL_STACK_SIZE) end-pr;


///
// Exported data structure to access additional information about 
// the called assertions and the fail event (like the callstack.
///
dcl-ds assert_info likeds(assert_info_t) export('assert_info') inz;


//
// Constants
//

// Quote (') symbol.
dcl-c quote const('''');


//
// Procedures
//

///
// Assert equal on alpha values
//
// Assert equality between two alphanumeric values.
//
// \param Expected value
// \param Actual value
/// 
dcl-proc assert_equalsChar export;
  dcl-pi *N;
    expected char(32565) const;
    actual char(32565) const;
  end-pi;
  
  dcl-s message char(256);

  message = 'Expected ' + quote + %trimr(expected) + quote + ','
      + ' but was ' + quote + %trimr(actual  ) + quote + '.';
  assert_assertTrue( expected = actual : message);
end-proc;

///
// Assert condition
//
// Asserts that a condition is true.
//
// \param Condition
// \param Message if false
///
dcl-proc assert_assertTrue export;
  dcl-pi *N;
    condition ind const;
    failMessage char(256) const;
  end-pi;

  assert_info.called += 1;
  clear assert_info.failEvent;

  if (not condition);
    assert_fail(failMessage);
  endif;
end-proc;

///
// Fail 
//
// Signals a test failure and stops the test.
//
// \param Message
///
dcl-proc assert_fail export;
  dcl-pi *N;
    message char(256) const;
  end-pi;
  
  assert_info.failEvent.message = message;
  assert_info.failEvent.callStack = getCallStack();

  message_sendEscapeMessage( message : MESSAGE_TWO_CALL_STACK_LEVEL_ABOVE );
end-proc;

///
// Assert equality between integer values
//
// Assert equality between two integers.
//
// \param Expected value
// \param Actual value
///
dcl-proc assert_equalsInteger export;
  dcl-pi *N;
    expected int(10) const;
    actual int(10) const;
  end-pi;
  
  dcl-s message char(256);

  message = 'Expected ' + %char(expected) + ','
          + ' but was ' + %char(actual  ) + '.';

  assert_assertTrue( expected = actual : message);
end-proc;

///
// Assert equality between decimal values
//
// Assert equality between two decimal values.
//
// \param Expected value
// \param Actual value
///
dcl-proc assert_equalsDecimal export;
  dcl-pi *N;
    expected zoned(15:5) const;
    actual zoned(15:5) const;
  end-pi;
  
  dcl-s message char(256);

  message = 'Expected ' + %char(expected) + ','
          + ' but was ' + %char(actual  ) + '.';

  assert_assertTrue( expected = actual : message);
end-proc;

///
// Assert equality between double values
//
// Assert equality between two double values.
//
// \param Expected value
// \param Actual value
///
dcl-proc assert_equalsDouble export;
  dcl-pi *N;
    expected float(8) const;
    actual float(8) const;
    allowedDifference float(8) const;
  end-pi;
  
  dcl-s message char(256);
  
  message = 'Expected ' + %char(expected) + ','
          + ' but was ' + %char(actual  ) + '.';

  assert_assertTrue( %abs(expected - actual) <= allowedDifference : message);
end-proc;


dcl-proc getCallStack;
  dcl-pi *N likeds(assert_callStackEntry_t) dim(ASSERT_MAX_CALL_STACK_SIZE) end-pi;

  // Call stack entries
  dcl-ds callStkEnt likeds(assert_callStackEntry_t) dim(ASSERT_MAX_CALL_STACK_SIZE);
  // Job id
  dcl-ds jobIdInfo likeds(dsJIDF0100);
  // Call stack info header
  dcl-ds hdr likeds(dsCSTK0100Hdr) based(hdr_p);
  // Call stack info entry
  dcl-ds ent likeds(dsCSTK0100Ent) based(ent_p);
  // Big buffer to receive call stack info
  dcl-s rawCallStk char(5000);
  // Statement Id
  dcl-s sttId char(10) based(sttId_p);
  // Procedure name buffer
  dcl-s procNmBuffer char(256) based(procNmBuffer_p);
  
  dcl-s i int(10);

  dcl-ds qusec qualified;
    bytesProvided int(10);
    bytesAvailable int(10);
    exceptionId char(7);
    reserved char(1);
  end-ds;

  jobIdInfo.jobNm = '*';
  jobIdInfo.usrNm = *blank;
  jobIdInfo.jobNb = *blank;
  jobIdInfo.intJobId = *blank;
  jobIdInfo.reserved = *loval;
  jobIdInfo.threadInd = 1;
  jobIdInfo.threadId  = *loval;

  clear qusec;

  QWVRCSTK( rawCallStk :
            %size(rawCallStk) :
            'CSTK0100' :
            jobIdInfo :
            'JIDF0100' :
            qusec );

  hdr_p = %addr(rawCallStk);
  ent_p = hdr_p + hdr.callStkOff;

  // TODO Refactor the following piece of code.
  // Skip the first call stack entry (this procedure).
  ent_p += ent.len;
  // Skip the next call stack entry (the fail procedure).
  ent_p += ent.len;

  for i = 1 to (hdr.nbCallStkEntRtn - 2);    // TODO : min(header.nbCallStkEntRtn,MAX_CALL_STK

    callStkEnt(i).programName = ent.pgmNm;
    callStkEnt(i).moduleName = ent.modNm;

    if ent.procNmLen <> 0;
      procNmBuffer_p = ent_p + ent.dsplToProcNm;
      callStkEnt(i).procedureName = %subst( procNmBuffer: 1: ent.procNmLen );
    else;
      callStkEnt(i).procedureName = *blank;
    endif;

    if ent.nbSttId > 0;
      sttId_p = ent_p + ent.dsplToSttId;
      callStkEnt(i).statementId = sttId;
    else;
      callStkEnt(i).statementId = *blank;
    endif;

    ent_p += ent.len;

  endfor;

  return callStkEnt;
end-proc;
