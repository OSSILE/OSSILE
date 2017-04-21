**FREE

/if not defined (ASSERT)
/define ASSERT

dcl-c ASSERT_MAX_CALL_STACK_SIZE 99;

dcl-ds assert_callStackEntry_t qualified template;
  programName char(10);
  moduleName char(10);
  procedureName char(256);
  statementId char(10);
end-ds;

dcl-ds assert_failEvent_t qualified template;
  message char(256);
  callStack likeds(assert_callStackEntry_t) dim(ASSERT_MAX_CALL_STACK_SIZE);
end-ds;


//
// Template for exported information data structure
//
dcl-ds assert_info_t qualified template;
  called int(10);
  failEvent likeds(assert_failevent_t);
end-ds;


//
// Prototypes
//
dcl-pr assert_equalsChar extproc(*dclcase);
  expected char(32565) const;
  actual char(32565) const;
end-pr;

dcl-pr assert_assertTrue extproc(*dclcase);
  condition ind const;
  msgIfFalse char(256) const;
end-pr;

dcl-pr assert_fail extproc(*dclcase);
  message char(256) const;
end-pr;

dcl-pr assert_equalsInteger extproc(*dclcase);
  expected int(10) const;
  actual int(10) const;
end-pr;

dcl-pr assert_equalsDecimal extproc(*dclcase);
  expected zoned(15:5) const;
  actual zoned(15:5) const;
end-pr;

dcl-pr assert_equalsDouble extproc(*dclcase);
  expected float(8) const;
  actual float(8) const;
  allowedDifference float(8) const;
end-pr;

/endif
      