**FREE

///
// Dynamic Memory Example using CEE API
//
// This example shows how to allocate, reallocate and deallocate memory from
// a user-created heap storage from the Common Execution Environment (CEE).
//
// The advantage of using a user-created heap instead of the default heap storage
// is that not every allocation needs to be tracked as the system does it for you.
// After finishing the processing only the heap needs to be discarded and not 
// every single allocation separately.
//
// See "Managing Your Own Heap Using ILE Bindable APIs" at 
// http://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/rzasc/dynarr.htm .
//
// For any memory operation the CEE API is used. The DSPLY opcode is used to 
// output any result.
//
// By using the CEE API "Mark Heap" and "Release Heap" a range of allocations
// beginning from the mark can be freed/released.
//
// \author Mihael Schmidt
// \date 2016-12-17
///


ctl-opt main(main) dftactgrp(*no) actgrp(*caller);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('DYNMEMCEE') end-pr;

dcl-pr cee_getStorage extproc('CEEGTST');
  heapId int(10) const;
  size int(10) const;
  retAddr pointer;
  feedback char(12) options(*omit);
end-pr;

dcl-pr cee_freeStorage extproc('CEEFRST');
  address pointer;
  feedback char(12) options(*omit);
end-pr;

dcl-pr cee_reallocateStorage extproc('CEECZST');
  address pointer;
  size int(10) const;
  feedback char(12) options(*omit);
end-pr;

dcl-pr cee_createHeap extproc('CEECRHP');
  heapId int(10);
  initSize int(10) const options(*omit);
  increment int(10) const options(*omit);
  allocStrat int(10) const options(*omit);
  feedback char(12) options(*omit);
end-pr;

dcl-pr cee_discardHeap extproc('CEEDSHP');
  heapId int(10);
  feedback char(12) options(*omit);
end-pr;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  // heap id
  dcl-s heapId int(10);
  // this pointer is the access point to the allocated memory
  dcl-s ptr pointer;
  dcl-s firstName char(10) based(ptr);
  dcl-s fullName char(20) based(ptr);

  // get a heap via CEE API
  cee_createHeap(heapId : *omit : *omit : *omit : *omit);

  // now we are taking 10 bytes from the user-created heap. 
  //
  // From the ILE RPG Language Reference:
  // "%ALLOC returns a pointer to newly allocated heap storage of the length specified.
  //  The newly allocated storage is uninitialized."
  cee_getStorage(heapId : 10 : ptr : *omit);

  // The %str built-in function lets us assign a value to the storage to which the pointer points
  %str(ptr : 9) = 'William';
  // the %str built-in function is normally used in conjunction with the C language and
  // adds a NULL (x'00') at the end of the value.
  dsply firstName;

  // To not have this NULL value at the end we could use the "memcpy" C function
  // but if we are working with fixed length fields (which is the common case in
  // RPG) it is much easier to access the value by using a variable which is
  // based on the pointer (ptr) by using the BASED keyword on the variable declaration
  firstName = 'William';

  // no more NULL value
  dsply firstName;


  // The difference is more obvious in the debugger:
  // With %str : E6899393 89819400 0000.... ........   - William.........
  // With BASED: E6899393 89819440 4040.... ........   - William   ......


  // we use the CEE API CEECZST to enlarge the space we previously allocated the 
  // value we previously assigned to the memory will remain after the reallocation.
  cee_reallocateStorage(ptr : 20 : *omit);

  // reassure that we still have the same value
  dsply firstName;

  // using the enlarged space by using a bigger variable which is based on the pointer
  fullName = 'William Shakespeare';
  dsply fullName;

  // Never forget to free/deallocate the taken memory from the heap. Not freeing
  // the memory will cause a memory leak as it is allocated but you have no
  // pointer to the memory any more.
  //
  // It will automatically be freed with the ending of the job.
  //
  // When using a user-created heap it is enough to just discard the heap for
  // freeing the allocated storage.
  cee_discardHeap(heapId : *omit);
end-proc;
