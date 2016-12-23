**FREE

///
// Language Interoperability Example
//
// This is the main module for the language interoperability example. It shows
// how a C function can be called from an RPG module. The example consists of
// two modules:
//
// - INTEROPC1 - C module with testStructures function
// - INTEROPR1 - RPG module with the main procedure which calls the C function
//
// It also shows how member alignment of a C struct has to be taken into account
// when defining the RPG equivalent data structure (because the C compiler and
// the RPG compiler handles member alignment differently).
//
// Building: The modules have to be compiled with the corresponding commands
// (CRTCMOD and CRTRPGMOD). Make sure to use the same storage model (I use
// *TERASPACE for that). The modules have to be bound to a program using 
// CRTPGM. Keep in mind that you have to specify which module has the program
// entry point (INTEROPR1).
//
// \author Mihael Schmidt
// \date 2016-12-16
///


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------

// struct string {
//   char * value;
//   size_t length;
// };
dcl-ds string_t qualified template align;
  value pointer;
  length int(10);
  dummy1 char(12); // to fill up the 16 byte to the next boundary
end-ds;

// struct message {
//   int id;
//   char * value;
//   struct string parts[3];
//   int checksum;
// } message_t;
dcl-ds message_t qualified template align;
  id int(10);
  dummy1 char(12); // need this dummy to get the next pointer on the next 16 byte boundary aligned
  value pointer;
  parts likeds(string_t) dim(3);
  checksum int(10);
end-ds;


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main end-pr;
// struct message * testStructures();
dcl-pr testStructures pointer extproc('testStructures') end-pr;


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
  dcl-ds message likeds(message_t) based(ptr);
  dcl-s d char(50);
  
  ptr = testStructures();
  
  dsply %char(message.id);
  d = %str(message.value);
  dsply d;
  d = %str(message.parts(1).value : message.parts(1).length);
  dsply d;
  d = %str(message.parts(2).value : message.parts(2).length);
  dsply d;
  d = %str(message.parts(3).value : message.parts(3).length);
  dsply d;
  dsply %char(message.checksum);
  
  dealloc ptr;
end-proc;
