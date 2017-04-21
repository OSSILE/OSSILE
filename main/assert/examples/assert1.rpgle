**FREE

///
// Assert Example : Integer assertion
//
// This example code shows how to make a simple assertion with to integer values
// and how to access the information data structure.
//
// \author Mihael Schmidt
///

dcl-pr main end-pr;

/include 'assert_h.rpgle'

dcl-ds assert_info_consumer likeds(assert_info_t) import('assert_info');

main();
*inlr = *on;
return;


dcl-proc main;
  dcl-s i int(10) inz(0);

  dsply %trimr('#asserts: ' + %char(assert_info_consumer.called));
  
  assert_equalsInteger(0 : i);
  dsply %trimr('#asserts: ' + %char(assert_info_consumer.called));

  i += 1;

  assert_equalsInteger(1 : i);
  dsply %trimr('#asserts: ' + %char(assert_info_consumer.called));

  // this one fails
  assert_equalsInteger(2 : i);
end-proc;
