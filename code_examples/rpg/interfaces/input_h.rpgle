**FREE

/if not defined (INPUT_H)
/define INPUT_H

///
// \brief Input Interface : Prototypes
// 
// \author Mihael Schmidt
// \date 20.11.2016
///

//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------

///
// \brief Loading input data from resource
//
// This procedure returns the next input data from the resource. It returns one
// item at a time.
//
// \param Input provider
//
// \return item_t - the data structure is empty if no more items are available
///
dcl-pr input_load likeds(item_t) extproc('input_load');
  inputProvider pointer const;
end-pr;

///
// \brief Clean up
// 
// This procedure will clean up and free any resources.
//
// \param Input provider
///
dcl-pr input_finalize extproc('input_finalize');
  inputProvider pointer;
end-pr;

/endif
