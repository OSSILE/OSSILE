**FREE

///
// \brief Input Interface
// 
// This module forwards the procedure call to the implementation which is passed
// as a parameter to the interface procedure.
//
// \author Mihael Schmidt
// \date 20.11.2016
///


ctl-opt nomain;


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
/include 'input_t.rpgle'


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
/include 'input_h.rpgle'


//-------------------------------------------------------------------------------------------------
// Procedures
//-------------------------------------------------------------------------------------------------
dcl-proc input_load export;
  dcl-pi *N likeds(item_t);
    inputProvider pointer const;
  end-pi;

  dcl-ds inputDs likeds(input_t) based(inputProvider);
  dcl-s procPointer pointer(*proc);
  dcl-pr load likeds(item_t) extproc(procPointer);
    inputProvider pointer const;
  end-pr;

  procPointer = inputDs.proc_load;

  return load(inputProvider);
end-proc;


dcl-proc input_finalize export;
  dcl-pi *N;
    inputProvider pointer;
  end-pi;

  dcl-ds inputDs likeds(input_t) based(inputProvider);
  dcl-s procPointer pointer(*proc);
  dcl-pr finalize pointer extproc(procPointer);
    inputProvider pointer;
  end-pr;

  procPointer = inputDs.proc_finalize;

  finalize(inputProvider);

  if (inputProvider <> *null);
    dealloc(ne) inputProvider;
  endif;
end-proc;
