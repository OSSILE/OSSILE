# OSSILE

## RPG Examples

- BBCNEWS 

- CALCWEEK --- Calculate Weekend- and Start
  The start and end date of the week is calculated via the CEE API. Either the 
  current week is used for calculation or a date can be passed to the program in ISO0   format (`yyyyMMdd`).

- COMPTIMARR --- Compile Time Arrays
  Arrays of type character and (unsigned) integer are fill with values at compile
  time.

- DSPMEMUSG --- Display Memory Usage
  The used memory grouped by activiation group is displayed. The data is retrieved
  by querying the activation groups via operating system API.

- DTAARA --- Work with Data Areas
  A data area is read and filled. The data area will be created if it does not exist.

- DYNMEM --- Dynamic Memory Management
  Memory is dynamically allocated, reallocated and deallocated. The default heap
  storage is used.

- DYNMEMCEE 
  This example performs the same functionality as the example `DYNMEM` but uses a
  user-created heap for storage allocation. The CEE API is used to work with the 
  user-created heap.

- DYNDSARR
- 
- hello --- Hello World
  A typical hello world program.

- HTTPGETBLOB

- interfaces --- Interfaces in RPG
  This example show how to decouple the caller from an API implementation and thus
  making it possible to switch or add more API implementations without touching the
  calling program.

- interoperability --- Language Interoperability
  A C function is called from and RPG program.

- INTTOHEX --- Integer to Hex
  The hex representation of an integer is calculated via the `_itoa` C function.

- SOAPREQUEST

- POSKEYWORD
