**FREE

///
// Dynamic Memory Example
//
// This example shows how to allocate, reallocate and deallocate memory from
// the heap storage.
//
// For any memory operation built-in functions and opcodes are used. DSPLY is
// used to output any result.
//
// \author Mihael Schmidt
// \date 2016-12-17
///

ctl-opt main(main);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('DYNMEM') end-pr;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  // this pointer is the access point to the allocated memory
  dcl-s ptr pointer;
  dcl-s firstName char(10) based(ptr);
  dcl-s fullName char(20) based(ptr);
  
  // now we are taking 10 bytes from the heap storage. From the ILE RPG Language Reference:
  // "%ALLOC returns a pointer to newly allocated heap storage of the length specified. 
  //  The newly allocated storage is uninitialized."
  ptr = %alloc(10);
  
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
  
  
  // we use %realloc to enlarge the space we previously allocated the value we 
  // previously assigned to the memory will remain after the reallocation.
  //
  // Note: It is important to use the pointer returned by the %realloc built-in
  //       function as this may not be the same pointer we got previously on the
  //       %alloc built-in function call.
  ptr = %realloc(ptr : 20);
  
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
  dealloc ptr;
end-proc;
