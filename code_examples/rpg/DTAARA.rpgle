**FREE

///
// Working with Data Areas
//
// This example shows how to use data areas in an RPG program.
//
// It checks if there is a data area in QTEMP with the name DTAARAEXMP. If it
// does not exist it will be created.
//
// The program will read the content of the data area and output it via DSPLY.
// Then the data area will get the current timestamp as the new content via the
// OUT opcode.
//
// Note: Data areas cannot be declared locally in a subprocedure. It must be 
//       declared globally.
//
// \author Mihael Schmidt
// \date 2016-12-21
///


ctl-opt main(main);


//-------------------------------------------------------------------------------------------------
// Global Variables
//-------------------------------------------------------------------------------------------------
dcl-ds exampleDataArea dtaara('QTEMP/DTAARAEXMP') len(50) qualified;
  value char(50);
end-ds;


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('DTAARA') end-pr;

dcl-pr getObjectDescription extpgm('QUSROBJD');
  receiver char(100);
  length int(10) const;
  format char(10) const;
  qualifiedObjectName char(20) const;
  type char(10) const;
end-pr;

dcl-pr executeCommand extpgm('QCMDEXC');
  command char(100) const;
  length packed(15 : 5) const;
end-pr;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-s qualObjectName char(20);
  dcl-s receiver char(100);
  dcl-s command char(100);
  
  // check if data area is available in QTEMP library and if not create it
  monitor;
    // qualified object names in IBM i API are in the format: 
    // object name char(10) + library char(10)
    qualObjectName = 'DTAARAEXMP' + 'QTEMP';
    
    // The Get Object Description API is used to check if the object (data area in our case)
    // exists. If it does not exist an escape message will be triggered.
    getObjectDescription(receiver : %size(receiver) : 'OBJD0100' : qualObjectName : '*DTAARA');
    // data area available
  on-error *all;
    // create data area
    command = 'CRTDTAARA QTEMP/DTAARAEXMP TYPE(*CHAR) LEN(50)';
    executeCommand(command : %size(command));
  endmon;

  // Read the last time stamp from the data area. With the parameter *LOCK the data area gets
  // locked for the time being. It gets unlocked by the OUT opcode.
  //
  // From the IBM redbook "ILE RPG Language Reference" :
  // The reserved word *LOCK can be specified in Factor 1 to indicate that the data area cannot be 
  // updated or locked by another program until (1) an UNLOCK operation is processed, (2) an OUT 
  // operation with no data-area-name operand specified, or (3) the RPG IV program implicitly 
  // unlocks the data area when the program ends.

  in *lock exampleDataArea;
  
  dsply 'Last timestamp: ';
  if (exampleDataArea.value = *blank);
    dsply 'Data area has just been created.';
  else;
    dsply exampleDataArea.value;
  endif;
  
  // update the data area with the current timestamp as a value and
  // automatically unlock the data area
  exampleDataArea.value = %char(%timestamp());
  out exampleDataArea;
end-proc;
