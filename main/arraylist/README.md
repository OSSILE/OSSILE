# Arraylist

An ArrayList is a one-dimensional array. In our case it is also a dynamic array
which means that the size is not set at compile time but at runtime and it can 
grow if required.

An array allocates memory for all its elements lumped together as one 
block of memory. In this implementation only the pointer to the data is 
stored in this one block of memory. In this way millions of entries can be 
stored and accessed.

## Features

The following features are available in the ArrayList service program
(in no particular order):

- Creating an ArrayList
- Adding entries (beginning, end, by index)
- Replacing entries
- Removing entries (beginning, end, by index, range)
- Creating a new ArrayList with a subset of another ArrayList
- Clearing
- Check fill status (empty or not empty)
- Get entry (beginning, end, by index)
- Check if the ArrayList contains an entry
- Get index of an entry
- Get last index of an entry
- Copy all entries to a character array
- Swap entries
- Execute a procedure on every entry
- Reverse entry order
- Create ArrayList from a character string
- Copy
- Count the frequency of an entry
- Data type specific procedures for storing and getting values

The ArrayList service program has no special procedures for iterating through
all elements as in the Linked List service program because the access to any 
entry in the ArrayList is constant and can be made with passing the index of 
the desired	entry.

## Implementation
			
The ArrayList service program uses dynamic memory allocation via the 
built-in functions. Because of that it is necessary to use the dispose 
procedure after using the ArrayList for freeing up the allocated memory. 
If the memory is not freed with the dispose procedure it will be released 
with the ending of the activation group or job.

The create() procedure of the ArrayList has two optional parameters:

1. Init size: the initial size of the ArrayList (default: 10)
2. Increment size: the space for the number of entries which will be added if there is no space left for a new entry (default: current size * 2)

Both parameters are optional and need not to be passed.

The code is written in RPG IV /free format. It uses some C-functions
for working with memory and strings and intensely uses pointers.

## Code sample

```
// creating an arraylist
arraylist = arraylist_create();

// check if the arraylist is empty (it should be)
if (arraylist_isEmpty(arraylist));
  dsply 'ArrayList is empty';
else;
  dsply 'ArrayList is not empty';
endif;

// add a string to the arraylist
arraylist_addString(arraylist : 'This a test string.');

// add a data structure to the arraylist
arraylist_add(arraylist : %addr(my_data_structure) : 
                          %size(my_data_structure));

// add an integer to the arraylist
arraylist_add(arraylist : %addr(my_int_var) : %size(my_int_var));

// add an integer with the data type specific procedure
arraylist_addInteger(arraylist : my_int_var);

// create a new arraylist which is populated with 
// a subset of data from the original arraylist
subset = arraylist_sublist(arraylist : 2);

// iterate through the entries of the list
for i = 0 to arraylist_getSize(arraylist) - 1;
  value = %str(arraylist_get(arraylist : i));
  dsply value;
endfor;

// freeing the allocated memory
arraylist_dispose(arraylist);
```

## Large ArrayList

As this service program relies on allocating a large single block of 
memory it can only hold some 100.000 entries. If the application needs to
add some millions of entries then the service program and all calling programs
must be compiled with teraspace support. Using compile options this is only
available starting with OS release 7.1. See the compile and link/bind flags 
in the Makefile (STGMDL). 

### Storage Model

The storage model parameter specifies how memory will be allocated
(static and dynamic memory). The parameter accepts the values *SNGLVL, 
*INHERIT, *TERASPACE. The values *SNGLVL and *TERASPACE should be clear.

The value *INHERIT tells the operating system that the service program will
use the storage model of the activation group it is executed in.

> Only programs and  service programs with the same storage model can be 
> executed in the same activation group. If the calling program is compiled
> with STGMDL(*SNGLVL) and the service program with STGMDL(*TERASPACE) then
> the service program must run in an activation group with the teraspace 
> storage model.

## Alternative Installation Instructions

The service program comes as source files (stream files). The alternative installation script is a Makefile. The destination library and the
destination folder for the copy book should be adjusted in the Makefile or 
be passed as parameters. To create/install the service program just enter 
QSH or PASE Shell and go to the directory where the sources/Makefile are 
located. Then call "make".

    make BIN_LIB=MSCHMIDT2 INCLUDE=/home/mschmidt/include

## Requirements

This software has no further dependencies. It comes with all necessary files.

## Examples
The _examples_ folder contains some examples of how to use the service program procedures.

## Documentation
[API documentation](http://iledocs.sourceforge.net/docs/index.php?program=/QSYS.LIB/SCHMIDTM.LIB/QRPGLESRC.FILE/ARRAYLIST.MBR)
of the ArrayList service program can be found at the open documentation
library [ILEDocs at Sourceforge.net](http://iledocs.sourceforge.net).

## License

This service program is released under the MIT License.
