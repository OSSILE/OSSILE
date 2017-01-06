**FREE

/if not defined (INPUT_T)
/define INPUT_T

///
// \brief Input Interface : Templates and Data Structures
// 
// This copy book contains the data structures which are used by the input
// interface module but also by the interface implementations and the main
// program.
// 
// \author Mihael Schmidt
// \date 20.11.2016
///

//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
dcl-ds input_t qualified template;
  userData pointer;
  proc_load pointer(*proc);
  proc_finalize pointer(*proc);
end-ds;

dcl-ds item_t qualified template;
  id char(10);
  description char(100);
  vendor char(50);
end-ds;

/endif
