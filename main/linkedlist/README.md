# Linked List

Linked lists and arrays are similar since they both store collections of data. 
The terminology is that arrays and linked lists store "elements" on behalf of 
"client" code. 

An array allocates memory for all its elements lumped together as one block of 
memory. In contrast, a linked list allocates space for each element separately 
in its own block of memory called a _linked list element_ or _node_. The list 
gets is overall structure by using pointers to connect all	its nodes together 
like the links in a chain.

A more sophisticated kind of linked list is a doubly-linked list or two-way 
linked list. Each node has two links: one points to the previous node, or points
to a null value or empty list if it is the first node, and one points to the 
next, or points to a null value or empty list if it is the final node.

For a more detailed description see [Wikipedia: Linked List](http://en.wikipedia.org/wiki/Linked_list) 
or the [Stanford CS education library](http://cslibrary.stanford.edu/103/).


## Features

The following features are available in the linked list service program
(in no particular order):

- Creating a linked list
- Adding to the linked list (beginning, end, by index)
- Adding all entries of another list
- Replaceing entries of the list
- Removing entries from the list (beginning, end, by index)
- Creating a sublist
- Rotating the list
- Clear the list
- Check size of the list
- Check fill status of list (empty or not empty)
- Get entry of the list (beginning, end, by index)
- Check if the list contains an item
- Iterate through the list (forward and backward)		
- Get index of an entry
- Get last index of an entry
- Copy all entries to a character array
- Swap entries in the list
- Execute a procedure on all entries of the list
- Reverse list
- Create a list from a character string
- Create a copy of a list
- Count the frequency of an entry in the list
- Data type specific procedures for storing and getting values
- Sort list
- Merge two lists


## Implementation

The implemented list is a doubly-linked list. Entries are stored in dynamically 
allocated memory (allocated via %alloc). Because of that it is necessary to use 
the dispose procedure after using the list for freeing up the allocated memory.
If the memory is not freed with the dispose procedure it will be released with 
the ending of the activation group or job.

The code is written in RPG IV free format. It uses some C-functions for working
with memory and strings and intensely uses pointers.


## Code sample
```
// creating a list
listPtr = list_create();

// check if the list is empty (it should be)
if (list_isEmpty(listPtr));
  dsply 'List is empty';
else;
  dsply 'List is not empty';
endif;

// create a new list which is populated with 
// a subset of data from the original list
sublistPtr = list_sublist(listPtr : 2);

// iterate through the entries of the list
valuePtr = list_iterate(sublistPtr);
dow (valuePtr &lt;&gt; *null);
  value = %str(valuePtr);
  dsply value;
  valuePtr = list_iterate(sublistPtr);
enddo;

// freeing the allocated memory
list_dispose(listPtr);
```


## Documentation

[API documentation](http://iledocs.sourceforge.net/docs/index.php?program=/QSYS.LIB/FIST1.LIB/QRPGLESRC.FILE/LLIST.MBR)
of the Linked List service program can be found at [ILEDocs](http://iledocs.sourceforge.net/docs/)
on Sourceforge.net. The documentation is generated from the source code.
